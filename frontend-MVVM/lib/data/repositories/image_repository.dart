/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Repositorio de Metodos de Imagem
 ** Obs...:
 */

import 'dart:async';
import 'package:flutter/material.dart';

class ImageRepository {
  Future<Size> loadImageSize(String path) async {
    final imageProvider = AssetImage(path);
    final imageStream = imageProvider.resolve(const ImageConfiguration());
    final completer = Completer<Size>();
    ImageStreamListener? listener;
    listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        completer.complete(
          Size(info.image.width.toDouble(), info.image.height.toDouble()),
        );
        imageStream.removeListener(listener!);
      },
      onError: (exception, stackTrace) {
        completer.completeError(exception, stackTrace);
      },
    );
    imageStream.addListener(listener);
    return completer.future;
  }
}
