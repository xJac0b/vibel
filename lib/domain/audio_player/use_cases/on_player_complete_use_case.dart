import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class OnPlayerCompleteUseCase {
  const OnPlayerCompleteUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  Stream<void> call() => _audioPlayerRepository.onPlayerComplete;
}
