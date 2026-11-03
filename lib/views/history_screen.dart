import 'package:flutter/material.dart';
import '../services/network_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final NetworkService _networkService = NetworkService();
  List<TestResult> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final results = await _networkService.getHistory();
    setState(() {
      _history = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سجل النتائج المحفوظة'),
          backgroundColor: Colors.teal.shade900,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _history.isEmpty
                ? const Center(child: Text("لا توجد اختبارات محفوظة بعد"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final item = _history[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.speed),
                          ),
                          title: Text("${item.downloadSpeedMbps} Mbps"),
                          subtitle: Text("Ping: ${item.latencyMs} ms"),
                          trailing: Text(
                            "${item.timestamp.day}/${item.timestamp.month} ${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
