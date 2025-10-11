class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final bool isActive;
  final int serviceCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.isActive = true,
    this.serviceCount = 0,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
      color: map['color'] ?? '#2196F3',
      isActive: map['isActive'] ?? true,
      serviceCount: map['serviceCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'isActive': isActive,
      'serviceCount': serviceCount,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? color,
    bool? isActive,
    int? serviceCount,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      serviceCount: serviceCount ?? this.serviceCount,
    );
  }
}
