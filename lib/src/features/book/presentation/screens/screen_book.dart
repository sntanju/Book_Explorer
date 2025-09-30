import 'package:book_explorer/src/features/book/presentation/screens/screen_book_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/provider_book.dart';
import '../widgets/book_card.dart';
import '../../data/models/book_model.dart';
import '../widgets/filter_bottom_sheet.dart';


class ScreenBook extends StatefulWidget {
  const ScreenBook({super.key});

  @override
  State<ScreenBook> createState() => _ScreenBookState();
}

class _ScreenBookState extends State<ScreenBook> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> categories = ['science', 'nature', 'history', 'fantasy', 'romance', 'technology'];

  @override
  void initState() {
    super.initState();
    // load initial list (default query)
    Future.microtask(() => context.read<ProviderBook>().loadInitial(defaultQuery: 'programming'));
  }

  void _onSearch() {
    final q = _searchController.text.trim();
    if (q.isNotEmpty) {
      context.read<ProviderBook>().search(q);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProviderBook>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Book Explorer'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => FilterBottomSheet(),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // search
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Search field
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _onSearch(),
                      decoration: InputDecoration(
                        hintText: 'Search by title, author, keyword',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue, width: 1.5),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  // Search button
                  ElevatedButton(
                    onPressed: _onSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[900],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text('Search', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.all(12.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: TextField(
            //           controller: _searchController,
            //           textInputAction: TextInputAction.search,
            //           onSubmitted: (_) => _onSearch(),
            //           decoration: InputDecoration(
            //             hintText: 'Search by title, author, keyword',
            //             prefixIcon: Icon(Icons.search),
            //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            //             contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 8),
            //       ElevatedButton(
            //         onPressed: _onSearch,
            //         child: Text('Search'),
            //       ),
            //     ],
            //   ),
            // ),


            // category chips
            SizedBox(height: 8,),
            Container(
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final c = categories[i];
                  final isSelected = provider.currentSubject == c;

                  return ChoiceChip(
                    label: Text(
                      c[0].toUpperCase() + c.substring(1),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.green[900],
                    checkmarkColor: Colors.white,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? Colors.transparent : Colors.grey.shade400,
                      width: 1,
                    ),
                    onSelected: (_) => context.read<ProviderBook>().loadSubject(c),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ),

            // Container(
            //   height: 48,
            //   padding: EdgeInsets.symmetric(horizontal: 12),
            //
            //   child: ListView.separated(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: categories.length,
            //
            //     separatorBuilder: (_, __) => SizedBox(width: 8),
            //     itemBuilder: (context, i) {
            //       final c = categories[i];
            //       return ChoiceChip(
            //         label: Text(c[0].toUpperCase() + c.substring(1)),
            //         selected: provider.currentSubject == c,
            //         onSelected: (_) => context.read<ProviderBook>().loadSubject(c),
            //       );
            //     },
            //   ),
            // ),

            SizedBox(height: 8),

            // result list
            Expanded(
              child: Builder(builder: (context) {
                if (provider.state == ViewState.busy) {
                  return Center(child: CircularProgressIndicator());
                } else if (provider.error.isNotEmpty) {
                  return Center(child: Text(provider.error));
                } else if (provider.books.isEmpty) {
                  return Center(child: Text('No books found'));
                }

                return ListView.builder(
                  itemCount: provider.books.length,
                  itemBuilder: (context, idx) {
                    final BookModel b = provider.books[idx];
                    return BookCard(
                      book: b,
                      onTap: () async {
                        // Navigate to details and fetch details inside details screen
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ScreenBookDetails(workKey: b.workKey, title: b.title, authors: b.authors)));
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
