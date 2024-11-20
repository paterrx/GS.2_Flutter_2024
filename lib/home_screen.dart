import 'package:flutter/material.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  List<dynamic> _eletropostos = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchEletropostos();
  }

  Future<void> _fetchEletropostos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simula atraso
      final apiService = ApiService();
      final data = await apiService.fetchEletropostos();
      setState(() {
        _eletropostos = data;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Erro ao carregar os dados: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eletropostos Próximos"),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Carregando dados..."),
                ],
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 40),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchEletropostos,
                          child: const Text("Tentar novamente"),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _eletropostos.length,
                  itemBuilder: (context, index) {
                    final eletroposto = _eletropostos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(eletroposto['nome'] ?? "Nome não disponível"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Endereço: ${eletroposto['endereco'] ?? 'Não disponível'}"),
                            Text("Telefone: ${eletroposto['telefone'] ?? 'Não disponível'}"),
                            Text("Conectores: ${(eletroposto['conectores'] as List<dynamic>?)?.join(', ') ?? 'Não disponível'}"),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}
