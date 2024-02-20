import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class OnCurrentIndexChangedUseCase {
  const OnCurrentIndexChangedUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  Stream<int?> call() => _audioPlayerRepository.currentIndexStream;
}
