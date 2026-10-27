import 'package:smart_hub/domain/music/model/speaker_state.dart';

/// Speakers playing together; a single speaker is a group of one.
final class SpeakerGroup {
  const SpeakerGroup({required this.leader, required this.members});

  final SpeakerState leader;

  /// All speakers of the group, leader first.
  final List<SpeakerState> members;

  String get leaderId => leader.id;

  String get name => members.map((member) => member.name).join(' + ');

  bool contains(String speakerId) => members.any((member) => member.id == speakerId);

  /// More than one speaker.
  bool get isGroup => members.length > 1;
}
