import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/provider_book.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final _authorController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void dispose() {
    _authorController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProviderBook>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          TextField(
            controller: _authorController,
            decoration: const InputDecoration(
              labelText: 'Author',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _yearController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Year',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  final year = int.tryParse(_yearController.text);
                  provider.applyFilters(
                    author: _authorController.text.isNotEmpty ? _authorController.text : null,
                    year: year,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {
                  provider.clearFilters();
                  Navigator.pop(context);
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
