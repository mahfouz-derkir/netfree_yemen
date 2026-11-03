import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:android_intent_plus/android_intent.dart';
import '../core/constants/app_data.dart';

class APNSettingsScreen extends StatelessWidget {
  const APNSettingsScreen({Key? key}) : super(key: key);

  void _openSystemAPNSettings(BuildContext context) async {
    try {
      const intent = AndroidIntent(
        action: 'android.settings.APN_SETTINGS',
      );
      await intent.launch();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح الإعدادات تلقائياً. يرجى التوجه إلى: إعدادات الهاتف -> شبكات الجوال -> أسماء نقاط الوصول (APN)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إعدادات APN يمن موبايل'),
          backgroundColor: Colors.red.shade900,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade800,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => _openSystemAPNSettings(context),
              icon: const Icon(Icons.settings, color: Colors.white),
              label: const Text('فتح إعدادات نقطة الوصول بالهاتف', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 16),
            const Text(
              "الإعدادات الرسمية المعتمدة:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...AppData.yemenMobileAPNs.map((apn) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(apn.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blue)),
                    const Divider(),
                    _buildDataRow("اسم نقطة الوصول (APN):", apn.apn, context),
                    _buildDataRow("اسم المستخدم (Username):", apn.user, context),
                    _buildDataRow("كلمة السر (Password):", apn.password, context),
                    _buildDataRow("نوع APN:", apn.type, context),
                    const SizedBox(height: 6),
                    Text("تاريخ التحقق: ${apn.verifiedDate}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    Text("ملاحظة: ${apn.note}", style: const TextStyle(fontSize: 12, color: Colors.black87)),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Row(
            children: [
              SelectableText(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              IconButton(
                icon: const Icon(Icons.copy, size: 16),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم نسخ $value إلى الحافظة'), duration: const Duration(seconds: 1)),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
