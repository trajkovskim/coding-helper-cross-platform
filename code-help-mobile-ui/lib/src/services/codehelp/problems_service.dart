import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:built_collection/built_collection.dart';

import 'api.dart';

class ProblemsService {
  const ProblemsService();

  Future<List<Category>> getCategories() {
    return CATEGORIES_API.getCategories().then(
      (response) => response.data!.categories.toList(),
    );
  }

  Future<List<ProblemEntryBase>> getProblemEntries({
    String? name,
    String? category,
    Difficulty? difficulty,
    List<String>? sortBy,
  }) {
    return PROBLEMS_API
        .getProblemEntries(
          categories: category == null ? null : BuiltList([category]),
          name: name,
          difficulty: difficulty,
          sortBy: sortBy == null ? null : BuiltList(sortBy),
        )
        .then((response) => response.data!.problems.toList());
  }

  Future<List<ProblemEntryBase>> getTop10ProblemEntries() {
    return PROBLEMS_API
        .getProblemEntries(size: 10, sortBy: BuiltList.of(["likes=asc"]))
        .then((response) => response.data!.problems.toList());
  }

  Future<ProblemEntry> getProblemEntry(int id, String language) {
    return PROBLEMS_API
        .getProblemEntry(id: id, language: language)
        .then((response) => response.data!);
  }

  Future<bool> isLiked(String id) {
    return PROBLEMS_API
        .isProblemEntryLiked(id: int.parse(id))
        .then((response) => response.data!);
  }

  Future<void> toggleLike(String id) {
    return PROBLEMS_API.toggleLikeProblemEntry(id: int.parse(id));
  }
}
