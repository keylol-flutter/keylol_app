import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:keylol_flutter/config/router.dart';
import 'package:keylol_flutter/widgets/async_search_anchor.dart';

class IndexSearchButton extends StatefulWidget {
  const IndexSearchButton({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _IndexSearchButtonState();
}

class _IndexSearchButtonState extends State<IndexSearchButton> {
  final _dio = Dio(BaseOptions(baseUrl: 'https://duckduckgo.com'));

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncSearchAnchor(
      searchAnchorChildBuilder: (context, controller) {
        return IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            controller.openView();
          },
        );
      },
      suggestionsBuilder: (context, controller) async {
        final results = await _search(controller.text);

        return results.map((r) {
          return ListTile(
            title: Text(
              r['title'],
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              r['subTitle'],
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              final String url = r['url'];
              urlRoute(context, url);

              controller.closeView(null);
            },
          );
        }).toList();
      },
    );
  }

  Future<List<Map<String, dynamic>>> _search(String text) async {
    final resp = await _dio.get(
      '/html',
      queryParameters: {
        'q': '$text site:keylol.com',
      },
    );
    final document = parse(resp.data);

    final resultElements = document.getElementsByClassName('result');
    final results = resultElements.map((r) {
      final title = r.getElementsByClassName('result__a')[0].text;
      final subTitle = r.getElementsByClassName('result__snippet')[0].text;
      final url = r.getElementsByClassName('result__url')[0].text.trim();
      return {
        'title': title,
        'subTitle': subTitle,
        'url': Uri.decodeFull(url),
      };
    }).toList();
    return results;
  }
}
