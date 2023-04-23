// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_browser.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentTagHash() => r'16af23238fd42f5164580f00c3fbef2e5b96f4ea';

/// See also [CurrentTag].
@ProviderFor(CurrentTag)
final currentTagProvider =
    AutoDisposeNotifierProvider<CurrentTag, Tag?>.internal(
  CurrentTag.new,
  name: r'currentTagProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentTagHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentTag = AutoDisposeNotifier<Tag?>;
String _$tagBrowserListHash() => r'1db56cf9731970b7888b2fb1dc7161d8bc9d9a46';

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

abstract class _$TagBrowserList
    extends BuildlessAutoDisposeAsyncNotifier<List<Tileable>> {
  late final String? parent;

  FutureOr<List<Tileable>> build({
    String? parent,
  });
}

/// See also [TagBrowserList].
@ProviderFor(TagBrowserList)
const tagBrowserListProvider = TagBrowserListFamily();

/// See also [TagBrowserList].
class TagBrowserListFamily extends Family<AsyncValue<List<Tileable>>> {
  /// See also [TagBrowserList].
  const TagBrowserListFamily();

  /// See also [TagBrowserList].
  TagBrowserListProvider call({
    String? parent,
  }) {
    return TagBrowserListProvider(
      parent: parent,
    );
  }

  @override
  TagBrowserListProvider getProviderOverride(
    covariant TagBrowserListProvider provider,
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
  String? get name => r'tagBrowserListProvider';
}

/// See also [TagBrowserList].
class TagBrowserListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TagBrowserList, List<Tileable>> {
  /// See also [TagBrowserList].
  TagBrowserListProvider({
    this.parent,
  }) : super.internal(
          () => TagBrowserList()..parent = parent,
          from: tagBrowserListProvider,
          name: r'tagBrowserListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tagBrowserListHash,
          dependencies: TagBrowserListFamily._dependencies,
          allTransitiveDependencies:
              TagBrowserListFamily._allTransitiveDependencies,
        );

  final String? parent;

  @override
  bool operator ==(Object other) {
    return other is TagBrowserListProvider && other.parent == parent;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parent.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<List<Tileable>> runNotifierBuild(
    covariant TagBrowserList notifier,
  ) {
    return notifier.build(
      parent: parent,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
