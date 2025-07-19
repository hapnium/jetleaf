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

RegExp emailRegExp = RegExp(r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");

// RegExp ipv4MaybeRegExp = RegExp(r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)$');

// RegExp ipv6RegExp = RegExp(r'^::|^::1|^([a-fA-F0-9]{1,4}::?){1,7}([a-fA-F0-9]{1,4})$');

// RegExp surrogatePairsRegExp = RegExp(r'[\uD800-\uDBFF][\uDC00-\uDFFF]');

// RegExp alphaRegExp = RegExp(r'^[a-zA-Z]+$');

// RegExp alphanumericRegExp = RegExp(r'^[a-zA-Z0-9]+$');

// RegExp numericRegExp = RegExp(r'^-?[0-9]+$');

// RegExp intRegExp = RegExp(r'^(?:-?(?:0|[1-9][0-9]*))$');

// RegExp floatRegExp = RegExp(r'^(?:-?(?:[0-9]+))?(?:\.[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?$');

// RegExp hexadecimalRegExp = RegExp(r'^[0-9a-fA-F]+$');

// RegExp hexColorRegExp = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

// RegExp base64RegExp = RegExp(r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$');

// RegExp creditCardRegExp = RegExp(r'^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$');

// RegExp isbn10MaybeRegExp = RegExp(r'^(?:[0-9]{9}X|[0-9]{10})$');

// RegExp isbn13MaybeRegExp = RegExp(r'^(?:[0-9]{13})$');

// Map<String, RegExp> uuidRegExp = {
//   '3': RegExp(
//       r'^[0-9A-F]{8}-[0-9A-F]{4}-3[0-9A-F]{3}-[0-9A-F]{4}-[0-9A-F]{12}$'),
//   '4': RegExp(
//       r'^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$'),
//   '5': RegExp(
//       r'^[0-9A-F]{8}-[0-9A-F]{4}-5[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$'),
//   'all': RegExp(r'^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$')
// };

// RegExp multibyteRegExp = RegExp(r'[^\x00-\x7F]');

// RegExp asciiRegExp = RegExp(r'^[\x00-\x7F]+$');

// RegExp fullWidthRegExp = RegExp(r'[^\u0020-\u007E\uFF61-\uFF9F\uFFA0-\uFFDC\uFFE8-\uFFEE0-9a-zA-Z]');

// RegExp halfWidthRegExp = RegExp(r'[\u0020-\u007E\uFF61-\uFF9F\uFFA0-\uFFDC\uFFE8-\uFFEE0-9a-zA-Z]');

// RegExp emojiPattern = RegExp(
//     r'[^\x00-\x7F]|(?:[.]{3})|[\uD83C-\uD83E][\uDDE0-\uDDFF]|[\uD83C-\uD83E][\uDC00-\uDFFF]'
//     '|[\uD83F-\uD87F][\uDC00-\uDFFF]|[\u2600-\u26FF]|[\u2700-\u27BF]'
// );

// RegExp onlyOneEmojiPattern = RegExp(
//     r'[^\x00-\x7F]|(?:[.]{3})|[\uD83C-\uD83E][\uDDE0-\uDDFF]|[\uD83C-\uD83E]'
//     '[\uDC00-\uDFFF]|[\uD83F-\uD87F][\uDC00-\uDFFF]|[\u2600-\u26FF]|[\u2700-\u27BF]'
// );