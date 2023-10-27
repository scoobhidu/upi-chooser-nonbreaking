import 'package:flutter/material.dart';
import 'dart:async';
import 'package:upi_chooser/upi_apps.dart';
import 'package:upi_chooser/upi_chooser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UPI Apps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'UPI Apps'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UpiApps>? upiAppsData;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchUpiAppsData();
    });
    super.initState();
  }

  Future<void> fetchUpiAppsData() async {
    final fetchUpiApps = UpiChooser();
    upiAppsData = await fetchUpiApps.getUpiAppList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: upiAppsData == null
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              shrinkWrap: true,
              itemCount: upiAppsData!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.2,
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 60,
                  width: 60,
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Image.memory(
                                upiAppsData![index].imageData!,
                                width: 58,
                              ),
                            ),
                            Text('${upiAppsData![index].displayName}'),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
