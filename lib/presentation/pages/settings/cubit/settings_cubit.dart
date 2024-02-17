import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:vibel/presentation/shared/cubit/safe_cubit.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

@inject
class SettingsCubit extends SafeCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState.initial());

  void init() {
    emit(
      const SettingsState.loaded(),
    );
  }
}
