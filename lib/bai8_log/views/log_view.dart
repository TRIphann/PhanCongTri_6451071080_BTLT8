import 'package:flutter/material.dart';
import '../controllers/item_controller.dart';
import '../models/log_entry.dart';

class LogView extends StatefulWidget {
  const LogView({super.key});

  @override
  State<LogView> createState() => _LogViewState();
}

class _LogViewState extends State<LogView> with SingleTickerProviderStateMixin {
  final _controller = ItemController();
  late TabController _tabController;
  List<LogEntry> _dbLogs = [];
  String _fileLog = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLogs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    final dbLogs = await _controller.getAllLogs();
    final fileLog = await _controller.getFileLog();
    setState(() {
      _dbLogs = dbLogs;
      _fileLog = fileLog;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📜 Xem Log'),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.storage), text: 'Database Log'),
            Tab(icon: Icon(Icons.description), text: 'File Log'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Database logs
                _dbLogs.isEmpty
                    ? const Center(child: Text('Chưa có log trong database'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _dbLogs.length,
                        itemBuilder: (context, index) {
                          final log = _dbLogs[index];
                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.circle, size: 10, color: _getLogColor(log.action)),
                              title: Text(log.action, style: const TextStyle(fontSize: 14)),
                              subtitle: Text(log.time, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                            ),
                          );
                        },
                      ),

                // File log
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      _fileLog,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Color _getLogColor(String action) {
    if (action.startsWith('THÊM')) return Colors.green;
    if (action.startsWith('SỬA')) return Colors.blue;
    if (action.startsWith('XÓA')) return Colors.red;
    return Colors.grey;
  }
}
