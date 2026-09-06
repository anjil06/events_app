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
      title: 'Artificial Intelligence',
subtitle: 'LLMs, AI Agents & Multimodal Models',
icon: Icons.psychology_rounded,
tag: 'AI',
postCount: 1420,
    ),
TechTrendingTopic(
      title: 'Web Development',
subtitle: 'Next-Gen Frontend, Wasm & SSR',
icon: Icons.language_rounded,
tag: 'Web Development',
postCount: 980,
    ),
TechTrendingTopic(
      title: 'Mobile Development',
subtitle: 'Flutter 3, SwiftUI & Jetpack Compose',
icon: Icons.phone_android_rounded,
tag: 'App Development',
postCount: 840,
    ),
TechTrendingTopic(
      title: 'Cloud Computing',
subtitle: 'Distributed Systems & Serverless',
icon: Icons.cloud_outlined,
tag: 'Cloud',
postCount: 650,
    ),
TechTrendingTopic(
      title: 'Cybersecurity',
subtitle: 'Zero Trust & Cloud Hardening',
icon: Icons.security_rounded,
tag: 'Cybersecurity',
postCount: 520,
    ),
TechTrendingTopic(
      title: 'Data Science',
subtitle: 'Big Data, Analytics & ML Pipelines',
icon: Icons.analytics_rounded,
tag: 'Data Science',
postCount: 710,
    ),
  ];

static const List<TechStoryModel> latestStories = [
    TechStoryModel(
      id: 'story-1',
title: 'The Rise of Autonomous AI Agents in 2026',
excerpt: 'How multi-agent architectures and tool-calling models are redefining modern software development workflows.',
category: 'AI',
author: 'Elena Rostova',
readTime: '5 min read',
date: 'Today',
imageUrl: 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800&auto=format&fit=crop&q=80',
likes: 342,
    ),
TechStoryModel(
      id: 'story-2',
title: 'Modern Cross-Platform Mastery with Flutter & Dart',
excerpt: 'Deep dive into pattern matching, record types, and native performance optimizations in Dart 3.',
category: 'Mobile Dev',
author: 'Kavita Rao',
readTime: '7 min read',
date: 'Yesterday',
imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&auto=format&fit=crop&q=80',
likes: 289,
    ),
TechStoryModel(
      id: 'story-3',
title: 'Zero-Trust Architecture for Cloud Microservices',
excerpt: 'Practical patterns for mutual TLS, ephemeral tokens, and least-privilege service mesh policies.',
category: 'Cloud & Security',
author: 'Marcus Vance',
readTime: '6 min read',
date: '2 days ago',
imageUrl: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800&auto=format&fit=crop&q=80',
likes: 195,
    ),
TechStoryModel(
      id: 'story-4',
title: 'Rust & WebAssembly: Building Near-Native Web Apps',
excerpt: 'Pushing browser performance limits by executing compiled Rust code in high-throughput data processing.',
category: 'Web Dev',
author: 'Kenji Sato',
readTime: '8 min read',
date: '3 days ago',
imageUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800&auto=format&fit=crop&q=80',
likes: 412,
    ),
TechStoryModel(
      id: 'story-5',
title: 'Open Source AI Tooling: From Prototype to Scale',
excerpt: 'Evaluating local model orchestration, vector embeddings, and retrieval pipelines for indie developers.',
category: 'Startups & Tools',
author: 'Sarah Chen',
readTime: '4 min read',
date: '4 days ago',
imageUrl: 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=800&auto=format&fit=crop&q=80',
likes: 518,
    ),
  ];

static List<EventModel> defaultEvents = [
    EventModel(
      id: 'tc_evt_1',
title: 'Global AI & Autonomous Agent Hackathon 2026',
description: 'Join over 2,500 builders worldwide for a 48-hour sprint creating cutting-edge autonomous AI agents, multi-agent frameworks, and multimodal tools. Grand prizes include 50,000 USD in venture grants and cloud credits.',
category: 'Hackathons',
domain: 'AI & ML',
organizerId: 'techculture_community',
organizerName: 'TechCulture Global Labs',
date: DateTime.now().add(const Duration(days: 4)),
time: '09:00 AM - 09:00 PM UTC',
location: 'Virtual • Worldwide Online',
isOnline: true,
level: 'All Levels',
registrationDeadline: DateTime.now().add(const Duration(days: 3)),
imageUrl: 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=800&auto=format&fit=crop&q=80',
createdAt: DateTime.now(),
    ),
EventModel(
      id: 'tc_evt_2',
title: 'TechCulture Annual Developer Summit 2026',
description: 'The flagship conference uniting frontend architects, backend engineers, and AI pioneers. Keynotes from industry leaders, technical deep dives, live demonstrations, and executive networking sessions.',
category: 'Meetups',
domain: 'Cloud Computing',
organizerId: 'techculture_events',
organizerName: 'TechCulture Collective',
date: DateTime.now().add(const Duration(days: 10)),
time: '10:00 AM - 06:00 PM EST',
location: 'Metropolitan Tech Center, New York & Streamed Online',
isOnline: false,
level: 'Intermediate',
registrationDeadline: DateTime.now().add(const Duration(days: 8)),
imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&auto=format&fit=crop&q=80',
createdAt: DateTime.now(),
    ),
EventModel(
      id: 'tc_evt_3',
title: 'Mastering Flutter & Riverpod Architecture Workshop',
description: 'Hands-on live workshop covering clean architecture, state management with Riverpod 3, GoRouter navigation, offline caching, and zero-jank 120fps animations in modern Flutter apps.',
category: 'Workshops',
domain: 'App Development',
organizerId: 'flutter_dev_guild',
organizerName: 'TechCulture Mobile Guild',
date: DateTime.now().add(const Duration(days: 7)),
time: '02:00 PM - 05:30 PM PST',
location: 'Live Interactive Workshop Room',
isOnline: true,
level: 'Intermediate',
registrationDeadline: DateTime.now().add(const Duration(days: 6)),
imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&auto=format&fit=crop&q=80',
createdAt: DateTime.now(),
    ),
EventModel(
      id: 'tc_evt_4',
title: 'Algorithmic Code Sprint & Contest 2026',
description: 'Test your problem-solving, dynamic programming, and data structure speed against top competitive programmers globally. 6 challenges, 3 hours, real-time leaderboard.',
category: 'Coding',
domain: 'Programming',
organizerId: 'algo_masters',
organizerName: 'TechCulture Competitive League',
date: DateTime.now().add(const Duration(days: 12)),
time: '04:00 PM - 07:00 PM UTC',
location: 'Online Code Arena',
isOnline: true,
level: 'Advanced',
registrationDeadline: DateTime.now().add(const Duration(days: 11)),
imageUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800&auto=format&fit=crop&q=80',
createdAt: DateTime.now(),
    ),
EventModel(
      id: 'tc_evt_5',
title: 'Zero-Trust Defense & Cloud Security Meetup',
description: 'An evening of tech discussions on securing cloud environments, supply chain vulnerabilities, IAM governance, and modern defensive tooling with leading security researchers.',
category: 'Meetups',
domain: 'Cyber Security',
organizerId: 'infosec_network',
organizerName: 'TechCulture Security Circle',
date: DateTime.now().add(const Duration(days: 15)),
time: '06:30 PM - 09:00 PM PST',
location: 'Civic Innovation Hub, San Francisco',
isOnline: false,
level: 'Beginner',
registrationDeadline: DateTime.now().add(const Duration(days: 14)),
imageUrl: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800&auto=format&fit=crop&q=80',
createdAt: DateTime.now(),
    ),
EventModel(
      id: 'tc_evt_6',
title: 'Full-Stack WebAssembly & Next.js Webinar',
description: 'Learn how to integrate WebAssembly modules directly into serverless edge functions and React/Next.js client pipelines for compute-heavy applications.',
category: 'Webinars',
domain: 'Web Development',
organizerId: 'web_builders',
organizerName: 'TechCulture Frontend Alliance',
date: DateTime.now().add(const Duration(days: 18)),
time: '01:00 PM - 03:00 PM EST',
location: 'TechCulture Broadcast Stage',
isOnline: true,
level: 'Beginner',
registrationDeadline: DateTime.now().add(const Duration(days: 17)),
imageUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800&auto=format&fit=crop&q=80',
createdAt: DateTime.now(),
    ),
  ];
}
