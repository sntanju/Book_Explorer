import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/provider_book.dart';
import '../../data/models/book_model.dart';
import '../../../../core/widgets/network_image_loader.dart';

class ScreenBookDetails extends StatefulWidget {
  final String workKey; // e.g. "/works/OL123W"
  final String title;
  final List<String> authors;
  const ScreenBookDetails({super.key, required this.workKey, required this.title, required this.authors});

  @override
  State<ScreenBookDetails> createState() => _ScreenBookDetailsState();
}

class _ScreenBookDetailsState extends State<ScreenBookDetails> {
  BookModel? details;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final prov = context.read<ProviderBook>();
    final res = await prov.fetchWorkDetails(widget.workKey);
    setState(() {
      details = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title;
    final authors = widget.authors.join(', ');

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (details?.coverUrl != null && details!.coverUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: NetworkImageLoader(imageUrl: details!.coverUrl, width: 160, height: 220, fit: BoxFit.cover),
              ),
            SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(authors, style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Text(details?.description ?? 'No description available.', style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
