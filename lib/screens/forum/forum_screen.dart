import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbmuas/view_models/forum_v_model.dart';
import 'package:pbmuas/view_models/auth_v_model.dart'; // kalau belum diimpor
import 'package:pbmuas/models/forum.dart';

class ForumContent extends StatefulWidget {
  const ForumContent({Key? key}) : super(key: key);

  @override
  State<ForumContent> createState() => _ForumContentState();
}

class _ForumContentState extends State<ForumContent> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ForumVModel>(context, listen: false).startListening();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ForumVModel>(context);
    final authVM = context.watch<AuthVModel>();
    final akun = authVM.akun;

    return Scaffold(
      appBar: AppBar(title: const Text('Forum Chat')),
      body: Column(
        children: [
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.messages.isEmpty
                    ? const Center(child: Text("Belum ada pesan."))
                    : ListView.builder(
                        reverse: true,
                        itemCount: vm.messages.length,
                        itemBuilder: (context, index) {
                          final msg = vm.messages[index];
                          final isMe = msg.username == akun?.username;

                          return Container(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Column(
                              crossAxisAlignment:
                                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: isMe ? Colors.blue[200] : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    msg.pesan,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isMe
                                      ? 'Saya • ${msg.waktu}'
                                      : '${msg.username} • ${msg.waktu}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
          if (akun != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Tulis pesan...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        await vm.sendMessage(akun.id ,text, akun.username);
                        _controller.clear();
                      }
                    },
                  )
                ],
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Memuat akun..."),
            ),
        ],
      ),
    );
  }
}
