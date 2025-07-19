import '../../class.dart';
import '../class_loader.dart';

class DartClassLoader extends ClassLoader {
  @override
  Class<T> loadClass<T>(String name, [bool resolve = false]) {
    // TODO: implement loadClass
    return super.loadClass(name, resolve);
  }
}