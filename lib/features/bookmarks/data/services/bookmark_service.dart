import '../../domain/models/bookmark_model.dart';
import '../repositories/bookmark_repository.dart';

class BookmarkService {
  BookmarkService._();

  static final BookmarkService instance =
      BookmarkService._();

  final BookmarkRepository _repository =
      BookmarkRepository.instance;

  Future<BookmarkModel?> getBookmark({
    required String userId,
    required String eventId,
  }) {
    return _repository.getBookmark(
      userId: userId,
      eventId: eventId,
    );
  }

  Future<bool> isBookmarked({
    required String userId,
    required String eventId,
  }) {
    return _repository.isBookmarked(
      userId: userId,
      eventId: eventId,
    );
  }

  Future<void> addBookmark(
    BookmarkModel bookmark,
  ) {
    return _repository.addBookmark(
      bookmark,
    );
  }

  Future<void> removeBookmark({
    required String userId,
    required String eventId,
  }) {
    return _repository.removeBookmark(
      userId: userId,
      eventId: eventId,
    );
  }

  Stream<List<BookmarkModel>>
      getUserBookmarks(
    String userId,
  ) {
    return _repository.getUserBookmarks(
      userId,
    );
  }
}