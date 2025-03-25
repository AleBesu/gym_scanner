import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedElementIndexListProvider = StateProvider.autoDispose<List<int>>(
  (ref) {
    return [];
  },
);

final isSelectingModeProvider = StateProvider.autoDispose(
  (ref) {
    if (ref.watch(selectedElementIndexListProvider).isEmpty) {
      return false;
    } else {
      return true;
    }
  },
);

class SelectableWidget extends ConsumerWidget {
  final Widget child;
  final int index;
  const SelectableWidget({
    this.index = 0,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isSelected =
        ref.watch(selectedElementIndexListProvider).contains(index);
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
      child: Stack(
        children: [
          child,
          if (isSelected)
            Positioned.fill(
              child: Container(
                color: Colors.red.withOpacity(0.7),
              ),
            ),
          Positioned.fill(
              child: InkWell(
            onTap: isSelected && ref.watch(isSelectingModeProvider)
                ? () {
                    ref.read(selectedElementIndexListProvider.notifier).update(
                      (state) {
                        final List<int> newList = List.from(state);
                        newList.remove(index);
                        return newList;
                      },
                    );
                  }
                : ref.watch(isSelectingModeProvider) && !isSelected
                    ? () {
                        ref
                            .read(selectedElementIndexListProvider.notifier)
                            .update(
                          (state) {
                            return {...state, index}.toList();
                          },
                        );
                      }
                    : null,
            onLongPress: () {
              ref.read(selectedElementIndexListProvider.notifier).update(
                (state) {
                  return {...state, index}.toList();
                },
              );
            },
          )),
        ],
      ),
    );
  }
}
