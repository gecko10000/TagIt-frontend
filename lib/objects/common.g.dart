// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tileableChildrenListHash() =>
    r'f23262187a4f99f31286e7fb0cbb8c71de14c9b7';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$TileableChildrenList
    extends BuildlessAutoDisposeAsyncNotifier<List<Tileable>> {
  late final String? parent;

  FutureOr<List<Tileable>> build({
    String? parent,
  });
}

/// See also [TileableChildrenList].
@ProviderFor(TileableChildrenList)
const tileableChildrenListProvider = TileableChildrenListFamily();

/// See also [TileableChildrenList].
class TileableChildrenListFamily extends Family<AsyncValue<List<Tileable>>> {
  /// See also [TileableChildrenList].
  const TileableChildrenListFamily();

  /// See also [TileableChildrenList].
  TileableChildrenListProvider call({
    String? parent,
  }) {
    return TileableChildrenListProvider(
      parent: parent,
    );
  }

  @override
  TileableChildrenListProvider getProviderOverride(
    covariant TileableChildrenListProvider provider,
  ) {
    return call(
      parent: provider.parent,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tileableChildrenListProvider';
}

/// See also [TileableChildrenList].
class TileableChildrenListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TileableChildrenList, List<Tileable>> {
  /// See also [TileableChildrenList].
  TileableChildrenListProvider({
    this.parent,
  }) : super.internal(
          () => TileableChildrenList()..parent = parent,
          from: tileableChildrenListProvider,
          name: r'tileableChildrenListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tileableChildrenListHash,
          dependencies: TileableChildrenListFamily._dependencies,
          allTransitiveDependencies:
              TileableChildrenListFamily._allTransitiveDependencies,
        );

  final String? parent;

  @override
  bool operator ==(Object other) {
    return other is TileableChildrenListProvider && other.parent == parent;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parent.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<List<Tileable>> runNotifierBuild(
    covariant TileableChildrenList notifier,
  ) {
    return notifier.build(
      parent: parent,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
