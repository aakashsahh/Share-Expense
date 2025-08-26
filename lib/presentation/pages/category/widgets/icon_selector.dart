import 'package:flutter/material.dart';

class IconSelectorPage extends StatefulWidget {
  final IconData? initialSelectedIcon;
  const IconSelectorPage({super.key, this.initialSelectedIcon});

  @override
  State<IconSelectorPage> createState() => _IconSelectorPageState();
}

class _IconSelectorPageState extends State<IconSelectorPage> {
  // the sections and their corresponding icons
  final Map<String, List<IconData>> iconSections = {
    'Subscriptions & Streaming': [
      Icons.subscriptions,
      Icons.tv,
      Icons.music_note,
      Icons.video_library,
      Icons.apple,
      Icons.play_arrow,
      Icons.videogame_asset,
      Icons.podcasts,
      Icons.live_tv,
      Icons.movie,
      Icons.speaker,
      Icons.cast,
      Icons.headset,
    ],
    'Bills & Utilities': [
      Icons.water_drop,
      Icons.flash_on,
      Icons.local_gas_station,
      Icons.lightbulb,
      Icons.phone,
      Icons.wifi,
      Icons.credit_card,
      Icons.attach_money,
      Icons.thermostat,
      Icons.receipt_long,
      Icons.electric_meter,
      Icons.bolt,
      Icons.ev_station,
    ],
    'Groceries & Food': [
      Icons.flatware_outlined,
      Icons.emoji_food_beverage_rounded,
      Icons.fastfood,
      Icons.shopping_cart,
      Icons.shopping_bag,
      Icons.storefront,
      Icons.coffee_sharp,
      Icons.table_restaurant,
      Icons.local_pizza_sharp,
      Icons.local_bar,
      Icons.cake,
      Icons.restaurant,
      Icons.local_pizza,
      Icons.icecream,
      Icons.ramen_dining,
      Icons.set_meal,
    ],
    'Shopping & Fashion': [
      Icons.shopping_bag,
      Icons.percent,
      Icons.emoji_people,
      Icons.directions_run,
      Icons.watch,
      Icons.account_balance_wallet,
      Icons.backpack,
      Icons.card_giftcard,
      Icons.chair,
      Icons.shopping_basket,
      Icons.checkroom,
      Icons.shopping_cart,
      Icons.local_mall,
    ],
    'Transport & Travel': [
      Icons.route,
      Icons.directions_car,
      Icons.directions_bus,
      Icons.directions_bike,
      Icons.flight,
      Icons.train,
      Icons.local_taxi,
      Icons.emoji_transportation,
      Icons.directions_boat,
      Icons.traffic,
      Icons.electric_scooter,
    ],
    'Health & Fitness': [
      Icons.health_and_safety_rounded,
      Icons.local_pharmacy,
      Icons.local_hospital,
      Icons.medical_services,
      Icons.medical_information_outlined,
      Icons.fitness_center,
      Icons.sports_gymnastics,
      Icons.sports_basketball,
      Icons.pool,
      Icons.spa,
      Icons.healing,
      Icons.local_hospital,
      Icons.monitor_heart,
      Icons.pedal_bike,
      Icons.self_improvement,
    ],
    'Entertainment & Leisure': [
      Icons.sports_esports,
      Icons.theater_comedy,
      Icons.music_video,
      Icons.sports_soccer,
      Icons.sports_tennis,
      Icons.casino,
      Icons.celebration,
      Icons.camera_alt,
      Icons.book,
      Icons.palette,
    ],
    'Education & Learning': [
      Icons.school,
      Icons.menu_book,
      Icons.laptop_mac,
      Icons.science,
      Icons.calculate,
      Icons.language,
      Icons.auto_stories,
      Icons.lightbulb_outline,
      Icons.edit,
      Icons.class_,
    ],
    'Home & Family': [
      Icons.home,
      Icons.family_restroom,
      Icons.baby_changing_station,
      Icons.pets,
      Icons.weekend,
      Icons.bed,
      Icons.kitchen,
      Icons.cleaning_services,
      Icons.person,
      Icons.crib,
    ],
    'Finance & Investments': [
      Icons.account_balance,
      Icons.pie_chart,
      Icons.trending_up,
      Icons.money_off,
      Icons.credit_card,
      Icons.savings,
      Icons.insights,
      Icons.bar_chart,
      Icons.monetization_on,
      Icons.account_balance_wallet,
      Icons.wallet,
      Icons.business_center,
    ],
    'Gifts & Donations': [
      Icons.card_giftcard,
      Icons.favorite,
      Icons.volunteer_activism,
      Icons.local_activity,
      Icons.heart_broken,
      Icons.handshake,
      Icons.volunteer_activism_outlined,
      Icons.campaign,
    ],

    'Other': [
      Icons.handyman,
      Icons.star,
      Icons.label,
      Icons.smoking_rooms_outlined,
      Icons.local_offer,
      Icons.liquor_rounded,
      Icons.phone_iphone_rounded,
      Icons.question_mark,
      Icons.more_horiz,
      Icons.category,
      Icons.settings,
      Icons.help_outline,
      Icons.info_outline,
      Icons.extension,
      Icons.bubble_chart,
      Icons.all_inclusive,
      Icons.miscellaneous_services,
      Icons.tune,
    ],
  };
  // variable to keep track of the selected icon index
  int? selectedIndex;
  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedIcon != null) {
      // Find the index of the initial selected icon
      int indexCounter = 0;
      for (var icons in iconSections.values) {
        for (var icon in icons) {
          if (icon == widget.initialSelectedIcon) {
            selectedIndex = indexCounter;
            break;
          }
          indexCounter++;
        }
        if (selectedIndex != null) break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int globalIndex = 0;
    var theme = Theme.of(context);
    return Scaffold(
      // appBar: CustomAppBar(title: 'Choose Icon'),
      appBar: AppBar(
        title: Text('Select Icon'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          TextButton(
            onPressed: () {
              if (selectedIndex != null) {
                IconData? selectedIcon;
                int indexCounter = 0;

                for (var entry in iconSections.entries) {
                  for (var icon in entry.value) {
                    if (indexCounter == selectedIndex) {
                      selectedIcon = icon;
                      break;
                    }
                    indexCounter++;
                  }
                  if (selectedIcon != null) break;
                }

                Navigator.pop(context, selectedIcon); // Sends the selected icon
              } else {
                Navigator.pop(context, null); // No selection made, send null
              }
            },
            //_saveExpense,
            child: Text(
              'Done',
              // _isEditing ? 'Update' : 'Save',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: iconSections.entries.map((section) {
          final widgets = <Widget>[];

          widgets.add(
            Text(
              section.key,
              style: theme.textTheme.titleMedium!.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          );
          widgets.add(SizedBox(height: 12));
          widgets.add(
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: section.value.map((icon) {
                final currentIndex = globalIndex++;
                final isSelected = selectedIndex == currentIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = currentIndex;
                    });
                  },
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      icon,
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
          widgets.add(SizedBox(height: 24));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          );
        }).toList(),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: ElevatedButton.icon(
      //     onPressed: () {
      //       if (selectedIndex != null) {
      //         IconData? selectedIcon;
      //         int indexCounter = 0;

      //         for (var entry in iconSections.entries) {
      //           for (var icon in entry.value) {
      //             if (indexCounter == selectedIndex) {
      //               selectedIcon = icon;
      //               break;
      //             }
      //             indexCounter++;
      //           }
      //           if (selectedIcon != null) break;
      //         }

      //         Navigator.pop(context, selectedIcon); // Sends the selected icon
      //       } else {
      //         Navigator.pop(context, null); // No selection made, send null
      //       }
      //     },
      //     icon: Icon(Icons.check, size: 24),
      //     label: Text("Done"),
      //     style: ElevatedButton.styleFrom(
      //       minimumSize: Size.fromHeight(50),
      //       backgroundColor: Colors.teal[800],
      //       foregroundColor: Colors.white,
      //       textStyle: Theme.of(context).textTheme.headlineMedium,
      //     ),
      //   ),
      // ),
    );
  }
}
