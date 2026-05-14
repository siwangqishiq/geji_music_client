class UploadResp {
  String? url;
  String? mime;
  int filesize;

   UploadResp({
    this.url,
    this.mime,
    this.filesize = 0,
  });

  factory UploadResp.fromJson(Map<String, dynamic> json){
    return UploadResp(
      url:json["url"],
      mime:json["mime"],
      filesize:json["filesize"],
    );
  }
}//end class