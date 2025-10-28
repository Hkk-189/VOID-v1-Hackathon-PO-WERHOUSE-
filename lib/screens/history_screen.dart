import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History')),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(tabs: [Tab(text: 'Successful'), Tab(text: 'Pending'), Tab(text: 'Cancelled')]),
            Expanded(
              child: TabBarView(children: [Center(child: Text('No successful transactions yet.')), Center(child: Text('No pending transactions.')), Center(child: Text('No cancelled transactions.'))]),
            )
          ],
        ),
      ),
    );
  }
}
