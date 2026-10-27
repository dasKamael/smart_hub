import 'package:freezed_annotation/freezed_annotation.dart';

part 'species_match.freezed.dart';

/// A species found in the plant database, to link a plant with.
@freezed
abstract class SpeciesMatch with _$SpeciesMatch {
  const factory SpeciesMatch({
    required int id,
    required String commonName,
    String? scientificName,
    String? thumbnailUrl,

    /// Care data of this species is part of the free plan of the plant database.
    @Default(true) bool available,
  }) = _SpeciesMatch;
}
