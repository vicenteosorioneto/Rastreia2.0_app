import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _objects = [];
  bool _loading = false;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _loadObjects();
  }

  Future<void> _loadObjects() async {
    setState(() => _loading = true);
    try {
      final objects = await _apiService.fetchStolenObjects();
      setState(() {
        _objects = objects;
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  void _filterObjects(String value) {
    setState(() {
      _search = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredObjects = _objects.where((obj) {
      final title = (obj['title'] ?? '').toString().toLowerCase();
      return title.contains(_search.toLowerCase());
    }).toList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          },
        ),
        title: Text(
          'Meus Objetos',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  bool notificationsEnabled = true;
                  return StatefulBuilder(
                    builder: (context, setState) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.notifications, color: Colors.blue),
                              SizedBox(width: 12),
                              Text(
                                'Notificações',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          SwitchListTile(
                            title: Text('Ativar notificações'),
                            value: notificationsEnabled,
                            onChanged: (val) =>
                                setState(() => notificationsEnabled = val),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadObjects,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Card de pesquisa
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Pesquisar objetos...',
                          border: InputBorder.none,
                          icon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.filter_list),
                            onPressed: () {
                              // TODO: Implementar filtros
                            },
                          ),
                        ),
                        onChanged: _filterObjects,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Lista de objetos
                  if (filteredObjects.isEmpty)
                    const Center(child: Text('Nenhum objeto cadastrado.'))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredObjects.length,
                      itemBuilder: (context, index) {
                        final obj = filteredObjects[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/object_details');
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Imagem do objeto
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.image_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Informações do objeto
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          obj['title'] ?? 'Sem título',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Descrição: ${obj['body'] ?? ''}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: 16,
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              obj['date'] ??
                                                  'Data não informada',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Status do objeto
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      obj['status'] ?? 'Roubado',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.red[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Após adicionar um objeto, recarrega a lista
          await Navigator.pushNamed(context, '/add_object');
          _loadObjects();
        },
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Objeto'),
      ),
    );
  }
}
