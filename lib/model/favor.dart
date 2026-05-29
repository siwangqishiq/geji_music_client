import 'package:geji_music_client/model/music.dart';

///
	// Status     int       `gorm:"column:status;default:0" json:"status"`
	// Sort       int       `gorm:"column:sort;default:0" json:"sort"`
	// CreateTime time.Time `gorm:"column:create_time;autoCreateTime" json:"create_time"`
	// UpdateTime time.Time `gorm:"column:update_time;autoUpdateTime" json:"update_time"`
///
///
class Favor {
  int? fid;
  int? aid;
  int? uid;
  String? mid;
  String? remark;
  int? sort;
  int? updateTime;

  Music? music;

  Favor({
    this.fid,
    this.aid,
    this.uid,
    this.mid,
    this.remark,
    this.sort,
    this.updateTime,
    this.music
  });

  factory Favor.fromJson(Map<String, dynamic> json) {
    return Favor(
      fid: json["fid"],
      aid: json["aid"],
      uid: json["uid"],
      mid: json["mid"],
      remark: json["remark"],
      sort: json["sort"],
      updateTime: json["updateTime"],
      music: Music.fromJson(json["music"])
    );
  }
}
