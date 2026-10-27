/// Widget sizes in grid units (`README` → "Widget grid").
enum DashboardWidgetSize {
  small(1, 1),
  medium(2, 1),
  large(2, 2),
  extraLarge(4, 2);

  const DashboardWidgetSize(this.columns, this.rows);

  final int columns;
  final int rows;

  int get area => columns * rows;
}
