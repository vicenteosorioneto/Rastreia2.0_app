import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meus Objetos',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implementar notificações
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: Implementar perfil
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card de pesquisa
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Lista de objetos
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5, // Exemplo com 5 itens
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    // TODO: Navegar para detalhes do objeto
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Objeto ${index + 1}',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Última localização: São Paulo, SP',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Atualizado há 2 horas',
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
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Ativo',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.green[800],
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navegar para tela de adicionar objeto
          Navigator.pushNamed(context, '/add_object');
        },
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Objeto'),
      ),
    );
  }
}
