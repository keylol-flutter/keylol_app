import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lpinyin/lpinyin.dart';

class Avatar extends StatelessWidget {
  final String uid;
  final String? username;
  final double? width;
  final double? height;
  final EdgeInsets? padding;

  const Avatar({
    Key? key,
    required this.uid,
    this.username,
    this.width = 48.0,
    this.height = 48.0,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          if (uid == '') {
            Navigator.of(context).pushNamed('/login');
          } else {
            Navigator.of(context).pushNamed('/space', arguments: {'uid': uid});
          }
        },
        child: ClipOval(
          child: CachedNetworkImage(
            cacheManager: CacheManager(
              Config(
                'https://keylol.com/uc_server/avatar.php?uid=$uid',
                stalePeriod: const Duration(days: 7),
              ),
            ),
            imageUrl: uid == '0'
                ? 'https://keylol.com/static/image/common/systempm.png'
                : 'https://keylol.com/uc_server/avatar.php?uid=$uid',
            placeholder: (context, url) {
              if (username == null) {
                return Image.asset('images/unknown_avatar.jpg');
              } else {
                final letter = PinyinHelper.getFirstWordPinyin(username!)
                    .toUpperCase()
                    .codeUnitAt(0);
                return Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Icon(
                    IconData(letter),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                );
              }
            },
            errorWidget: (context, error, stackTrace) {
              if (username == null) {
                return Image.asset('images/unknown_avatar.jpg');
              } else {
                final letter = PinyinHelper.getFirstWordPinyin(username!)
                    .toUpperCase()
                    .codeUnitAt(0);
                return Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Icon(
                    IconData(letter),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
