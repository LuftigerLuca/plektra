import 'package:get_it/get_it.dart';
import 'package:plektra/features/metronome/data/datasources/click_sound_datasource.dart';
import 'package:plektra/features/metronome/presentation/bloc/metronome_bloc.dart';
import 'package:plektra/features/metronome/data/repositories/metronome_repository_impl.dart';
import 'package:plektra/features/metronome/domain/repositories/metronome_repository.dart';
import 'package:plektra/features/metronome/domain/usecases/start_metronome_usecase.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Data sources
  getIt.registerLazySingleton<ClickSoundDataSource>(
    () => ClickSoundDataSource(),
  );

  // Repositories
  getIt.registerLazySingleton<MetronomeRepository>(
    () => MetronomeRepositoryImpl(getIt<ClickSoundDataSource>()),
  );

  // Use cases
  getIt.registerFactory<StartMetronomeUsecase>(
    () => StartMetronomeUsecase(getIt<MetronomeRepository>()),
  );

  // Bloc
  getIt.registerFactory<MetronomeBloc>(
    () => MetronomeBloc(getIt<StartMetronomeUsecase>()),
  );
}