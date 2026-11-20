import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookDetailView extends StatefulWidget {
  final int book;

  const BookDetailView({super.key, required this.book});

  @override
  State<BookDetailView> createState() => _BookDetailViewState();
}

class _BookDetailViewState extends State<BookDetailView> {
  Map<String, dynamic>? _book;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookDetail();
  }

  Future<void> _fetchBookDetail() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://potterapi-fedeperin.vercel.app/en/books?index=${widget.book}',
        ),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          if (decoded is List && decoded.isNotEmpty) {
            _book = decoded[0];
          } else if (decoded is Map<String, dynamic>) {
            _book = decoded;
          }
          _isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_book?['title'] ?? 'Book Detail')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _book == null
          ? const Center(child: Text('Data buku tidak ditemukan'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _book!['cover'] ?? '',
                        height: 350,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.book, size: 150),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _book!['title'] ?? '-',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Book number : ${_book!['number'] ?? '-'}'),
                  Text('Original title : ${_book!['originalTitle'] ?? '-'}'),
                  Text('Release date : ${_book!['releaseDate'] ?? '-'}'),
                  Text('Total pages : ${_book!['pages'] ?? '-'}'),
                  const SizedBox(height: 12),
                  Text(
                    _book!['description'] ?? '-',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
    );
  }
}
