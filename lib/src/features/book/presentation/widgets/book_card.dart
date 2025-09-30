import 'package:flutter/material.dart';
import '../../../../core/widgets/network_image_loader.dart';
import '../../data/models/book_model.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback? onTap;
  const BookCard({super.key, required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          height: 130,
          child: Row(
            children: [
              // Cover (no padding on left/top/bottom)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
                child: NetworkImageLoader(
                  imageUrl: book.coverUrl.isEmpty ? null : book.coverUrl,
                  width: 120,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),

              // Details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),

                      // Author
                      Text(
                        book.primaryAuthor,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 8),

                      // First publish year
                      if (book.firstPublishYear != null)
                        Text(
                          'First published: ${book.firstPublishYear}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      Spacer(),

                      // Subjects as chips (limited)
                      // if (book.subjects != null && book.subjects!.isNotEmpty)
                      //   SizedBox(
                      //     height: 36,
                      //     child: ListView(
                      //       scrollDirection: Axis.horizontal,
                      //       children: book.subjects!.take(4).map((s) => Padding(
                      //         padding: EdgeInsets.only(right: 6.0),
                      //         child: Chip(
                      //           label: Text(
                      //             s,
                      //             style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      //           ),
                      //           backgroundColor: Colors.white,
                      //           side: BorderSide(color: Colors.grey.shade400),
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(8),
                      //           ),
                      //         ),
                      //       )).toList(),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

