class ImageService {
  Future<List<String>> fetchRandomImages(int count) async {
    final List<String> urls = [];
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < count; i++) {
      // Используем Lorem Picsum для получения случайных изображений
      urls.add('https://picsum.photos/300/200?random=$i&$timestamp');
    }

    // Имитация задержки сети
    await Future.delayed(const Duration(milliseconds: 500));

    return urls;
  }
}
