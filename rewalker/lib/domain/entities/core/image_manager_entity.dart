// Gerencia carregamento e centralização de imagens de forma genérica.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:midnight_never_end/core/service/app_service.dart';
import 'package:midnight_never_end/domain/error/core/intro_exception.dart';

class ImageManager {
  final IAppService _appService;

  ImageManager(this._appService);

  Future<void> loadImages(
    Map<String, String> imagePaths,
    void Function(Map<String, Size?>, Map<String, Matrix4>) onUpdate,
  ) async {
    try {
      final sizes = <String, Size?>{};
      final matrices = <String, Matrix4>{};
      for (final entry in imagePaths.entries) {
        final size = await _loadImageSize(entry.value);
        sizes[entry.key] = size;
        matrices[entry.key] = _centerImage(size);
      }
      onUpdate(sizes, matrices);
    } catch (e) {
      throw ImageLoadFailure('Erro ao carregar imagens: $e');
    }
  }

  Future<Size> _loadImageSize(String path) async {
    final imageProvider = AssetImage(path);
    final imageStream = imageProvider.resolve(ImageConfiguration());
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

  Matrix4 _centerImage(Size? imageSize) {
    if (imageSize == null || _appService.context == null)
      return Matrix4.identity();
    final screenSize = _appService.context!.size!;
    final offsetX = (screenSize.width - imageSize.width) / 2;
    final offsetY = (screenSize.height - imageSize.height) / 2;
    return Matrix4.identity()..translate(offsetX, offsetY);
  }
}
