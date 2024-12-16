import 'package:flutter/material.dart';

class BigUserCard extends StatelessWidget {
  final Color? backgroundColor;
  final Color? settingColor;
  final double? cardRadius;
  final Color? backgroundMotifColor;
  final Widget? cardActionWidget;
  final String? userName;
  final Widget? userMoreInfo;
  final ImageProvider userProfilePic;

  const BigUserCard({
    this.backgroundColor,
    this.settingColor,
    this.cardRadius = 30,
    required this.userName,
    this.backgroundMotifColor = Colors.white,
    this.cardActionWidget,
    this.userMoreInfo,
    required this.userProfilePic,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQueryHeight = MediaQuery.of(context).size.height;

    return Container(
      height: mediaQueryHeight / 4,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(cardRadius ?? 30),
      ),
      child: Stack(
        children: [
          // Background Motif Circles
          Align(
            alignment: Alignment.bottomLeft,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: backgroundMotifColor!.withOpacity(0.1),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 400,
              backgroundColor: backgroundMotifColor!.withOpacity(0.05),
            ),
          ),

          // User Information Section
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: (cardActionWidget != null)
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.center,
              children: [
                // Row for Profile Picture and Name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Profile Picture
                    Expanded(
                      child: CircleAvatar(
                        radius: mediaQueryHeight / 18,
                        backgroundImage: userProfilePic,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // User Name
                          Text(
                            userName!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: mediaQueryHeight / 30,
                              color: Colors.white,
                            ),
                          ),
                          // Optional Additional Info (email, etc.)
                          if (userMoreInfo != null) ...[
                            userMoreInfo!,
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                // Action Button or Widget (if provided)
                if (cardActionWidget != null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: settingColor ?? Theme.of(context).cardColor,
                    ),
                    child: cardActionWidget,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const SettingsItem(
      {required this.title,
      this.subtitle,
      required this.icon,
      this.onTap,
      this.trailing,
      this.margin,
      this.backgroundColor,
      this.iconColor,
      this.fontSize,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 30),
      title: Text(title,
          style: TextStyle(
              fontSize: 16, fontWeight: fontWeight, color: iconColor)),
      iconColor: iconColor,
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      tileColor: Colors.transparent,
    );
  }
}

class SettingsGroup extends StatelessWidget {
  final String? settingsGroupTitle;
  final TextStyle? settingsGroupTitleStyle;
  final List<SettingsItem> items;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? iconItemSize;

  const SettingsGroup({
    this.settingsGroupTitle,
    this.settingsGroupTitleStyle,
    required this.items,
    this.backgroundColor,
    this.margin,
    this.iconItemSize = 25,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Settings Group Title (if provided)
          if (settingsGroupTitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                settingsGroupTitle!,
                style: settingsGroupTitleStyle ??
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          // Settings Items
          Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) => Divider(),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return items[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}
