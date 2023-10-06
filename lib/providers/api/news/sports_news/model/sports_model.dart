// To parse this JSON data, do
//
//     final sportsModel = sportsModelFromJson(jsonString);

import 'dart:convert';

SportsModel sportsModelFromJson(String str) =>
    SportsModel.fromJson(json.decode(str));

String sportsModelToJson(SportsModel data) => json.encode(data.toJson());

class SportsModel {
  SportsModel({
    required this.articles,
  });

  List<Article>? articles;
  String? error;

  factory SportsModel.fromJson(Map<String, dynamic> json) => SportsModel(
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "articles": List<dynamic>.from(articles!.map((x) => x.toJson())),
      };

  SportsModel.withError(String errorMessage) {
    error = errorMessage;
  }
}

// News Article Model
class Article {
  Article({
    this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  dynamic author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  DateTime? publishedAt;
  String? content;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt!.toIso8601String(),
        "content": content,
      };
}
