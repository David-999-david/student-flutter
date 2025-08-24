import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/presentation/auth/handle_state.dart';
import 'package:student/presentation/auth/login_screen.dart';
import 'package:student/presentation/bottom_nav/bottom_nav.dart';

class HandleStart extends ConsumerStatefulWidget {
  const HandleStart({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HandleStartState();
}

class _HandleStartState extends ConsumerState<HandleStart> {
  @override
  Widget build(BuildContext context) {
    final checkState = ref.watch(handleProvider);
    ref.listen(handleProvider, (p, n) {
      n.when(
        data: (ok) {
          if (ok) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return BottomNav();
                },
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginScreen();
                },
              ),
            );
          }
        },
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
        loading: () {},
      );
    });
    return Scaffold(
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/s1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            checkState.isLoading
                ? Positioned(
                    left: 178,
                    bottom: 50,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.yellow),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
