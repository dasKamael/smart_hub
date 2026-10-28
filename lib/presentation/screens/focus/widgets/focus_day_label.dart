const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const _longMonths = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// "Fri, 6 Nov" – the day a focus point is due, short enough for a tile.
String focusDayLabel(DateTime day) => '${_weekdays[day.weekday - 1]}, ${day.day} ${_months[day.month - 1]}';

/// "November 2026" – the month over a calendar.
String focusMonthLabel(DateTime day) => '${_longMonths[day.month - 1]} ${day.year}';

/// The weekday letters over a calendar, Monday first.
const focusWeekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
