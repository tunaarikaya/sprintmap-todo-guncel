import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Ayarlar'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 10),
            CupertinoListSection.insetGrouped(
              header: const Text('Genel Ayarlar'),
              children: [
                CupertinoListTile(
                  title: const Text('Bildirimler'),
                  leading: const Icon(CupertinoIcons.bell),
                  trailing: CupertinoSwitch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
                CupertinoListTile(
                  title: const Text('Karanlık Mod'),
                  leading: const Icon(CupertinoIcons.moon),
                  trailing: CupertinoSwitch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('Hesap'),
              children: [
                CupertinoListTile(
                  title: const Text('Profil'),
                  leading: const Icon(CupertinoIcons.person),
                  trailing: const Icon(CupertinoIcons.chevron_forward),
                  onTap: () {},
                ),
                CupertinoListTile(
                  title: const Text('Güvenlik'),
                  leading: const Icon(CupertinoIcons.lock),
                  trailing: const Icon(CupertinoIcons.chevron_forward),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
