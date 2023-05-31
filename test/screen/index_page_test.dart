import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html/dom.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/screen/index/bloc/index_bloc.dart';
import 'package:keylol_flutter/screen/index/index_page.dart';
import 'package:keylol_flutter/screen/index/widgets/carousel.dart';
import 'package:mockito/mockito.dart';

class MockIndexBloc extends MockBloc<IndexEvent, IndexState>
    implements IndexBloc {}

void main() {
  testWidgets('Index without new reply', (widgetTester) async {
    String html = File('test_resources/index_unlogin.html').readAsStringSync();
    final index = Index.fromDocument(Document.html(html));

    final mockIndexBloc = MockIndexBloc();
    when(mockIndexBloc.state)
        .thenReturn(IndexState(IndexStatus.success, index, 0));

    await widgetTester.pumpWidget(
        BlocProvider.value(value: mockIndexBloc, child: const IndexPage()));

    final carouselFinder = find.byElementType(Carousel);
    expect(carouselFinder, findsOneWidget);
  });
}
