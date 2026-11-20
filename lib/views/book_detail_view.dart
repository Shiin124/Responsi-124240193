import 'package:flutter/material.dart';

class BookDetailView extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetailView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> children = book['children'] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(book['title'] ?? 'Book Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  book['cover'] ?? '',
                  height: 350,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.person, size: 150),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Title', book['title']),
            _buildDetailRow('Original Title', book['originalTitle']),
            _buildDetailRow('Release Date', book['releaseDate']),
            _buildDetailRow('Description', book['description']),
            _buildDetailRow('Pages', book['pages']),
            _buildDetailRow(
              'Children',
              children.isEmpty ? 'None' : children.join(', '),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
