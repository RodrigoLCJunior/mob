import 'package:midnight_never_end/config/environment_helper.dart';
import 'package:midnight_never_end/configs/injection_container.dart';
import 'package:midnight_never_end/core/service/clock_helper.dart';
import 'package:midnight_never_end/core/service/http_service.dart';
import 'package:midnight_never_end/core/service/storage_service.dart';
import 'package:midnight_never_end/data/datasources/core/data_source.dart';
import 'package:midnight_never_end/data/datasources/core/non_relational_datasource.dart';
import 'package:midnight_never_end/data/datasources/core/relational_datasource.dart';
import 'package:midnight_never_end/data/datasources/core/remote_datasource.dart';

final class NonRelationalFactoryDataSource {
  INonRelationalDataSource create() {
    final IStorageService storageService = getIt<IStorageService>();
    final IClockHelper clockHelper = ClockHelper();

    return NonRelationalDataSource(storageService, clockHelper);
  }
}

final class RelationalFactoryDataSource {
  IRelationalDataSource create() {
    final IStorageService storageService = getIt<IStorageService>();
    final IClockHelper clockHelper = ClockHelper();

    return RelationalDataSource(storageService, clockHelper);
  }
}

final class RemoteFactoryDataSource {
  IRemoteDataSource create() {
    final IHttpService httpService = HttpServiceFactory().create();
    final IEnvironmentHelper environmentHelper = getIt<IEnvironmentHelper>();
    final IClockHelper clockHelper = ClockHelper();
    return RemoteDataSource(httpService, environmentHelper, clockHelper);
  }
}
