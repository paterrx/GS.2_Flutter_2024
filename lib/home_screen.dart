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
      await Future.delayed(const Duration(seconds: 2));
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
                  Text("Carregando, por favor aguarde...")
                ],
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  itemCount: _eletropostos.length,
                  itemBuilder: (context, index) {
                    final eletroposto = _eletropostos[index];
                    return ListTile(
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
                    );
                  },
                ),
    );
  }
}
