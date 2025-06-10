import 'package:flutter/material.dart';

abstract interface class IFactoryViewModel<T> {
  T create(BuildContext context);
  void dispose(BuildContext context, T viewModel);
}
