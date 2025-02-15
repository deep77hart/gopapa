import 'package:flutter/material.dart';
import 'dart:js' as js;

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// Application itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter WebView',
      home: HomePage(),
    );
  }
}

/// [Widget] displaying the home page with WebView and URL input.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State of a [HomePage].
class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  bool _isMenuOpen = false;

  void _loadUrl() {
    setState(() {});
  }

  void _toggleFullScreen() {
    js.context.callMethod('eval', [
      "if (!document.fullscreenElement) { document.documentElement.requestFullscreen(); } else { document.exitFullscreen(); }"
    ]);
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_urlController.text.isNotEmpty)
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onDoubleTap: _toggleFullScreen,
                          child: Image.network(
                            _urlController.text.trim(),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (_urlController.text.isEmpty)
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration:
                        const InputDecoration(hintText: 'Enter Image URL'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _loadUrl,
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          if (_isMenuOpen)
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                color: Colors.black54,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (_isMenuOpen)
                Column(
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {
                        _toggleFullScreen();
                        _toggleMenu();
                      },
                      label: const Text("Enter fullscreen"),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.extended(
                      onPressed: () {
                        _toggleFullScreen();
                        _toggleMenu();
                      },
                      label: const Text("Exit fullscreen"),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              FloatingActionButton(
                onPressed: _toggleMenu,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
