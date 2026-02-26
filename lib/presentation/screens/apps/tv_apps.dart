import 'package:flutter/material.dart';

class TvAppDefinition {
  const TvAppDefinition({
    required this.id,
    required this.name,
    required this.packageName,
    this.activityName,
    required this.brandColor,
    required this.icon,
  });

  final String id;
  final String name;
  final String packageName;
  final String? activityName;
  final Color brandColor;
  final IconData icon;
}

const tvApps = <TvAppDefinition>[
  TvAppDefinition(
    id: 'youtube',
    name: 'YouTube',
    packageName: 'com.google.android.youtube.tv',
    activityName:
        'com.google.android.youtube.tv/com.google.android.apps.youtube.tv.activity.ShellActivity',
    brandColor: Color(0xFFFF0000),
    icon: Icons.ondemand_video_rounded,
  ),
  TvAppDefinition(
    id: 'netflix',
    name: 'Netflix',
    packageName: 'com.netflix.ninja',
    brandColor: Color(0xFFE50914),
    icon: Icons.movie_filter_rounded,
  ),
  TvAppDefinition(
    id: 'prime_video',
    name: 'Prime Video',
    packageName: 'com.amazon.amazonvideo.livingroom',
    brandColor: Color(0xFF00A8E1),
    icon: Icons.play_circle_filled_rounded,
  ),
  TvAppDefinition(
    id: 'play_store',
    name: 'Play Store',
    packageName: 'com.android.vending',
    activityName:
        'com.android.vending/com.google.android.finsky.tvmainactivity.TvMainActivity',
    brandColor: Color(0xFF34A853),
    icon: Icons.shop_rounded,
  ),
  TvAppDefinition(
    id: 'disney_plus',
    name: 'Disney+',
    packageName: 'com.disney.disneyplus',
    brandColor: Color(0xFF113CCF),
    icon: Icons.auto_awesome_rounded,
  ),
  TvAppDefinition(
    id: 'hulu',
    name: 'Hulu',
    packageName: 'com.hulu.livingroomplus',
    brandColor: Color(0xFF1CE783),
    icon: Icons.live_tv_rounded,
  ),
  TvAppDefinition(
    id: 'plex',
    name: 'Plex',
    packageName: 'com.plexapp.android',
    brandColor: Color(0xFFEBAF00),
    icon: Icons.video_library_rounded,
  ),
  TvAppDefinition(
    id: 'kodi',
    name: 'Kodi',
    packageName: 'org.xbmc.kodi',
    brandColor: Color(0xFF2E9AD0),
    icon: Icons.apps_rounded,
  ),
];
