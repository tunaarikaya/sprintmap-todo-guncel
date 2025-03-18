import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Profil'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(CupertinoIcons.person_alt, size: 50),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Kullanıcı Adı',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            CupertinoListSection.insetGrouped(
              header: const Text('Kişisel Bilgiler'),
              children: [
                const CupertinoListTile(
                  title: Text('E-posta'),
                  trailing: Text('kullanici@email.com'),
                ),
                const CupertinoListTile(
                  title: Text('Telefon'),
                  trailing: Text('+90 555 555 55 55'),
                ),
                CupertinoListTile(
                  title: const Text('Profili Düzenle'),
                  trailing: const Icon(CupertinoIcons.chevron_forward),
                  onTap: () {},
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('Hesap İşlemleri'),
              children: [
                CupertinoListTile(
                  title: const Text('Şifre Değiştir'),
                  trailing: const Icon(CupertinoIcons.chevron_forward),
                  onTap: () {},
                ),
                const CupertinoListTile(
                  title: Text('Çıkış Yap'),
                  trailing: Icon(CupertinoIcons.arrow_right_square),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
