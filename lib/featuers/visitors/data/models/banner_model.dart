import 'package:flutter/material.dart';

class BannerModel {
  final String id;
  final String title;
  final String icon;
  final String buttonText;
  final List<Color> colors;
  final Color iconColor;
  final Color buttonColor;
  final String? imageUrl;
  final String? actionUrl;

  BannerModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.buttonText,
    required this.colors,
    required this.iconColor,
    required this.buttonColor,
    this.imageUrl,
    this.actionUrl,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    List<Color> colors = (json['colors'] as List<dynamic>?)
        ?.map((color) => Color(color))
        .toList() ?? [Colors.grey];
    
    // Ensure we have at least 2 colors for gradient
    if (colors.length < 2) {
      colors = [colors.isNotEmpty ? colors[0] : Colors.grey, Colors.grey[300]!];
    }
    
    return BannerModel(
      id: json['id'] ?? '',
      title: json['bannerName'] ?? json['title'] ?? '', // Use bannerName from Firebase
      icon: json['icon'] ?? '%', // Default icon if not provided
      buttonText: json['buttonText'] ?? 'اطلب الآن', // Default button text
      colors: colors,
      iconColor: Color(json['iconColor'] ?? 0xFF00FF88), // Default green
      buttonColor: Color(json['buttonColor'] ?? 0xFFFF6B35), // Default orange
      imageUrl: json['image'] ?? json['imageUrl'], // Use 'image' from Firebase
      actionUrl: json['url'] ?? json['actionUrl'], // Use 'url' from Firebase
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'buttonText': buttonText,
      'colors': colors.map((color) => color.value).toList(),
      'iconColor': iconColor.value,
      'buttonColor': buttonColor.value,
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
    };
  }
}