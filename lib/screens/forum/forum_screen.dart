import 'package:flutter/material.dart';
import 'package:pbmuas/models/forum.dart';
import 'package:provider/provider.dart';
import 'package:pbmuas/view_models/forum_v_model.dart';
import 'package:pbmuas/view_models/auth_v_model.dart';
import 'package:intl/intl.dart';

class ForumContent extends StatefulWidget {
  const ForumContent({Key? key}) : super(key: key);

  @override
  State<ForumContent> createState() => _ForumContentState();
}

class _ForumContentState extends State<ForumContent>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    Provider.of<ForumVModel>(context, listen: false).startListening();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();

    _controller.addListener(() {
      setState(() {
        _isTyping = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    try {
      // final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final messageDate = DateTime(date.year, date.month, date.day);

      if (messageDate == today) {
        return 'Hari Ini';
      } else if (messageDate == today.subtract(const Duration(days: 1))) {
        return 'Kemarin';
      } else {
        return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
      }
    } catch (e) {
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    }
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  bool _shouldShowDateSeparator(int index, List<ForumModel> messages) {
    if (index == messages.length - 1) return true;

    try {
      final currentDate = messages[index].createdAt;
      final nextDate = messages[index + 1].createdAt;

      return currentDate.day != nextDate.day ||
          currentDate.month != nextDate.month ||
          currentDate.year != nextDate.year;
    } catch (e) {
      return false;
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ForumVModel>(context);
    final authVM = context.watch<AuthVModel>();
    final akun = authVM.akun;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Forum Chat',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              vm.startListening();
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Header Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade600, Colors.blue.shade400],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.forum_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Forum Diskusi',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Berbagi dan diskusi dengan sesama',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (vm.messages.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${vm.messages.length} pesan',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Messages Area
            Expanded(
              child:
                  vm.isLoading
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue.shade600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Memuat pesan...',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                      : vm.messages.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 60,
                                color: Colors.blue.shade300,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Belum ada pesan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Mulai percakapan dengan mengirim pesan pertama',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: vm.messages.length,
                        itemBuilder: (context, index) {
                          final msg = vm.messages[index];
                          final isMe = msg.username == akun?.username;
                          final showDateSeparator = _shouldShowDateSeparator(
                            index,
                            vm.messages,
                          );

                          return Column(
                            children: [
                              // Date Separator
                              if (showDateSeparator)
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey.shade300,
                                          thickness: 1,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          _formatDate(msg.createdAt),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey.shade300,
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Message Bubble
                              Container(
                                alignment:
                                    isMe
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      isMe
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          isMe
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (!isMe)
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 8,
                                              bottom: 4,
                                            ),
                                            child: CircleAvatar(
                                              radius: 16,
                                              backgroundColor:
                                                  Colors.blue.shade100,
                                              child: Text(
                                                (msg.username.isNotEmpty
                                                    ? msg.username[0]
                                                        .toUpperCase()
                                                    : 'U'),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade600,
                                                ),
                                              ),
                                            ),
                                          ),

                                        Flexible(
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.75,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient:
                                                  isMe
                                                      ? LinearGradient(
                                                        colors: [
                                                          Colors.blue.shade600,
                                                          Colors.blue.shade500,
                                                        ],
                                                      )
                                                      : null,
                                              color: isMe ? null : Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: const Radius.circular(
                                                  20,
                                                ),
                                                topRight: const Radius.circular(
                                                  20,
                                                ),
                                                bottomLeft: Radius.circular(
                                                  isMe ? 20 : 4,
                                                ),
                                                bottomRight: Radius.circular(
                                                  isMe ? 4 : 20,
                                                ),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.05),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            child: Text(
                                              msg.pesan,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color:
                                                    isMe
                                                        ? Colors.white
                                                        : Colors.black87,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ),

                                        if (isMe)
                                          Container(
                                            margin: const EdgeInsets.only(
                                              left: 8,
                                              bottom: 4,
                                            ),
                                            child: CircleAvatar(
                                              radius: 16,
                                              backgroundColor:
                                                  Colors.blue.shade100,
                                              child: Icon(
                                                Icons.person_rounded,
                                                size: 16,
                                                color: Colors.blue.shade600,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),

                                    const SizedBox(height: 4),

                                    // Message Info
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: isMe ? 0 : 40,
                                        right: isMe ? 40 : 0,
                                      ),
                                      child: Text(
                                        isMe
                                            ? _formatTime(msg.waktuFormatted)
                                            : '${msg.username} • ${_formatTime(msg.waktuFormatted)}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
            ),

            // Input Area
            if (akun != null)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: TextField(
                            controller: _controller,
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: 'Tulis pesan...',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            style: const TextStyle(fontSize: 15, height: 1.3),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Send Button
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient:
                                _isTyping
                                    ? LinearGradient(
                                      colors: [
                                        Colors.blue.shade600,
                                        Colors.blue.shade500,
                                      ],
                                    )
                                    : null,
                            color: _isTyping ? null : Colors.grey.shade300,
                            shape: BoxShape.circle,
                            boxShadow:
                                _isTyping
                                    ? [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                    : null,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.send_rounded,
                              color:
                                  _isTyping
                                      ? Colors.white
                                      : Colors.grey.shade500,
                              size: 20,
                            ),
                            onPressed:
                                _isTyping
                                    ? () async {
                                      final text = _controller.text.trim();
                                      if (text.isNotEmpty) {
                                        await vm.sendMessage(
                                          akun.id ?? 0,
                                          text,
                                          akun.username ?? '',
                                        );
                                        _controller.clear();
                                        _scrollToBottom();
                                      }
                                    }
                                    : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Memuat akun...',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
