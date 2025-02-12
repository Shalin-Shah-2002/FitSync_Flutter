class Youtube_Videos {
  String? title;
  String? videoId;
  String? url;
  String? thumbnail;
  String? channelTitle;

  Youtube_Videos(
      {this.title, this.videoId, this.url, this.thumbnail, this.channelTitle});

  Youtube_Videos.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    videoId = json['videoId'];
    url = json['url'];
    thumbnail = json['thumbnail'];
    channelTitle = json['channelTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['videoId'] = this.videoId;
    data['url'] = this.url;
    data['thumbnail'] = this.thumbnail;
    data['channelTitle'] = this.channelTitle;
    return data;
  }
}