import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: CupertinoTheme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(CupertinoIcons.person_alt, size: 30),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Kullanıcı Adı',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'kullanici@email.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.person),
            title: const Text('Profil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.settings),
            title: const Text('Ayarlar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(CupertinoIcons.arrow_right_square),
            title: const Text('Çıkış Yap'),
            onTap: () {
              // Çıkış işlemleri burada yapılacak
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
