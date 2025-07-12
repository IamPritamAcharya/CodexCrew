import 'dart:convert';
import 'package:http/http.dart' as http;
import 'resource_model.dart';

class GitHubService {
  static const String _baseUrl = 'https://api.github.com/repos/IamPritamAcharya/codexcrewResources/contents';
  
  static Future<List<Resource>> fetchResources() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> files = json.decode(response.body);
        final List<Resource> resources = [];
        
        for (final file in files) {
          if (file['name'].toString().endsWith('.md')) {
            final fileContent = await _fetchFileContent(file['download_url']);
            if (fileContent.isNotEmpty) {
              resources.add(Resource.fromMarkdown(fileContent, file['name']));
            }
          }
        }
        
        return resources;
      } else {
        throw Exception('Failed to load resources');
      }
    } catch (e) {
      throw Exception('Error fetching resources: $e');
    }
  }
  
  static Future<String> _fetchFileContent(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      }
      return '';
    } catch (e) {
      return '';
    }
  }
}