class EventFilter {
  final String? domain;
  final DateTime? date;
  final bool? isOnline;
  final String? level;

  const EventFilter({
    this.domain,
    this.date,
    this.isOnline,
    this.level,
  });

  bool get hasFilters {
    return domain != null ||
        date != null ||
        isOnline != null ||
        level != null;
  }

  EventFilter copyWith({
    String? domain,
    DateTime? date,
    bool? isOnline,
    String? level,
    bool clearDomain = false,
    bool clearDate = false,
    bool clearMode = false,
    bool clearLevel = false,
  }) {
    return EventFilter(
      domain: clearDomain ? null : domain ?? this.domain,
      date: clearDate ? null : date ?? this.date,
      isOnline: clearMode ? null : isOnline ?? this.isOnline,
      level: clearLevel ? null : level ?? this.level,
    );
  }
}