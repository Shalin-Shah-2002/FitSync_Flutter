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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['videoId'] = videoId;
    data['url'] = url;
    data['thumbnail'] = thumbnail;
    data['channelTitle'] = channelTitle;
    return data;
  }
}