class SongQuery {
  String? mid;
  String? author;
  String? name;

   SongQuery({
    this.mid,
    this.name,
    this.author,
  });

  factory SongQuery.fromJson(Map<String, dynamic> json){
    return SongQuery(
      mid:json["mid"],
      name:json["name"],
      author:json["author"],
    );
  }
  
}//end class


