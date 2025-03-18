import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sprintmap/widget/info_builder.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

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
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                CupertinoListTile(
                  title: const Text('Güvenlik'),
                  leading: const Icon(CupertinoIcons.lock),
                  trailing: const Icon(CupertinoIcons.chevron_forward),
                  onTap: () {},
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('Uygulama'),
              children: [
                CupertinoListTile(
                  title: const Text('Dil'),
                  leading: const Icon(CupertinoIcons.globe),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Türkçe'),
                      SizedBox(width: 5),
                      Icon(CupertinoIcons.chevron_forward),
                    ],
                  ),
                ),
                CupertinoListTile(
                  title: const Text('Sürüm'),
                  leading: const Icon(CupertinoIcons.info),
                  trailing: const Text('1.0.0'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CupertinoButton(
                color: CupertinoColors.destructiveRed,
                child: const Text('Çıkış Yap'),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
