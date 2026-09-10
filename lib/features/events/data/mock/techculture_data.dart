import 'package:flutter/material.dart';
import '../../domain/models/event_model.dart';

class TechTrendingTopic {
  final String title;
  final String subtitle;
  final IconData icon;
  final String tag;
  final int postCount;

const TechTrendingTopic({
    required this.title,
 required this.subtitle,
 required this.icon,
 required this.tag,
 required this.postCount,
  });
}

class TechStoryModel {
  final String id;
  final String title;
  final String excerpt;
  final String category;
  final String author;
  final String readTime;
  final String date;
  final String imageUrl;
  final int likes;

const TechStoryModel({
    required this.id,
 required this.title,
 required this.excerpt,
 required this.category,
 required this.author,
 required this.readTime,
 required this.date,
 required this.imageUrl,
 required this.likes,
  });
}

class TechCultureData {
  TechCultureData._();

static const List<TechTrendingTopic> trendingTopics = [
    TechTrendingTopic(
      title: 'National Hackathons',
subtitle: '36-Hour Hackathons & AI Sprints',
icon: Icons.code_rounded,
tag: 'Hackathons',
postCount: 3100,
    ),
TechTrendingTopic(
      title: 'Annual College Fests',
subtitle: 'Inter-College Mega Festivals & Trophies',
icon: Icons.festival_rounded,
tag: 'College Fest',
postCount: 2850,
    ),
TechTrendingTopic(
      title: 'Coding & AI Contests',
subtitle: 'DSA Contests, Bot Wars & Hackathons',
icon: Icons.terminal_rounded,
tag: 'Coding & AI',
postCount: 2420,
    ),
TechTrendingTopic(
      title: 'Dance & Choreography',
subtitle: 'Western, Classical & Hip-Hop Battles',
icon: Icons.nightlife_rounded,
tag: 'Dance',
postCount: 1980,
    ),
TechTrendingTopic(
      title: 'Music & Pro-Nights',
subtitle: 'Battle of Bands, Vocals & Live Concerts',
icon: Icons.music_note_rounded,
tag: 'Music',
postCount: 2130,
    ),
TechTrendingTopic(
      title: 'Robotics & Innovations',
subtitle: 'RoboWars, Drones & IoT Expos',
icon: Icons.smart_toy_rounded,
tag: 'Robotics & Tech',
postCount: 1650,
    ),
TechTrendingTopic(
      title: 'Drama & Nukkad Natak',
subtitle: 'Street Play, Theatrical Skits & Mime',
icon: Icons.theater_comedy_rounded,
tag: 'Drama & Theatre',
postCount: 1240,
    ),
TechTrendingTopic(
      title: 'Fashion & Glamour',
subtitle: 'Campus Runway, Vogue & Couture',
icon: Icons.style_rounded,
tag: 'Fashion Show',
postCount: 980,
    ),
  ];

static const List<TechStoryModel> latestStories = [
    TechStoryModel(
      id: 'story-1',
title: 'Cracking 36-Hour Hackathons: Blueprint from National AI Winners',
excerpt: 'From ideation pitching to last-minute API debugging: key insights and architecture templates that take hackathon podium finishes.',
category: 'Technical & Hackathons',
author: 'Aditya Roy',
readTime: '5 min read',
date: 'Today',
imageUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800&auto=format&fit=crop&q=80',
likes: 820,
    ),
TechStoryModel(
      id: 'story-2',
title: 'Inside Tarang: How Campus Teams Prepare for National College Fests',
excerpt: 'From 3 AM choreography practices to prop fabrication, how student councils build award-winning cultural representations.',
category: 'College Fest',
author: 'Aarav Sharma',
readTime: '5 min read',
date: 'Yesterday',
imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&auto=format&fit=crop&q=80',
likes: 640,
    ),
TechStoryModel(
      id: 'story-3',
title: 'Autonomous Bot Wars: Engineering the Ultimate Combat Robot',
excerpt: 'Pneumatic flippers, high-RPM spinners, and telemetry: how engineering clubs design champion combat bots.',
category: 'Robotics & Tech',
author: 'Devendra Patel',
readTime: '6 min read',
date: '2 days ago',
imageUrl: 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=800&auto=format&fit=crop&q=80',
likes: 580,
    ),
TechStoryModel(
      id: 'story-4',
title: 'Battle of the Bands 2026: The Rise of Indie Fusion on Campus',
excerpt: 'How college rock bands are blending classical instrumentation with heavy distortion to dominate annual fest pro-stages.',
category: 'Music',
author: 'Vikram Joshi',
readTime: '6 min read',
date: '3 days ago',
imageUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=800&auto=format&fit=crop&q=80',
likes: 530,
    ),
TechStoryModel(
      id: 'story-5',
title: 'Step Up: Choreographing Winning Western Dance Routines',
excerpt: 'Key strategies for music transitions, stage formations, and synchronization in high-tempo inter-college dance face-offs.',
category: 'Dance',
author: 'Ananya Mehta',
readTime: '4 min read',
date: '4 days ago',
imageUrl: 'https://images.unsplash.com/photo-1547153760-18fc86324498?w=800&auto=format&fit=crop&q=80',
likes: 712,
    ),
TechStoryModel(
      id: 'story-6',
title: 'The Surge of Street Play (Nukkad Natak) in University Competitions',
excerpt: 'Dafli rhythms, synchronized shouts, and hard-hitting messages: why Nukkad Natak remains the soul of campus drama.',
category: 'Drama & Theatre',
author: 'Riya Sen',
readTime: '4 min read',
date: '5 days ago',
imageUrl: 'https://images.unsplash.com/photo-1507676184212-d03ab07a01bf?w=800&auto=format&fit=crop&q=80',
likes: 490,
    ),
  ];

static List<EventModel> defaultEvents = [
    EventModel(
      id: 'tc_evt_1',
title: 'Tarang 2026 - National Inter-College Cultural & Tech Fest',
description: 'The flagship inter-college cultural & tech extravaganza uniting over 80 colleges nationwide. 3 days of high-octane dance battles, band showdowns, hackathons, robo-wars, fashion ramp, and star-studded celebrity pro-nights.',
category: 'College Fests',
domain: 'Inter-College Fest',
organizerId: 'techculture_community',
organizerName: 'University Student Council & Cultural Affairs',
date: DateTime.now().add(const Duration(days: 4)),
time: '09:00 AM - 10:00 PM',
location: 'Grand University Amphitheatre & Sports Arena',
isOnline: false,
level: 'All Levels',
registrationDeadline: DateTime.now().add(const Duration(days: 3)),
imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&auto=format&fit=crop&q=80',
createdAt: DateTime.now(),
    ),
EventModel(
      id: 'tc_evt_2',
title: 'HackCulture 2026: 36-Hour National AI & Web3 Hackathon',
description: 'Build next-generation generative AI, agentic systems, and decentralized applications in an intense 36-hour sprint. Cash pool of \$10,000, cloud credits, and direct investor pitches.',
category: 'Technical & Hackathons',
domain: 'AI & Machine Learning',
organizerId: 'techculture_labs',
organizerName: 'National Developer Guild & ACM Student Chapter',
date: DateTime.now().add(const Duration(days: 6)),
time: '10:00 AM - 10:00 PM (36 Hours)',
location: 'Tech Hub Auditorium & Innovation Center',
isOnline: false,
level: 'Intermediate',
registrationDeadline: DateTime.now().add(const Duration(days: 4)),
imageUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800&auto=format&fit=crop&q=80',
createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
EventModel(
      id: 'tc_evt_3',
title: 'Rhythm & Beats: National Western & Street Dance Championship',
description: 'Showcase your crew sync, isolation, popping, and breakdance moves in the biggest inter-college dance battle of the year. Grand cash prizes and trophies for Solo and Mega-Crew divisions.',
category: 'Dance',
domain: 'Solo & Group Dance',
organizerId: 'techculture_events',
organizerName: 'Campus Choreography Society',
date: DateTime.now().add(const Duration(days: 8)),
time: '11:00 AM - 07:00 PM',
location: 'Centennial Auditorium, Main Stage',
isOnline: false,
level: 'All Levels',
registrationDeadline: DateTime.now().add(const Duration(days: 6)),
imageUrl: 'https://images.unsplash.com/photo-1547153760-18fc86324498?w=800&auto=format&fit=crop&q=80',
createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
EventModel(
      id: 'tc_evt_4',
title: 'CodeClash: National Competitive Programming Cup',
description: 'Test your algorithmic mastery across dynamic programming, graph theory, and advanced data structures. Timed contest with live leaderboards and ACM-ICPC style penalty scoring.',
category: 'Coding & AI',
domain: 'Competitive Programming',
organizerId: 'code_society',
organizerName: 'Competitive Coders Association',
date: DateTime.now().add(const Duration(days: 9)),
time: '02:00 PM - 06:00 PM',
location: 'Virtual & Central Computer Center',
isOnline: true,
level: 'Advanced',
registrationDeadline: DateTime.now().add(const Duration(days: 7)),
imageUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800&auto=format&fit=crop&q=80',
createdAt: DateTime.now().subtract(const Duration(hours: 9)),
    ),
EventModel(
      id: 'tc_evt_5',
title: 'Thunderstruck: Inter-College Battle of the Bands 2026',
description: 'Electric guitars, hard-hitting drum solos, and soaring vocals. 16 top college rock, fusion, and metal bands face off for the title of National Campus Rock Champions.',
category: 'Music',
domain: 'Battle of the Bands',
organizerId: 'music_guild',
organizerName: 'University Music Club',
date: DateTime.now().add(const Duration(days: 10)),
time: '04:00 PM - 09:30 PM',
location: 'Open Air Theatre (OAT), North Campus',
isOnline: false,
level: 'Intermediate',
registrationDeadline: DateTime.now().add(const Duration(days: 8)),
imageUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=800&auto=format&fit=crop&q=80',
createdAt: DateTime.now().subtract(const Duration(hours: 14)),
    ),
EventModel(
      id: 'tc_evt_6',
title: 'RoboWars & Autonomous Drone Grand Prix',
description: 'Heavyweight combat robots face off in a bulletproof cage with pneumatic weapons and spinning blades, followed by FPV drone racing through obstacle courses.',
category: 'Robotics & Gaming',
domain: 'Robotics & IoT',
organizerId: 'robotics_club',
organizerName: 'Robotics & Mechatronics Society',
date: DateTime.now().add(const Duration(days: 12)),
time: '10:00 AM - 05:00 PM',
location: 'Indoor Sports Arena, Court B',
isOnline: false,
level: 'Intermediate',
registrationDeadline: DateTime.now().add(const Duration(days: 10)),
imageUrl: 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=800&auto=format&fit=crop&q=80',
createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
EventModel(
      id: 'tc_evt_7',
title: 'Nukkad Natak & Street Theatre National Trophy 2026',
description: 'Powerful voices, rhythmic clapping, and hard-hitting social satire. Compete in the university circle street play tournament bringing raw emotion and social commentary to life.',
category: 'Drama & Theatre',
domain: 'Street Play (Nukkad)',
organizerId: 'drama_circle',
organizerName: 'Campus Dramatics Society',
date: DateTime.now().add(const Duration(days: 14)),
time: '10:00 AM - 04:00 PM',
location: 'Central Fountain Plaza',
isOnline: false,
level: 'All Levels',
registrationDeadline: DateTime.now().add(const Duration(days: 12)),
imageUrl: 'https://images.unsplash.com/photo-1507676184212-d03ab07a01bf?w=800&auto=format&fit=crop&q=80',
createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
EventModel(
      id: 'tc_evt_8',
title: 'Vogue Odyssey: Inter-University Fashion Runway 2026',
description: 'Elegance meets avant-garde creativity. Teams showcase high-concept styling, sustainable textiles, and runway charisma in this premier college fashion walk competition.',
category: 'Fashion Show',
domain: 'Runway & Fashion Walk',
organizerId: 'fashion_club',
organizerName: 'University Fashion & Design Club',
date: DateTime.now().add(const Duration(days: 16)),
time: '06:00 PM - 09:30 PM',
location: 'Convention Center, Grand Ballroom',
isOnline: false,
level: 'Advanced',
registrationDeadline: DateTime.now().add(const Duration(days: 14)),
imageUrl: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80',
createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
}
