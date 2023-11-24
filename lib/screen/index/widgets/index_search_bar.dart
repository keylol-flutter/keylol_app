import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:keylol_flutter/widgets/async_search_anchor.dart';

class IndexSearchBar extends StatefulWidget {
  final Widget? leading;
  final Iterable<Widget>? trailing;

  const IndexSearchBar({
    super.key,
    this.leading,
    this.trailing,
  });

  @override
  State<StatefulWidget> createState() => _IndexSearchBarState();
}

class _IndexSearchBarState extends State<IndexSearchBar> {
  final _dio = Dio(BaseOptions(baseUrl: 'https://duckduckgo.com'));

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncSearchAnchor(
      barLeading: widget.leading,
      barTrailing: widget.trailing,
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
              // TODO url 解析
              String url = r['url'];
              if (url.startsWith('https://keylol.com/t')) {
                url = url.replaceFirst('https://keylo.com/t', '');
                final tid = url.split('-')[0];
                Navigator.of(context).pushNamed(
                  '/thread',
                  arguments: {'tid': tid},
                );
              }

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
        'url': url,
      };
    }).toList();
    return results;
  }
}
