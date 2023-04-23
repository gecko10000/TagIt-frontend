// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_browser.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentTagHash() => r'3660ae09da7e97b57c07502168e455d6b13915ce';

/// See also [CurrentTag].
@ProviderFor(CurrentTag)
final currentTagProvider = NotifierProvider<CurrentTag, Tag?>.internal(
  CurrentTag.new,
  name: r'currentTagProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentTagHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentTag = Notifier<Tag?>;
String _$tagBrowserListHash() => r'e9fd1da0f1f24be03b78a4a24baf19dfa39cdbf9';

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
