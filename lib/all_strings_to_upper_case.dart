/// Reflection allows you to inspect and traverse Soia types and values at
/// runtime.
///
/// When *not* to use reflection: when working with a specific type known at
// compile-time, you can directly access the properties and constructor of the
// object, so you dont need reflection.
/// When to use reflection: when the Soia type is passed as a parameter (like
/// the generic T here), you need reflection - the ability to programmatically
/// inspect a type's structure (fields, their types, etc.) and manipulate values
/// without compile-time knowledge of that structure.
///
/// This pattern is useful for building generic utilities like:
/// - Custom validators that work across all your types
/// - Custom formatters/normalizers (like this uppercase example)
/// - Serialization utilities
/// - Any operation that needs to work uniformly across different Soia types

import 'package:soia/soia.dart' as soia;

/// Using reflection, converts all the strings contained in [input] to upper
/// case. Accepts any Soia type.
///
/// Example input:
///   ```dart
///   User(
///     userId: 123,
///     name: "Tarzan",
///     quote: "AAAAaAaAaAyAAAAaAaAaAyAAAAaAaAaA",
///     pets: [
///       User_Pet(
///         name: "Cheeta",
///         heightInMeters: 1.67,
///         picture: "🐒",
///       ),
///     ],
///   )
///   ```
///
/// Example output:
///   ```dart
///   User(
///     userId: 123,
///     name: "TARZAN",
///     quote: "AAAAAAAAAAYAAAAAAAAAAYAAAAAAAAAA",
///     pets: [
///       User_Pet(
///         name: "CHEETA",
///         heightInMeters: 1.67,
///         picture: "🐒",
///       ),
///     ],
///   )
///   ```
///
T allStringsToUpperCase<T>(
    T input, soia.ReflectiveTypeDescriptor<T> descriptor) {
  final visitor = _ToUpperCaseVisitor<T>(input);
  descriptor.accept(visitor);
  return visitor.result;
}

class _ToUpperCaseTransformer implements soia.ReflectiveTransformer {
  const _ToUpperCaseTransformer();

  @override
  T transform<T>(T input, soia.ReflectiveTypeDescriptor<T> descriptor) {
    return allStringsToUpperCase(input, descriptor);
  }
}

class _ToUpperCaseVisitor<T> extends soia.NoopReflectiveTypeVisitor<T> {
  final T input;
  T result;

  _ToUpperCaseVisitor(this.input) : result = input;
  @override
  void visitOptional<NotNull>(
      soia.ReflectiveOptionalDescriptor<NotNull> descriptor,
      soia.TypeEquivalence<T, NotNull?> equivalence) {
    result = equivalence.toT(
      descriptor.map(
        equivalence.fromT(input),
        const _ToUpperCaseTransformer(),
      ),
    );
  }

  @override
  void visitArray<E, Collection extends Iterable<E>>(
      soia.ReflectiveArrayDescriptor<E, Collection> descriptor,
      soia.TypeEquivalence<T, Collection> equivalence) {
    result = equivalence.toT(
      descriptor.map(
        equivalence.fromT(input),
        const _ToUpperCaseTransformer(),
      ),
    );
  }

  @override
  void visitStruct<Mutable>(
      soia.ReflectiveStructDescriptor<T, Mutable> descriptor) {
    result = descriptor.mapFields(input, const _ToUpperCaseTransformer());
  }

  @override
  void visitEnum(soia.ReflectiveEnumDescriptor<T> descriptor) {
    result = descriptor.mapValue(
      input,
      const _ToUpperCaseTransformer(),
    );
  }

  @override
  void visitString(soia.TypeEquivalence<T, String> equivalence) {
    result = equivalence.toT(
      equivalence.fromT(input).toUpperCase(),
    );
  }
}
