import 'package:flutter/material.dart';
import 'package:parking_app/screen/nav_bar.dart';
import 'package:parking_app/screen/parking_lot.dart';

class ParkingHome extends StatefulWidget {
  const ParkingHome({super.key});

  @override
  State<ParkingHome> createState() => _ParkingHomeState();
}

class _ParkingHomeState extends State<ParkingHome> {
  final Map<String, List<String>> _mallMap = {
    'Off-street (Mall)': [
      'iOi City Mall',
      '1 Mont Kiara',
      'Berjaya Mall',
      'East Coast Mall',
    ],
    'On-street': ['Perkarangan Bandar Selatan', 'Aeon Maluri'],
  };

  final List<String> _categories = ['Off-street (Mall)', 'On-street'];
  String _selectedCategory = 'Off-street (Mall)';
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered =
        _mallMap[_selectedCategory]!
            .where((mall) => mall.toLowerCase().contains(_search))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ParkSini'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: const Color(0xFFFDF6FF),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SearchField(
              onChanged:
                  (value) => setState(() => _search = value.toLowerCase()),
            ),
            const SizedBox(height: 10),

            _CategoryDropdown(
              categories: _categories,
              value: _selectedCategory,
              onChanged:
                  (value) => setState(() {
                    _selectedCategory = value!;
                    _search = '';
                  }),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, index) {
                  final mall = filtered[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(mall),
                      tileColor: Colors.grey.shade300,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => NavBarCategorySelectionScreen(
                                  initialIndex: 1,
                                  overridePage: ParkingLotInfoPage(
                                    mallName: mall,
                                  ),
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////  Widgets  ////////////////////

class _SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        decoration: const InputDecoration(
          icon: Icon(Icons.search),
          hintText: 'Search',
          border: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  final List<String> categories;
  final String value;
  final ValueChanged<String?> onChanged;

  const _CategoryDropdown({
    required this.categories,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items:
              categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
