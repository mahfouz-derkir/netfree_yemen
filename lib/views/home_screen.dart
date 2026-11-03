import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'speed_test_screen.dart';
import 'apn_settings_screen.dart';
import 'offers_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _connectionStatus = "جاري الفحص...";
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    var result = await (Connectivity().checkConnectivity());
    setState(() {
      if (result.contains(ConnectivityResult.mobile)) {
        _connectionStatus = "متصل عبر شبكة الجوال (Yemen Mobile/Other)";
        _isConnected = true;
      } else if (result.contains(ConnectivityResult.wifi)) {
        _connectionStatus = "متصل عبر شبكة Wi-Fi";
        _isConnected = true;
      } else {
        _connectionStatus = "لا يوجد اتصال بالإنترنت";
        _isConnected = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('NetFree Yemen'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.red.shade900,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: _isConnected ? Colors.green.shade50 : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        _isConnected ? Icons.wifi : Icons.wifi_off,
                        color: _isConnected ? Colors.green.shade800 : Colors.red.shade800,
                        size: 36,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "حالة الشبكة الحالية",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _connectionStatus,
                              style: TextStyle(
                                fontSize: 14,
                                color: _isConnected ? Colors.green.shade900 : Colors.red.shade900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _checkConnectivity,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuCard(
                context,
                title: "اختبار سرعة الاتصال",
                subtitle: "قياس زمن الاستجابة والسرعة التقديرية",
                icon: Icons.speed,
                color: Colors.blue.shade700,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SpeedTestScreen())),
              ),
              _buildMenuCard(
                context,
                title: "إعدادات APN يمن موبايل",
                subtitle: "دليل تهيئة نقاط الوصول 4G / 3G",
                icon: Icons.settings_input_antenna,
                color: Colors.orange.shade800,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const APNSettingsScreen())),
              ),
              _buildMenuCard(
                context,
                title: "العروض الرسمية المتاحة",
                subtitle: "استعلام الباقات والعروض المؤكدة",
                icon: Icons.local_offer,
                color: Colors.purple.shade700,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OffersScreen())),
              ),
              _buildMenuCard(
                context,
                title: "سجل السجلات والاختبارات",
                subtitle: "عرض نتائج القياس المحفوظة محلياً",
                icon: Icons.history,
                color: Colors.teal.shade700,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "إشعار موثوقية: هذا التطبيق لا يتجاوز أنظمة الفوترة ولا يمنح إنترنت مجاني غير مصرح به. كافة الإرشادات مخصصة لتصحيح ضبط الشبكة الرسمي.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black60),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
