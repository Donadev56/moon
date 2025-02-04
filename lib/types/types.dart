import 'package:flutter/material.dart';

class ContractEvents {
  final String id;
  final String name;
  final IconData icon;
  final Color iconColor;
  final String time;

  ContractEvents({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.time,
  });

  factory ContractEvents.fromJson(Map<String, dynamic> json) {
    return ContractEvents(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as IconData,
      iconColor: json['iconColor'] as Color,
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}
