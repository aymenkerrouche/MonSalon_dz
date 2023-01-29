class Category {
  late String category;
  String photo = '';

  Category(this.category, this.photo);

  Category.fromJson(Map<String, dynamic> json){
    category = json['category'];
  }
}