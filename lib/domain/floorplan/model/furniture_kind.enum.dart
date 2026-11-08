/// Pieces of furniture with their usual size in centimeters: [width] along the wall they stand against, [depth] away
/// from it, [height] above the floor.
enum FurnitureKind {
  bed('Bed', 160, 205, 55),
  singleBed('Single bed', 90, 205, 55),
  nightstand('Nightstand', 45, 40, 50),
  wardrobe('Wardrobe', 200, 60, 220),
  dresser('Dresser', 120, 50, 85),
  sofa('Sofa', 220, 95, 80),
  armchair('Armchair', 85, 85, 90),
  coffeeTable('Coffee table', 110, 60, 40),
  tvUnit('TV', 180, 40, 55),
  rug('Rug', 200, 140, 1),
  diningTable('Table', 160, 90, 75),
  chair('Chair', 45, 50, 90),
  desk('Desk', 140, 70, 75),
  officeChair('Desk chair', 60, 60, 110),
  shelf('Shelf', 80, 35, 200),
  counter('Counter', 60, 62, 90),
  fridge('Fridge', 60, 66, 190),
  toilet('Toilet', 40, 65, 80),
  washbasin('Washbasin', 60, 45, 85),
  shower('Shower', 90, 90, 200),
  bathtub('Bathtub', 170, 75, 55),
  washingMachine('Washer', 60, 60, 85),
  coatRack('Coat rack', 100, 35, 180),
  plant('Plant', 45, 45, 110),
  floorLamp('Floor lamp', 35, 35, 160);

  const FurnitureKind(this.label, this.width, this.depth, this.height);

  final String label;
  final double width;
  final double depth;
  final double height;

  /// Kinds whose width is stretched to fill a wall, e.g. a kitchen counter.
  bool get stretches => this == counter;

  /// Lies flat on the floor; other furniture may stand on it.
  bool get isFlat => this == rug;
}
