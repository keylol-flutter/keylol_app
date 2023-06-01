import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html/dom.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/screen/index/bloc/index_bloc.dart';
import 'package:keylol_flutter/screen/index/view/index_view.dart';
import 'package:keylol_flutter/screen/index/widgets/carousel.dart';
import 'package:mocktail/mocktail.dart';

class MockIndexBloc extends MockBloc<IndexEvent, IndexState>
    implements IndexBloc {}

void main() {
  testWidgets('Index without new reply', (widgetTester) async {
    String html = File('test_resources/index_unlogin.html').readAsStringSync();
    final index = Index.fromDocument(Document.html(html));

    final mockIndexBloc = MockIndexBloc();
    when(() => mockIndexBloc.state)
        .thenReturn(IndexState(IndexStatus.success, index, 0));
    await widgetTester.pumpWidget(BlocProvider<IndexBloc>.value(
        value: mockIndexBloc, child: const MaterialApp(home: IndexView())));

    final carouselFinder = find.byType(Carousel);
    final newThreadsTabFinder = find.text('最新主题');
    final newReplyTabFinder = find.text('最新回复');
    expect(carouselFinder, findsOneWidget);
    expect(newThreadsTabFinder, findsOneWidget);
    expect(newReplyTabFinder, findsNothing);
  });

  testWidgets('Index with new reply', (widgetTester) async {
    String html = File('test_resources/index.html').readAsStringSync();
    final index = Index.fromDocument(Document.html(html));

    final mockIndexBloc = MockIndexBloc();
    when(() => mockIndexBloc.state)
        .thenReturn(IndexState(IndexStatus.success, index, 0));
    await widgetTester.pumpWidget(BlocProvider<IndexBloc>.value(
        value: mockIndexBloc, child: const MaterialApp(home: IndexView())));

    final carouselFinder = find.byType(Carousel);
    final newThreadsTabFinder = find.text('最新主题');
    final newRepliesTabFinder = find.text('最新回复');
    expect(carouselFinder, findsOneWidget);
    expect(newThreadsTabFinder, findsOneWidget);
    expect(newRepliesTabFinder, findsOneWidget);
  });
}
