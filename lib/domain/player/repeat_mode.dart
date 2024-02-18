enum RepeatMode {
  noRepeat,
  repeatAll,
  repeatOne;

  RepeatMode next() => this == RepeatMode.repeatOne
      ? RepeatMode.noRepeat
      : RepeatMode.values[RepeatMode.values.indexOf(this) + 1];
}
