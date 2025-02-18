import 'package:flutter/material.dart';
import 'package:myapp/planet_provider.dart';
import 'planet.dart';
import 'database_helper.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PlanetProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planetas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PlanetListScreen(),
    );
  }
}

class PlanetListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlanetProvider>(context);
    provider.loadPlanets();

    return Scaffold( 
      appBar: AppBar(title: Text('Planetas')),
      body: ListView.builder(
        itemCount: provider.planets.length,
        itemBuilder: (context, index) {
          final planet = provider.planets[index];
          return ListTile(
            title: Text(planet.name),
            subtitle: Text(planet.nickname ?? 'Sem apelido'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlanetDetailScreen(planet: planet),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmation(context, provider, planet.id!);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlanetFormScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, PlanetProvider provider, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirmar exclusão'),
        content: Text('Deseja excluir este planeta?'),
        actions: [
          TextButton(
            onPressed: () {
              provider.deletePlanet(id);
              Navigator.pop(context);
            },
            child: Text('Excluir'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}

class PlanetDetailScreen extends StatelessWidget {
  final Planet planet;

  PlanetDetailScreen({required this.planet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(planet.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${planet.name}'),
            Text('Apelido: ${planet.nickname ?? 'Não informado'}'),
            Text('Distância do Sol: ${planet.distance} AU'),
            Text('Tamanho: ${planet.size} km'),
          ],
        ),
      ),
    );
  }
}

class PlanetFormScreen extends StatefulWidget {
  @override
  _PlanetFormScreenState createState() => _PlanetFormScreenState();
}

class _PlanetFormScreenState extends State<PlanetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _distanceController = TextEditingController();
  final _sizeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Planeta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(labelText: 'Apelido'),
              ),
              TextFormField(
                controller: _distanceController,
                decoration: InputDecoration(labelText: 'Distância do Sol (em AU)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Distância deve ser um número positivo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(labelText: 'Tamanho (em km)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Tamanho deve ser um número positivo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final planet = Planet(
                      name: _nameController.text,
                      distance: double.parse(_distanceController.text),
                      size: double.parse(_sizeController.text),
                      nickname: _nicknameController.text.isEmpty ? null : _nicknameController.text,
                    );
                    Provider.of<PlanetProvider>(context, listen: false).addPlanet(planet);
                    Navigator.pop(context);
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
