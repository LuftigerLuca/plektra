class MetronomeState {}

class MetronomeIdle extends MetronomeState {}

class MetronomeRunning extends MetronomeState {
  final int currentBeat;
  final bool isAccented;

  MetronomeRunning({required this.currentBeat, required this.isAccented});
}

class MetronomeError extends MetronomeState {
  final String message;
  MetronomeError(this.message);
}