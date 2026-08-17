import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/bookmark_model.dart';

class BookmarkRepository {
  BookmarkRepository._();

  static final BookmarkRepository instance =
      BookmarkRepository._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      get _bookmarksCollection {
    return _firestore.collection('bookmarks');
  }

  String _bookmarkId({
    required String userId,
    required String eventId,
  }) {
    return '${userId}_$eventId';
  }

  Future<BookmarkModel?> getBookmark({
    required String userId,
    required String eventId,
  }) async {
    final bookmarkId = _bookmarkId(
      userId: userId,
      eventId: eventId,
    );

    final document =
        await _bookmarksCollection
            .doc(bookmarkId)
            .get();

    if (!document.exists) {
      return null;
    }

    return BookmarkModel.fromFirestore(
      document,
    );
  }

  Future<bool> isBookmarked({
    required String userId,
    required String eventId,
  }) async {
    final bookmark = await getBookmark(
      userId: userId,
      eventId: eventId,
    );

    return bookmark != null;
  }

  Future<void> addBookmark(
    BookmarkModel bookmark,
  ) async {
    final bookmarkId = _bookmarkId(
      userId: bookmark.userId,
      eventId: bookmark.eventId,
    );

    await _bookmarksCollection
        .doc(bookmarkId)
        .set(
          bookmark.toFirestore(),
        );
  }

  Future<void> removeBookmark({
    required String userId,
    required String eventId,
  }) async {
    final bookmarkId = _bookmarkId(
      userId: userId,
      eventId: eventId,
    );

    await _bookmarksCollection
        .doc(bookmarkId)
        .delete();
  }

  Stream<List<BookmarkModel>>
      getUserBookmarks(
    String userId,
  ) {
    return _bookmarksCollection
        .where(
          'userId',
          isEqualTo: userId,
        )
        .snapshots()
        .map(
          (snapshot) {
            return snapshot.docs
                .map(
                  BookmarkModel.fromFirestore,
                )
                .toList();
          },
        );
  }
}