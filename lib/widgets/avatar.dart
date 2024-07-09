import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';

class Avatar extends StatelessWidget {
  final String uid;
  final String? username;
  final double? width;
  final double? height;
  final EdgeInsets? padding;

  const Avatar({
    super.key,
    required this.uid,
    this.username,
    this.width = 48.0,
    this.height = 48.0,
    this.padding,
  });

  String generateAvatarUrl() =>
      'https://keylol.com/uc_server/avatar.php?uid=$uid';

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
          child: uid == '0'
              ? Image.asset('images/systempm.png')
              : CachedNetworkImage(
                  imageUrl: generateAvatarUrl(),
                  placeholder: (context, url) => _buildPlaceHolder(context),
                  errorWidget: (context, error, stackTrace) =>
                      _buildPlaceHolder(context),
                ),
        ),
      ),
    );
  }

  Widget _buildPlaceHolder(BuildContext context) {
    if (username == null) {
      return Image.asset('images/unknown_avatar.jpg');
    } else {
      final letter = PinyinHelper.getFirstWordPinyin(username!)
          .toUpperCase()
          .codeUnitAt(0);
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          IconData(letter),
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
  }
}
