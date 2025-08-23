import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyswap/providers/data_provider.dart';

final languageProvider = Provider.family<String?, String>((ref, userId) {
  return ref.watch(dataProvider(userId)).value?["language"] ?? "en";
});
