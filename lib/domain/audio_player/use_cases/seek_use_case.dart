import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class SeekUseCase {
  const SeekUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  Future<void> call(Duration position, [int? index]) async =>
      await _audioPlayerRepository.seek(position, index);
}
