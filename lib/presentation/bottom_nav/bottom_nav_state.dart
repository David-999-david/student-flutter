import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomState extends StateNotifier<int> {
  BottomState(this.ref, this.index) : super(index);

  final Ref ref;
  final int index;

  void onget(int index) => state = index;
}

final bottomProvider = StateNotifierProvider.family<BottomState, int, int>(
  (ref, index) => BottomState(ref, index),
);
