import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:keylol_api/models/thread.dart';

class Carousel extends StatelessWidget {
  final List<Thread> threads;

  const Carousel({super.key, required this.threads});

  @override
  Widget build(BuildContext context) {
    // 按 16:9 计算轮播图高度
    final screenWidth = MediaQuery.of(context).size.width;
    final carouselHeight = ((screenWidth - 32) / 16 * 9).abs();

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surfaceVariant,
      clipBehavior: Clip.antiAlias,
      child: CarouselSlider(
        options: CarouselOptions(
          height: carouselHeight,
          enableInfiniteScroll: true,
          viewportFraction: 1.0,
          autoPlay: true,
        ),
        items: threads.map((thread) => CarouselItem(thread: thread)).toList(),
      ),
    );
  }
}

class CarouselItem extends StatelessWidget {
  final Thread thread;

  const CarouselItem({super.key, required this.thread});

  @override
  Widget build(BuildContext context) {
    // 图片
    final img = Material(
      child: FadeInImage(
        image: CachedNetworkImageProvider(thread.cover),
        placeholder: const AssetImage("images/carousel_placeholder.jpg"),
        fit: BoxFit.cover,
      ),
    );

    // 页脚
    final footer = Container(
      color: Colors.transparent,
      child: GridTileBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        title: Text(
          thread.subject,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/thread',
          arguments: {'tid': thread.tid},
        );
      },
      child: GridTile(
        footer: footer,
        child: img,
      ),
    );
  }
}
