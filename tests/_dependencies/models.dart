/// ---------------------------------------------------------------------------
/// 🍃 JetLeaf Framework - https://jetleaf.hapnium.com
///
/// Copyright © 2025 Hapnium & JetLeaf Contributors. All rights reserved.
///
/// This source file is part of the JetLeaf Framework and is protected
/// under copyright law. You may not copy, modify, or distribute this file
/// except in compliance with the JetLeaf license.
///
/// For licensing terms, see the LICENSE file in the root of this project.
/// ---------------------------------------------------------------------------
/// 
/// 🔧 Powered by Hapnium — the Dart backend engine 🍃

// // Helper class for testing
// import 'package:jetleaf/jetleaf.dart';

// class Person {
//   final String name;
//   final int age;

//   Person(this.name, this.age);

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Person && name == other.name && age == other.age;

//   @override
//   int get hashCode => name.hashCode ^ age.hashCode;

//   @override
//   String toString() => 'Person($name, $age)';
// }

// class TestData {
//   final String name;
//   final int age;

//   TestData({required this.name, required this.age});

//   Map<String, dynamic> toJson() => {'name': name, 'age': age};

//   factory TestData.fromJson(Map<String, dynamic> json) => TestData(name: json['name'], age: json['age']);

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//           other is TestData &&
//               runtimeType == other.runtimeType &&
//               name == other.name &&
//               age == other.age;

//   @override
//   int get hashCode => name.hashCode ^ age.hashCode;
// }

// class User {
//   @JsonField(name: 'first_name')
//   String firstName;

//   String lastName;

//   @JsonIgnore()
//   String? password;

//   User({required this.firstName, required this.lastName, this.password});
// }

// class Address {
//   String street;
//   String city;

//   Address({required this.street, required this.city});
// }

// class Profile {
//   @JsonField(name: 'display_name')
//   String displayName;

//   int age;

//   Profile({required this.displayName, required this.age});
// }

// class Account {
//   String username;

//   @JsonIgnore()
//   String? internalNote;

//   Profile profile;

//   Address address;

//   Map<String, dynamic> preferences;

//   Account({
//     required this.username,
//     required this.profile,
//     required this.address,
//     required this.preferences,
//     this.internalNote,
//   });
// }