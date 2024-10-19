import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailViewScreen extends StatefulWidget {
  String newsUrl;
  DetailViewScreen({super.key, required this.newsUrl});

  @override
  State<DetailViewScreen> createState() => _DetailViewScreenState();
}

class _DetailViewScreenState extends State<DetailViewScreen> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();

    // Modify the URL if it contains "http:"
    if (widget.newsUrl.contains("http:")) {
      widget.newsUrl = widget.newsUrl.replaceAll("http:", "https:");
    }

    // Initialize WebViewController and load the initial URL
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.newsUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("News Snack")),
      body: WebViewWidget(controller: controller),
    );
  }
}
