class Resource {
  final String title;
  final String imageUrl;
  final String content;
  final String fileName;

  Resource({
    required this.title,
    required this.imageUrl,
    required this.content,
    required this.fileName,
  });

  static Resource fromMarkdown(String markdown, String fileName) {
    final lines = markdown.split('\n');
    String title = fileName.replaceAll('.md', '').replaceAll('_', ' ');
    String imageUrl = '';
    String content = '';
    

    final imageRegex = RegExp(r'!\[.*?\]\((.*?)\)');
    final imageMatch = imageRegex.firstMatch(markdown);
    if (imageMatch != null) {
      imageUrl = imageMatch.group(1) ?? '';
    }
 
    final titleRegex = RegExp(r'^# (.+)$', multiLine: true);
    final titleMatch = titleRegex.firstMatch(markdown);
    if (titleMatch != null) {
      title = titleMatch.group(1) ?? title;
    }
    
    content = markdown;
    
    return Resource(
      title: title,
      imageUrl: imageUrl,
      content: content,
      fileName: fileName,
    );
  }
}