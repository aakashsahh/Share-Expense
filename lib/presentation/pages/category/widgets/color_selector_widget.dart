// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ColorSelectorWidget extends StatefulWidget {
  final Function(Color) onColorSelected;
  const ColorSelectorWidget({super.key, required this.onColorSelected});

  @override
  ColorSelectorWidgetState createState() => ColorSelectorWidgetState();
}

class ColorSelectorWidgetState extends State<ColorSelectorWidget>
    with SingleTickerProviderStateMixin {
  //late TabController _tabController;
  Color selectedColor = Colors.red;

  final List<Color> primaryColors = [
    Colors.red,
    Colors.pink,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.purple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.teal,
    Color(0xff117E2A),
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.orange,
    Colors.deepOrange,
    Colors.amber,
    Colors.brown,
    Colors.blueGrey,
    Colors.grey,
    Colors.cyan,
    Colors.cyanAccent,
    Color(0xff2BBF7D),
  ];
  List<Color> generateColorShades(Color color) {
    final hslColor = HSLColor.fromColor(color);
    final shades = <Color>[];

    // Generate lighter shades
    for (double i = 0.9; i > 0.4; i -= 0.1) {
      shades.add(hslColor.withLightness(i).toColor());
    }

    // Generate darker shades
    for (double i = 0.4; i >= 0.1; i -= 0.1) {
      shades.add(hslColor.withLightness(i).toColor());
    }

    return shades;
  }

  List<Color> get generatedShades => generateColorShades(selectedColor);

  @override
  void initState() {
    super.initState();
    //_tabController = TabController(length: 3, vsync: this);
  }

  Widget _buildColorGrid(List<Color> colors) {
    return GridView.count(
      crossAxisCount: 7,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(8),
      children: colors.map((color) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedColor = color;
              widget.onColorSelected(color);
            });
          },
          child: Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.check,
              color: selectedColor == color ? Colors.white : Colors.transparent,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TabBar(
        //   controller: _tabController,
        //   labelColor: Colors.black,
        //   unselectedLabelColor: Colors.grey,
        //   indicatorColor: Colors.blue,
        //   tabs: [Tab(text: "Primary"), Tab(text: "Accent"), Tab(text: "Wheel")],
        // ),
        //SizedBox(height: 16),
        Column(
          children: [
            _buildColorGrid(primaryColors),
            Divider(color: Theme.of(context).dividerColor, thickness: 2),
            _buildColorGrid(
              generatedShades,
            ), // Replace with selected color shades
            //   ],
            // ),
            // Center(child: Text("Accent Colors")),
            // Center(child: Text("Color Wheel")),
          ],
        ),
      ],
    );
  }
}
