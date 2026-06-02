import 'package:flutter/material.dart';
import 'package:geji_music_client/model/favor.dart';
import 'package:geji_music_client/model/music.dart';
import 'package:geji_music_client/util/time_util.dart';

class FavorItem extends StatelessWidget {
  final Favor favor;
  final Function(Favor f) onClick;
  final Function(Favor favor) onLongClick;

  const FavorItem({
    super.key,
    required this.favor,
    required this.onClick,
    required this.onLongClick
  });

  @override
  Widget build(BuildContext context) {
    final music = favor.music;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => onClick(favor),
        onLongPress: () => onLongClick(favor),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildCover(music),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      music?.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      music?.author ?? "未知歌手",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Text(
                    formatDuration(
                      music?.durationSecs ?? 0,
                    ),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Icon(
                    Icons.favorite,
                    size: 20,
                    color: Colors.red.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCover(Music? music) {
    if ((music?.cover ?? "").isEmpty) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.blue.shade100,
        ),
        child: const Icon(Icons.music_note),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        music!.cover!,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
      ),
    );
  }

  String formatDuration(int seconds) {
    return TimeUtil.formatDuration(seconds);
  }
}//end class
