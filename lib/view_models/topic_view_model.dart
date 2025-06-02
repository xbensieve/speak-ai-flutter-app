class TopicViewModel {
  final Map<int, Map<String, String>> topics = {
    1: {
      'topic': 'Daily routines',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIH73uYv2PcYeH2lCRu3ds1lmhjCWnDX0HNw&s',
    },
    2: {
      'topic': 'Travel experiences',
      'image':
          'https://ezcloud.vn/wp-content/uploads/2024/03/niem-vui-cua-nguoi-di-du-lich-mot-minh.webp',
    },
    3: {
      'topic': 'Tech innovations',
      'image':
          'https://www.mckinsey.com/spContent/bespoke/tech-trends-2024-hero-nav/techtrends-hero-desktop.jpg',
    },
    4: {
      'topic': 'Career development',
      'image':
          'https://mrctas.org.au/wp-content/uploads/2021/12/careersteps.jpg',
    },
  };
  Map<int, Map<String, String>> getTopics() {
    return topics;
  }
}
