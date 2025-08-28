import 'package:flutter/material.dart';

class IconSelectorPage extends StatefulWidget {
  final IconData? initialSelectedIcon;
  const IconSelectorPage({super.key, this.initialSelectedIcon});

  @override
  State<IconSelectorPage> createState() => _IconSelectorPageState();
}

class _IconSelectorPageState extends State<IconSelectorPage> {
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

  int? selectedIndex;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedIcon != null) {
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Map<String, List<IconData>> get filteredSections {
    if (searchQuery.isEmpty) return iconSections;

    Map<String, List<IconData>> filtered = {};
    iconSections.forEach((section, icons) {
      List<IconData> matchingIcons = icons.where((icon) {
        String iconName = icon.toString().toLowerCase();
        return iconName.contains(searchQuery.toLowerCase()) ||
            section.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      if (matchingIcons.isNotEmpty) {
        filtered[section] = matchingIcons;
      }
    });
    return filtered;
  }

  void _selectIcon() {
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
      Navigator.pop(context, selectedIcon);
    } else {
      Navigator.pop(context, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate optimal grid dimensions based on screen width
    final crossAxisCount = screenWidth > 600
        ? 8
        : screenWidth > 400
        ? 6
        : 5;
    final iconSize =
        (screenWidth - 32 - (crossAxisCount - 1) * 8) / crossAxisCount;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Text('Select Icon'),
        actions: [
          FilledButton(
            onPressed: selectedIndex != null ? _selectIcon : null,
            style: FilledButton.styleFrom(
              backgroundColor: selectedIndex != null
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.3),
              foregroundColor: selectedIndex != null
                  ? colorScheme.onPrimary
                  : colorScheme.outline,
              minimumSize: const Size(80, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Done',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search icons...',
              leading: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
              trailing: searchQuery.isNotEmpty
                  ? [
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      ),
                    ]
                  : null,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              backgroundColor: WidgetStatePropertyAll(
                colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              elevation: const WidgetStatePropertyAll(0),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
          ),

          // Selected Icon Preview (if any)
          if (selectedIndex != null) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getSelectedIcon(),
                      color: colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Selected Icon',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Icons Grid
          Expanded(
            child: filteredSections.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No icons found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: filteredSections.length,
                    itemBuilder: (context, sectionIndex) {
                      final entry = filteredSections.entries.elementAt(
                        sectionIndex,
                      );
                      final sectionTitle = entry.key;
                      final sectionIcons = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    sectionTitle,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer
                                        .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${sectionIcons.length}',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Icons Grid
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 1,
                                  ),
                              itemCount: sectionIcons.length,
                              itemBuilder: (context, iconIndex) {
                                final icon = sectionIcons[iconIndex];
                                final globalIndex = _getGlobalIndex(
                                  sectionTitle,
                                  iconIndex,
                                );
                                final isSelected = selectedIndex == globalIndex;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = globalIndex;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? colorScheme.primary
                                          : colorScheme.surfaceContainerHighest
                                                .withValues(alpha: 0.7),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? colorScheme.primary
                                            : colorScheme.outline.withValues(
                                                alpha: 0.2,
                                              ),
                                        width: isSelected ? 2 : 1,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: colorScheme.primary
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Icon(
                                      icon,
                                      color: isSelected
                                          ? colorScheme.onPrimary
                                          : colorScheme.onSurface,
                                      size: iconSize * 0.4,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  IconData? _getSelectedIcon() {
    if (selectedIndex == null) return null;

    int indexCounter = 0;
    for (var entry in iconSections.entries) {
      for (var icon in entry.value) {
        if (indexCounter == selectedIndex) {
          return icon;
        }
        indexCounter++;
      }
    }
    return null;
  }

  int _getGlobalIndex(String sectionTitle, int localIndex) {
    int globalIndex = 0;

    for (var entry in iconSections.entries) {
      if (entry.key == sectionTitle) {
        return globalIndex + localIndex;
      }
      globalIndex += entry.value.length;
    }
    return globalIndex;
  }
}
