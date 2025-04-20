import 'package:app_chatpdf/ui/_core/app_requesters.dart';
import 'package:app_chatpdf/ui/addPdf/addPdf_screen.dart';
import 'package:app_chatpdf/ui/home/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'user', 'message': text});
        _messages.add({'sender': 'bot', 'message': '⏳ Pensando...'});
      });

      _controller.clear();

      try {
        final resposta = await AppRequesters().fazerPergunta(text);

        setState(() {
          _messages.removeLast(); // Remove "Pensando..."
          _messages.add({'sender': 'bot', 'message': resposta});
        });
      } catch (e) {
        setState(() {
          _messages.removeLast();
          _messages.add({'sender': 'bot', 'message': '❌ Ocorreu um erro: $e'});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatPDF'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AddPdfScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 'limpar') {
                // Ação para limpar a conversa
                setState(() {
                  _messages.clear();
                });
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'limpar',
                    child: Text('Limpar conversa'),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ChatBubble(
                  message: msg['message']!,
                  isUser: msg['sender'] == 'user',
                );
              },
            ),
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Digite sua pergunta...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _sendMessage,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          _controller.text.trim().isNotEmpty
                              ? Colors.blue
                              : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send,
                      color:
                          _controller.text.trim().isNotEmpty
                              ? Colors.white
                              : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
