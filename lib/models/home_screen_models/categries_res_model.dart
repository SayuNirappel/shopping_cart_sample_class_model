import 'dart:convert';

List<CategoriesResModel> categoriesResModelFromJson(String body) =>
    List<CategoriesResModel>.from(
        json.decode(body).map((e) => CategoriesResModel.fromJson(e)));

class CategoriesResModel {
  String? slug;
  String? name;
  String? url;

  CategoriesResModel({
    this.slug,
    this.name,
    this.url,
  });

  factory CategoriesResModel.fromJson(Map<String, dynamic> json) =>
      CategoriesResModel(
        slug: json["slug"],
        name: json["name"],
        url: json["url"],
      );
}

List<int> numbersList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

class MyNumbers {
  int? number;
  String? numberString;
  MyNumbers({this.number, this.numberString});

  factory MyNumbers.formList(int a) {
    return MyNumbers(number: a, numberString: a.toString());
  }
}

List<MyNumbers> data() {
  return List<MyNumbers>.generate(
    numbersList.length,
    (index) => MyNumbers.formList(numbersList[index]),
  );
}
