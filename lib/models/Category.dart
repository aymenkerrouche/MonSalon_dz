class Category {
  String? id;
  String? category;
  String photo = '';

  Category(this.id,this.category, this.photo);

  Category.fromJson(Map<String, dynamic> json){
    category = json['category'] ?? '';
  }
}