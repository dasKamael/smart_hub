enum WateringState {
  /// The due date has passed.
  overdue,
  dueToday,
  wateredToday,
  upcoming;

  /// Needs water now.
  bool get isDue => this == overdue || this == dueToday;
}
