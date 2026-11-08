/// What a room is used for. Gives a new room its name, its floor in 3D and the furniture "furnish" suggests.
enum RoomType {
  living('Living room'),
  bedroom('Bedroom'),
  kitchen('Kitchen'),
  dining('Dining'),
  office('Office'),
  bathroom('Bathroom'),
  wc('WC'),
  hall('Hall'),
  storage('Storage'),
  kids('Kids'),
  balcony('Balcony'),
  other('Room');

  const RoomType(this.label);

  /// Default name of a room of this type.
  final String label;

  /// Guesses the type from a room name (English or German), e.g. of a plan drawn before rooms had types.
  static RoomType fromName(String name) {
    final lower = name.toLowerCase();
    bool has(List<String> words) => words.any(lower.contains);
    if (has(['wc', 'toilet', 'gäste'])) return wc;
    if (has(['bath', 'bad', 'dusch', 'shower'])) return bathroom;
    if (has(['kitchen', 'küche', 'kueche'])) return kitchen;
    if (has(['sleep', 'bed', 'schlaf'])) return bedroom;
    if (has(['kid', 'kinder', 'child'])) return kids;
    if (has(['office', 'büro', 'buero', 'work', 'arbeit', 'study'])) return office;
    if (has(['hall', 'flur', 'diele', 'corridor', 'entr', 'eingang'])) return hall;
    if (has(['storage', 'abstell', 'store', 'closet', 'kammer', 'pantry'])) return storage;
    if (has(['balcon', 'balkon', 'terrace', 'terrasse', 'loggia'])) return balcony;
    if (has(['dining', 'ess'])) return dining;
    if (has(['living', 'wohn', 'lounge'])) return living;
    return other;
  }
}
