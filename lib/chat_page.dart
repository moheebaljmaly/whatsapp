import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String contactName;
  final String? contactAvatar;
  final bool isOnline;

  const ChatPage({
    super.key,
    required this.contactName,
    this.contactAvatar,
    this.isOnline = false,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<Map<String, dynamic>> messages = [
    {
      'id': '1',
      'text': 'مرحباً! كيف حالك؟',
      'isMe': false,
      'time': '10:30 ص',
      'isRead': true,
    },
    {
      'id': '2',
      'text': 'أهلاً وسهلاً، أنا بخير والحمد لله. وأنت كيف حالك؟',
      'isMe': true,
      'time': '10:32 ص',
      'isRead': true,
    },
    {
      'id': '3',
      'text': 'الحمد لله، كله تمام. هل لديك وقت للاجتماع اليوم؟',
      'isMe': false,
      'time': '10:35 ص',
      'isRead': true,
    },
    {
      'id': '4',
      'text': 'نعم، متى تريد أن نلتقي؟',
      'isMe': true,
      'time': '10:37 ص',
      'isRead': false,
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.contactAvatar != null
                  ? NetworkImage(widget.contactAvatar!)
                  : null,
              child: widget.contactAvatar == null
                  ? const Icon(Icons.person, size: 24)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contactName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.isOnline ? 'متصل الآن' : 'آخر ظهور منذ 5 دقائق',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              _showCallDialog('مكالمة فيديو');
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              _showCallDialog('مكالمة صوتية');
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'info':
                  _showContactInfo();
                  break;
                case 'media':
                  _showMediaGallery();
                  break;
                case 'clear':
                  _clearChat();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'info',
                child: Row(
                  children: [
                    Icon(Icons.info, color: Color(0xFF075E54)),
                    SizedBox(width: 12),
                    Text('معلومات جهة الاتصال'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'media',
                child: Row(
                  children: [
                    Icon(Icons.photo, color: Color(0xFF075E54)),
                    SizedBox(width: 12),
                    Text('الوسائط والملفات'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 12),
                    Text('مسح المحادثة'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/chat_background.png'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
          color: Color(0xFFF5F5F5),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(messages[index]);
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['isMe'] as bool;
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF25D366) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message['text'],
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message['time'],
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message['isRead'] ? Icons.done_all : Icons.done,
                    size: 16,
                    color: message['isRead'] ? Colors.blue : Colors.white70,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    onPressed: () {
                      // إظهار لوحة الرموز التعبيرية
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'اكتب رسالة...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {
                      _showAttachmentOptions();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      _openCamera();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            backgroundColor: const Color(0xFF25D366),
            onPressed: _sendMessage,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'text': _messageController.text.trim(),
          'isMe': true,
          'time': _formatTime(DateTime.now()),
          'isRead': false,
        });
      });
      
      _messageController.clear();
      
      // التمرير إلى أسفل
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

      // محاكاة رد تلقائي
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            messages.add({
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'text': 'شكراً لك على رسالتك!',
              'isMe': false,
              'time': _formatTime(DateTime.now()),
              'isRead': true,
            });
          });
          
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showCallDialog(String callType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(callType),
        content: Text('هل تريد بدء $callType مع ${widget.contactName}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('جاري بدء $callType...'),
                  backgroundColor: const Color(0xFF25D366),
                ),
              );
            },
            child: const Text('اتصال'),
          ),
        ],
      ),
    );
  }

  void _showContactInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: widget.contactAvatar != null
                  ? NetworkImage(widget.contactAvatar!)
                  : null,
              child: widget.contactAvatar == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              widget.contactName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.isOnline ? 'متصل الآن' : 'آخر ظهور منذ 5 دقائق',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.call, 'اتصال', () {}),
                _buildActionButton(Icons.videocam, 'فيديو', () {}),
                _buildActionButton(Icons.info, 'معلومات', () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFF25D366),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _showMediaGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('معرض الوسائط قريباً!'),
        backgroundColor: Color(0xFF25D366),
      ),
    );
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح المحادثة'),
        content: const Text('هل أنت متأكد من أنك تريد مسح جميع الرسائل؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                messages.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم مسح المحادثة'),
                  backgroundColor: Color(0xFF25D366),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'إرفاق ملف',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(Icons.photo, 'صورة', () {}),
                _buildAttachmentOption(Icons.videocam, 'فيديو', () {}),
                _buildAttachmentOption(Icons.insert_drive_file, 'ملف', () {}),
                _buildAttachmentOption(Icons.location_on, 'موقع', () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFF25D366),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              onPressed();
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _openCamera() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('فتح الكاميرا قريباً!'),
        backgroundColor: Color(0xFF25D366),
      ),
    );
  }
}