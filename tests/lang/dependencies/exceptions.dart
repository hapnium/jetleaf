import 'package:test/test.dart';
import 'package:jetleaf/lang.dart';

const isInvalidArgumentException = TypeMatcher<InvalidArgumentException>();
Matcher throwsInvalidArgumentException = throwsA(isInvalidArgumentException);

const isInvalidFormatException = TypeMatcher<InvalidFormatException>();
Matcher throwsInvalidFormatException = throwsA(isInvalidFormatException);

const isNoGuaranteeException = TypeMatcher<NoGuaranteeException>();
Matcher throwsNoGuaranteeException = throwsA(isNoGuaranteeException);