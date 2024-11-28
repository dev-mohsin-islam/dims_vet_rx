

import 'package:flutter/cupertino.dart';

class RebuildController{
  final VoidCallback rebuildCallback;

  RebuildController(this.rebuildCallback);

  void triggerRebuild() {
    rebuildCallback();  // Call the passed rebuildWidget method
  }
}