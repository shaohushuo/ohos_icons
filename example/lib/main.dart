import 'package:flutter/material.dart';
import 'package:ohos_icons/ohos_icons.dart';

void main() => runApp(const OhosIconsGalleryApp());

class OhosIconsGalleryApp extends StatelessWidget {
  const OhosIconsGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ohos_icons gallery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const GalleryPage(),
    );
  }
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final TextEditingController _search = TextEditingController();
  final List<String> _categories = OhosIcons.categories;
  String? _category;

  List<OhosIconMeta> get _filtered {
    final query = _search.text.trim().toLowerCase();
    final metas = OhosIcons.info.values.where((m) {
      if (_category != null && !m.categories.contains(_category)) return false;
      if (query.isEmpty) return true;
      return m.name.toLowerCase().contains(query) || m.label.contains(query);
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return metas;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metas = _filtered;
    return Scaffold(
      appBar: AppBar(title: const Text('ohos_icons gallery')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: '搜索 name / 中文名',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                ChoiceChip(
                  label: const Text('全部'),
                  selected: _category == null,
                  onSelected: (_) => setState(() => _category = null),
                ),
                for (final c in _categories)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: _category == c,
                      onSelected: (_) => setState(() => _category = c),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '共 ${metas.length} 个图标   (${OhosIcons.count} 总, v${OhosIcons.version})',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(bottom: 24),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 120,
                childAspectRatio: 1,
              ),
              itemCount: metas.length,
              itemBuilder: (context, index) {
                final meta = metas[index];
                return Tooltip(
                  message:
                      '${meta.name}\n${meta.label}\n${meta.supportVersion}',
                  child: GestureDetector(
                    onTap: () => showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(meta.name),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(meta.icon, size: 96),
                            const SizedBox(height: 12),
                            Text(meta.label),
                            Text(meta.module),
                            Text(meta.supportVersion),
                          ],
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(meta.icon, size: 32),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            meta.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
