import 'package:flutter/material.dart';

class ContractEvents {
  final String id;
  final String name;
  final IconData icon;
  final Color iconColor;
  final int time;

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
      time: json['time'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'time': time,
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
      'time': time,
    };
  }
}

class HistoryData {
  final String id;
  final String name;
  final IconData icon;
  final Color iconColor;
  final int time;
  final double amount;

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
      time: json['time'] as int,
      amount: json['amount'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'amount': amount,
      'time': time,
    };
  }
}

class UserData {
  final String name;
  final String userId;
  final String joiningDate;
  final String address;
  final bool isLoading;

  // Lien de base utilisé pour construire le lien complet
  static const String baseLink = "https://example.com/user/";

  UserData({
    required this.name,
    required this.userId,
    required this.joiningDate,
    required this.address,
    this.isLoading = false,
  });

  // Création d'une instance à partir d'un JSON
  factory UserData.fromJson(Map<String, dynamic> data) {
    final userData = data["userData"];
    final String userId = userData["countId"].toString();
    return UserData(
      name: userData["name"],
      userId: userId,
      joiningDate: userData["joiningDate"],
      address: userData["address"],
      isLoading: false,
    );
  }

  // Conversion de l'instance en JSON
  Map<String, dynamic> toJson() {
    return {
      "userData": {
        "name": name,
        "countId": userId,
        "joiningDate": joiningDate,
      }
    };
  }
}

class AppColors {
  final Color primaryColor;
  final Color themeColor;
  final Color greenColor;
  final Color secondaryColor;
  final Color grayColor;
  final Color textColor;
  final Color redColor;

  AppColors({
    required this.primaryColor,
    required this.themeColor,
    required this.greenColor,
    required this.secondaryColor,
    required this.grayColor,
    required this.textColor,
    required this.redColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'primaryColor': primaryColor.value,
      'themeColor': themeColor.value,
      'greenColor': greenColor.value,
      'secondaryColor': secondaryColor.value,
      'grayColor': grayColor.value,
      'textColor': textColor.value,
      'redColor': redColor.value,
    };
  }

  factory AppColors.fromJson(Map<String, dynamic> json) {
    return AppColors(
      primaryColor: Color(json['primaryColor'] ?? Colors.black.value),
      themeColor: Color(json['themeColor'] ?? Colors.black.value),
      greenColor: Color(json['greenColor'] ?? Colors.black.value),
      secondaryColor: Color(json['secondaryColor'] ?? Colors.black.value),
      grayColor: Color(json['grayColor'] ?? Colors.black.value),
      textColor: Color(json['textColor'] ?? Colors.black.value),
      redColor: Color(json['redColor'] ?? Colors.black.value),
    );
  }

  @override
  String toString() {
    return 'AppColors(primaryColor: $primaryColor, themeColor: $themeColor, greenColor: $greenColor, secondaryColor: $secondaryColor, grayColor: $grayColor, textColor: $textColor, redColor: $redColor)';
  }
}

class Option {
  final String title;
  final Widget icon;
  final Widget trailing;
  final Widget? subtitle;
  final Color color;
  final TextStyle? titleStyle;
  final Color? tileColor;

  Option({
    required this.title,
    required this.icon,
    required this.trailing,
    required this.color,
    this.titleStyle,
    this.tileColor,
    this.subtitle,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'icon': icon.runtimeType.toString(),
      'trailing': trailing.runtimeType.toString(),
      'color': color.value,
    };
  }

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      title: json['title'],
      icon: json['icon'] == 'Icon' ? Icon(Icons.home) : SizedBox(),
      trailing: json['trailing'] == ' SizedBox' ? SizedBox() : SizedBox(),
      color: Color(json['color']),
    );
  }

  @override
  String toString() {
    return 'Option(title: $title, icon: $icon, trailing: $trailing, color: $color)';
  }
}

class Contact {
  final String name;
  final int userId;
  final String contactCode;
  final String imageUrl;

  Contact({
    required this.name,
    required this.userId,
    required this.contactCode,
    this.imageUrl = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'userId': userId,
      'contactCode': contactCode,
      'imageUrl': imageUrl,
    };
  }
}
