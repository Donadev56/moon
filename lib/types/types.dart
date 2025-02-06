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

class DownlinesData {
  final String id;
  final String name;
  final IconData icon;
  final Color iconColor;
  final String time;

  DownlinesData({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.time,
  });

  factory DownlinesData.fromJson(Map<String, dynamic> json) {
    return DownlinesData(
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

class HistoryData {
  final String id;
  final String name;
  final IconData icon;
  final Color iconColor;
  final String time;
  final String amount;

  HistoryData({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.time,
    required this.amount,
  });

  factory HistoryData.fromJson(Map<String, dynamic> json) {
    return HistoryData(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as IconData,
      iconColor: json['iconColor'] as Color,
      time: json['time'] as String,
      amount: json['from'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'from': amount,
    };
  }
}
