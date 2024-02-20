import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class SetShuffleModeEnabledUseCase {
  const SetShuffleModeEnabledUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  Future<void> call({required bool enabled}) async =>
      await _audioPlayerRepository.setShuffleModeEnabled(enabled: enabled);
}
