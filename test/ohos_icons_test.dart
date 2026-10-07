import 'package:flutter_test/flutter_test.dart';
import 'package:ohos_icons/ohos_icons.dart';

void main() {
  test('info map is consistent', () {
    expect(OhosIcons.info.length, OhosIcons.count);
    for (final entry in OhosIcons.info.entries) {
      expect(entry.key, entry.value.name);
      expect(entry.value.codepoint, greaterThan(0));
      expect(entry.value.codepoint, lessThanOrEqualTo(0x10FFFF));
    }
  });

  test('names are unique and sorted', () {
    expect(OhosIcons.names.toSet().length, OhosIcons.names.length);
    expect(OhosIcons.names, orderedEquals([...OhosIcons.names]..sort()));
  });

  test('every constant points to a metadata entry and vice versa', () {
    for (final name in OhosIcons.names) {
      expect(OhosIcons.info[name], isNotNull, reason: 'meta for $name');
      expect(
        OhosIcons.fromName(name).codePoint,
        OhosIcons.info[name]!.codepoint,
      );
    }
  });

  test('snapshot data is available', () {
    expect(OhosIcons.version, isNotEmpty);
    expect(OhosIcons.categories, isNotEmpty);
    expect(OhosIcons.values.length, OhosIcons.count);
  });
}
