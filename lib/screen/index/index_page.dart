import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol.dart';
import 'package:keylol_api/models/index.dart';
import 'package:keylol_flutter/screen/index/bloc/index_bloc.dart';
import 'package:keylol_flutter/screen/index/widgets/carousel.dart';
import 'package:keylol_flutter/widgets/thread_item.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<StatefulWidget> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  var _index = 0;
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IndexBloc(context.read<Keylol>())..add(IndexFetched()),
      child: BlocConsumer<IndexBloc, IndexState>(
        listener: (context, state) {
          if (state.status == IndexStatus.failure) {}
        },
        builder: (context, state) {
          final index = state.index;
          return RefreshIndicator(
            onRefresh: () async {
              context.read<IndexBloc>().add(IndexFetched());
            },
            child: index == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                            child: _buildCarousel(context, index)),
                        SliverToBoxAdapter(child: _buildTab(context, index)),
                      ];
                    },
                    body: _buildPageView(context, index),
                  ),
          );
        },
      ),
    );
  }

  /// 轮播图
  Widget _buildCarousel(BuildContext context, Index index) {
    final threads = index.slideViewThreads;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Carousel(
        threads: threads,
      ),
    );
  }

  void _animateTo(int index) {
    setState(() {
      _index = index;
      _controller.animateToPage(
        _index,
        duration: const Duration(microseconds: 500),
        curve: Curves.linear,
      );
    });
  }

  Widget _buildTabItem(int index, String text) {
    return InkWell(
      onTap: () {
        _animateTo(index);
      },
      child: Text(
        text,
        style: _index == index
            ? Theme.of(context).textTheme.headlineSmall
            : Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget _buildTab(BuildContext context, Index index) {
    final threadMap = index.tabThreadMap;
    final hasLogin = threadMap.containsKey('最新回复');

    final newThreadsTab = _buildTabItem(0, '最新主题');
    final newRepliesTab = _buildTabItem(1, '最新回复');
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          newThreadsTab,
          const SizedBox(width: 8.0),
          if (hasLogin) newRepliesTab,
        ],
      ),
    );
  }

  Widget _buildPageView(BuildContext context, Index index) {
    final threadMap = index.tabThreadMap;
    final newThreads = threadMap['最新主题'];
    final newReplies = threadMap['最新回复'];

    return PageView.builder(
      controller: _controller,
      onPageChanged: (index) {
        setState(() {
          _index = index;
        });
      },
      itemCount: newReplies == null ? 1 : 2,
      itemBuilder: (context, index) {
        final threads = index == 0 ? newThreads : newReplies;
        return ListView.separated(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: threads!.length,
          itemBuilder: (context, index) {
            return ThreadItem(thread: threads[index]);
          },
          separatorBuilder: (context, index) {
            if (index == threads.length - 1) {
              return Container();
            }
            return const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(height: 1.0),
            );
          },
        );
      },
    );
  }
}
