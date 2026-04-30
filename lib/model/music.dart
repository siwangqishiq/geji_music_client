class Music {
  String? mid;
  String? name;
  String? author;
  String? playUrl;
  String? cover;
  int? durationSecs = 0;

  Music({
    this.mid,
    this.name,
    this.author,
    this.playUrl,
    this.cover,
    this.durationSecs = 0
  });

  factory Music.fromJson(Map<String, dynamic> json){
    return Music(
      mid:json["mid"],
      name:json["name"],
      author:json["author"],
      playUrl: json["playUrl"],
      cover:json["cover"],
      durationSecs:json["durationSecs"]
    );
  }
}


