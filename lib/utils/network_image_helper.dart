List<String> extractImageUrls(String? rawValue) {
  if (rawValue == null || rawValue.trim().isEmpty) {
    return const <String>[];
  }

  return rawValue
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .where((e) {
    final uri = Uri.tryParse(e);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }).toList();
}

String? firstImageUrl(String? rawValue) {
  final urls = extractImageUrls(rawValue);
  return urls.isEmpty ? null : urls.first;
}
