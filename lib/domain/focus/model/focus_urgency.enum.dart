/// How pressing a focus point is today. Drives its color and how loud its countdown is.
enum FocusUrgency {
  /// More than three days left.
  calm,

  /// Three days or less.
  soon,

  /// Due today.
  today,

  /// The day has passed.
  overdue,

  /// Done.
  done,
}
