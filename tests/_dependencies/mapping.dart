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

// import 'package:jetleaf/jetleaf.dart';
// import 'package:jetleaf/mapper.dart';

// class UserMapping {
//   @JsonField(name: 'user_id')
//   final String id;
  
//   @JsonField(name: 'full_name')
//   final String name;
  
//   final int age;
  
//   @JsonField(name: 'email_address')
//   final String email;
  
//   @JsonIgnore()
//   final String password;
  
//   final DateTime createdAt;
  
//   final List<String> tags;
  
//   final AddressMapping? address;
  
//   @JsonCreator()
//   UserMapping({
//     required this.id,
//     required this.name,
//     required this.age,
//     required this.email,
//     required this.password,
//     required this.createdAt,
//     this.tags = const [],
//     this.address,
//   });
  
//   @override
//   String toString() => 'User(id: $id, name: $name, age: $age)';
// }

// class AddressMapping {
//   final String street;
//   final String city;
//   final String country;
//   final String zipCode;
  
//   AddressMapping({
//     required this.street,
//     required this.city,
//     required this.country,
//     required this.zipCode,
//   });
  
//   @override
//   String toString() => 'Address($street, $city, $country $zipCode)';
// }

// class UserDtoMapping {
//   final String id;
//   final String fullName;
//   final int age;
//   final String email;
//   final List<String> tags;
  
//   UserDtoMapping({
//     required this.id,
//     required this.fullName,
//     required this.age,
//     required this.email,
//     required this.tags,
//   });
  
//   @override
//   String toString() => 'UserDto(id: $id, fullName: $fullName, age: $age)';
// }

// /// Address mapper as a dependency
// @Mapper()
// abstract class AddressMapper extends LeafMapper {
//   AddressDto toDto(AddressMapping address);
  
//   AddressMapping fromDto(AddressDto dto);
// }

// /// Enhanced user mapper that uses AddressMapper as a dependency
// @Mapper(uses: [AddressMapper], style: MapperStyle.SINGLETON)
// abstract class EnhancedUserMapper extends LeafMapper {
//   @Mapping(target: 'id', source: "user.id")
//   @Mapping(target: 'fullName', source: "user.name")
//   @Mapping(target: 'age', source: "user.age")
//   @Mapping(target: 'email', source: "user.email")
//   @Mapping(target: 'tags', source: "user.tags")
//   @Mapping(target: 'address', source: "user.address")
//   EnhancedUserDto toDto(UserMapping user);
  
//   @Mappings([
//     Mapping(target: 'id', source: "dto.id"),
//     Mapping(target: 'fullName', source: "dto.name"),
//     Mapping(target: 'age', source: "dto.age"),
//     Mapping(target: 'email', source: "dto.email"),
//     Mapping(target: 'tags', source: "dto.tags"),
//     Mapping(target: 'address', source: "dto.address"),
//   ])
//   UserMapping fromDto(EnhancedUserDto dto);
// }

// /// Enhanced DTOs
// class AddressDto {
//   final String street;
//   final String city;
//   final String country;
//   final String zipCode;
  
//   AddressDto({
//     required this.street,
//     required this.city,
//     required this.country,
//     required this.zipCode,
//   });
  
//   @override
//   String toString() => 'AddressDto($street, $city, $country $zipCode)';
// }

// class EnhancedUserDto {
//   final String id;
//   final String fullName;
//   final int age;
//   final String email;
//   final List<String> tags;
//   final AddressDto? address;
  
//   EnhancedUserDto({
//     required this.id,
//     required this.fullName,
//     required this.age,
//     required this.email,
//     required this.tags,
//     this.address,
//   });
  
//   @override
//   String toString() => 'EnhancedUserDto(id: $id, fullName: $fullName, age: $age, address: $address)';
// }