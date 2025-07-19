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

class Check {
  final String name;

  Check(this.name);
}

// Example classes for demonstration
@Component()
class UserService {
  final DatabaseService _db;
  
  UserService(this._db);
  
  Future<List<User>> getUsers() async {
    return await _db.findAll<User>();
  }
}

@Repository()
class DatabaseService {
  Future<List<T>> findAll<T>() async {
    // Simulate database operation
    await Future.delayed(Duration(milliseconds: 100));
    return <T>[];
  }
}

@Controller()
class UserController {
  final UserService _userService;
  
  UserController(this._userService);
  
  @GetMapping('/users')
  Future<List<User>> getAllUsers() async {
    return await _userService.getUsers();
  }
}

class User {
  final String name;
  final int age;
  
  User(this.name, this.age);
  
  @override
  String toString() => 'User(name: $name, age: $age)';
}

// Annotations for demonstration
class Component {
  const Component();
}

class Repository {
  const Repository();
}

class Controller {
  const Controller();
}

class GetMapping {
  final String path;
  const GetMapping(this.path);
}