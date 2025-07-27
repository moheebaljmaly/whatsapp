import 'package:flutter/material.dart';
import 'chat_page.dart';

class ContactsPage extends StatefulWidget {
  final bool selectMode;
  
  const ContactsPage({super.key, this.selectMode = false});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // قائمة جهات الاتصال الوهمية - محدثة
  final List<Map<String, dynamic>> _contacts = [
    {
      'id': '1',
      'name': 'أحمد محمد الإداري',
      'username': 'admin_wasl',
      'email': 'admin@wasl.com',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'bio': 'مدير التطبيق - متاح دائماً للمساعدة',
      'isOnline': true,
      'isVerified': true,
      'joinDate': '2024-01-01',
    },
    {
      'id': '2',
      'name': 'سارة أحمد',
      'username': 'sara_ahmed',
      'email': 'sara.ahmed@wasl.com',
      'avatar': 'https://i.pravatar.cc/150?img=2',
      'bio': 'مطورة تطبيقات - أحب التقنية والإبداع',
      'isOnline': true,
      'isVerified': true,
      'joinDate': '2024-01-15',
    },
    {
      'id': '3',
      'name': 'محمد علي',
      'username': 'mohammed_ali',
      'email': 'mohammed.ali@wasl.com',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'bio': 'مصمم جرافيك - الإبداع هو شغفي',
      'isOnline': true,
      'isVerified': false,
      'joinDate': '2024-02-01',
    },
    {
      'id': '4',
      'name': 'فاطمة حسن',
      'username': 'fatima_hassan',
      'email': 'fatima.hassan@wasl.com',
      'avatar': 'https://i.pravatar.cc/150?img=4',
      'bio': 'كاتبة محتوى - أحب الكلمات والقصص',
      'isOnline': false,
      'isVerified': true,
      'joinDate': '2024-02-10',
    },
    {
      'id': '5',
      'name': 'عمر سالم',
      'username': 'omar_salem',
      'email': 'omar.salem@wasl.com',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'bio': 'مهندس برمجيات - أبني المستقبل بالكود',
      'isOnline': true,
      'isVerified': false,
      'joinDate': '2024-02-20',
    },
    {
      'id': '6',
      'name': 'ليلى محمود',
      'username': 'layla_mahmoud',
      'email': 'layla.mahmoud@wasl.com',
      'avatar': 'https://i.pravatar.cc/150?img=6',
      'bio': 'مديرة مشاريع - أنظم الأفكار وأحقق الأهداف',
      'isOnline': true,
      'isVerified': true,
      'joinDate': '2024-03-01',
    },
    {
      'id': '7',
      'name': 'خالد ناصر',
      'username': 'khalid_nasser',
      'email': 'khalid.nasser@wasl.com',
      'avatar': 'https://i.pravatar.cc/150?img=7',
      'bio': 'مصور فوتوغرافي - أصطاد اللحظات الجميلة',
      'isOnline': false,
      'isVerified': false,
      'joinDate': '2024-03-10',
    },
    {
      'id': '8',
      'name': 'نور عبدالله',
      'username': 'nour_abdallah',
      'email': 'nour.abdallah@wasl.com',
      'avatar': 'https://i.pravatar.cc/150?img=8',
      'bio': 'طالبة طب - أحلم بمساعدة الناس',
      'isOnline': true,
      'isVerified': false,
      'joinDate': '2024-03-15',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredContacts {
    if (_searchQuery.isEmpty) {
      return _contacts;
    }
    return _contacts.where((contact) {
      return contact['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             contact['phone'].contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.selectMode ? AppBar(
        title: const Text('اختر جهة اتصال'),
        backgroundColor: const Color(0xFF075E54),
        foregroundColor: Colors.white,
      ) : null,
      body: Column(
        children: [
          // شريط البحث
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'البحث في جهات الاتصال...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF25D366)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // خيارات سريعة
          if (!widget.selectMode) ...[
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF25D366),
                      child: Icon(Icons.group_add, color: Colors.white),
                    ),
                    title: const Text('مجموعة جديدة'),
                    onTap: () {
                      _showCreateGroupDialog();
                    },
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF25D366),
                      child: Icon(Icons.person_add, color: Colors.white),
                    ),
                    title: const Text('جهة اتصال جديدة'),
                    onTap: () {
                      _showAddContactDialog();
                    },
                  ),
                  const Divider(),
                ],
              ),
            ),
          ],
          
          // قائمة جهات الاتصال
          Expanded(
            child: ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return _buildContactTile(contact);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(Map<String, dynamic> contact) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(contact['avatar']),
            onBackgroundImageError: (_, __) {},
            child: contact['avatar'] == null
                ? const Icon(Icons.person, size: 30)
                : null,
          ),
          if (contact['isOnline'])
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        contact['name'],
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        contact['status'],
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: widget.selectMode ? null : PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'info':
              _showContactInfo(contact);
              break;
            case 'call':
              _makeCall(contact['name']);
              break;
            case 'video':
              _makeVideoCall(contact['name']);
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
                Text('معلومات'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'call',
            child: Row(
              children: [
                Icon(Icons.call, color: Color(0xFF25D366)),
                SizedBox(width: 12),
                Text('اتصال'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'video',
            child: Row(
              children: [
                Icon(Icons.videocam, color: Color(0xFF25D366)),
                SizedBox(width: 12),
                Text('مكالمة فيديو'),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        if (widget.selectMode) {
          Navigator.pop(context);
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              contactName: contact['name'],
              contactAvatar: contact['avatar'],
              isOnline: contact['isOnline'],
            ),
          ),
        );
      },
    );
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مجموعة جديدة'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'اسم المجموعة',
                prefixIcon: Icon(Icons.group),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'وصف المجموعة (اختياري)',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إنشاء المجموعة بنجاح!'),
                  backgroundColor: Color(0xFF25D366),
                ),
              );
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('جهة اتصال جديدة'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'الاسم',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'رقم الهاتف',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إضافة جهة الاتصال بنجاح!'),
                  backgroundColor: Color(0xFF25D366),
                ),
              );
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showContactInfo(Map<String, dynamic> contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            // صورة جهة الاتصال
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(contact['avatar']),
              onBackgroundImageError: (_, __) {},
              child: contact['avatar'] == null
                  ? const Icon(Icons.person, size: 80)
                  : null,
            ),
            const SizedBox(height: 16),
            
            // اسم جهة الاتصال
            Text(
              contact['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // رقم الهاتف
            Text(
              contact['phone'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            
            // الحالة
            Text(
              contact['status'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // أزرار الإجراءات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  Icons.chat,
                  'محادثة',
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          contactName: contact['name'],
                          contactAvatar: contact['avatar'],
                          isOnline: contact['isOnline'],
                        ),
                      ),
                    );
                  },
                ),
                _buildActionButton(
                  Icons.call,
                  'اتصال',
                  () {
                    Navigator.pop(context);
                    _makeCall(contact['name']);
                  },
                ),
                _buildActionButton(
                  Icons.videocam,
                  'فيديو',
                  () {
                    Navigator.pop(context);
                    _makeVideoCall(contact['name']);
                  },
                ),
                _buildActionButton(
                  Icons.info,
                  'معلومات',
                  () {
                    Navigator.pop(context);
                    _showDetailedInfo(contact);
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // معلومات إضافية
            Expanded(
              child: ListView(
                children: [
                  _buildInfoTile(Icons.phone, 'رقم الهاتف', contact['phone']),
                  _buildInfoTile(Icons.info, 'الحالة', contact['status']),
                  _buildInfoTile(
                    Icons.circle,
                    'الحالة',
                    contact['isOnline'] ? 'متصل الآن' : 'غير متصل',
                    color: contact['isOnline'] ? Colors.green : Colors.grey,
                  ),
                ],
              ),
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

  Widget _buildInfoTile(IconData icon, String title, String value, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF25D366)),
      title: Text(title),
      subtitle: Text(value),
    );
  }

  void _showDetailedInfo(Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('معلومات ${contact['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الاسم: ${contact['name']}'),
            const SizedBox(height: 8),
            Text('الهاتف: ${contact['phone']}'),
            const SizedBox(height: 8),
            Text('الحالة: ${contact['status']}'),
            const SizedBox(height: 8),
            Text('متصل: ${contact['isOnline'] ? 'نعم' : 'لا'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _makeCall(String contactName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري الاتصال بـ $contactName...'),
        backgroundColor: const Color(0xFF25D366),
      ),
    );
  }

  void _makeVideoCall(String contactName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري بدء مكالمة فيديو مع $contactName...'),
        backgroundColor: const Color(0xFF25D366),
      ),
    );
  }
}