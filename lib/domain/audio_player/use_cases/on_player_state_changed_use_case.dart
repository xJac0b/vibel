import 'package:injecteo/injecteo.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class OnPlayerStateChangedUseCase {
  const OnPlayerStateChangedUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  Stream<PlayerState> call() => _audioPlayerRepository.onPlayerStateChanged;
}
