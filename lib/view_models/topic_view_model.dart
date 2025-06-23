class TopicViewModel {
  final Map<int, Map<String, String>> topics = {
    1: {
      'topic': 'Daily routines',
      'image':
          'https://i.pinimg.com/736x/a4/72/04/a47204fb9699b6ed7cd29d2af10b5614.jpg',
    },
    2: {
      'topic': 'Travel experiences',
      'image':
          'https://i.pinimg.com/736x/21/66/14/2166140a14929c1f7929f7428551b25f.jpg',
    },
    3: {
      'topic': 'Tech innovations',
      'image':
          'https://i.pinimg.com/736x/0e/1a/2e/0e1a2e1eb6da099fca64978e173ead8b.jpg',
    },
    4: {
      'topic': 'Career development',
      'image':
          'https://i.pinimg.com/736x/6a/49/e2/6a49e20f9d85d2384a359b4586b1781b.jpg',
    },
  };

  Map<int, Map<String, String>> getTopics() {
    return topics;
  }
}
