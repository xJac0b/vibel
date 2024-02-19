import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class OnDurationChangedUseCase {
  const OnDurationChangedUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  Stream<Duration> call() => _audioPlayerRepository.onDurationChanged;
}
