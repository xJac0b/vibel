import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class OnShuffleModeChangedUseCase {
  const OnShuffleModeChangedUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  Stream<bool> call() => _audioPlayerRepository.shuffleModeEnabledStream;
}
