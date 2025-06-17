import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddObjectScreen extends StatefulWidget {
  const AddObjectScreen({super.key});

  @override
  State<AddObjectScreen> createState() => _AddObjectScreenState();
}

class _AddObjectScreenState extends State<AddObjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  String? _selectedCategory;
  String? _selectedStatus;

  final List<String> _categories = [
    'Eletrônicos',
    'Veículos',
    'Documentos',
    'Outros',
  ];

  final List<String> _status = ['Ativo', 'Inativo', 'Em Manutenção'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adicionar Objeto',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Upload de imagem
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    // TODO: Implementar upload de imagem
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Adicionar Foto',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Nome do objeto
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Objeto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.label_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do objeto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Categoria
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.category_outlined),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma categoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Descrição
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Localização
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Localização',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a localização';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Status
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.info_outline),
                ),
                items: _status.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione um status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botão de salvar
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Implementar salvamento do objeto
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Salvar Objeto',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
