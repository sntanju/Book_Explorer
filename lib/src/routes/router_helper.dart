import 'package:fluro/fluro.dart';
import 'package:book_explorer/src/features/errors/presentation/screens/screen_error.dart';
import 'package:book_explorer/src/features/home/presentation/screens/screen_home.dart';
import 'package:book_explorer/src/routes/routes.dart';


class RouterHelper {
  static final FluroRouter router = FluroRouter();

  ///Handlers
  static final Handler _homeScreenHandler =
  Handler(handlerFunc: (context, Map<String, dynamic> parameters) {
    return const ScreenHome();
  });

  static final Handler _notFoundHandler =
  Handler(handlerFunc: (context, parameters) => const ScreenError());

  void setupRouter() {
    router.notFoundHandler = _notFoundHandler;

    //main-nav flow
    router.define(Routes.homeScreen, handler: _homeScreenHandler, transitionType: TransitionType.inFromBottom);
  }

}