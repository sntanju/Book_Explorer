import 'package:book_explorer/src/core/application/token_service.dart';
import 'package:book_explorer/src/core/domain/interfaces/interface_cache_repository.dart';
import 'package:book_explorer/src/features/book/presentation/providers/provider_book.dart';
import 'package:book_explorer/src/features/home/presentation/providers/provider_common.dart';
import 'package:flutter/material.dart';
import 'di_container.dart' as di;
import 'package:provider/provider.dart';

import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();  //initializing Dependency Injection

  //update auth-token from cache [to check user logged-in or not]
  var token = di.sl<ICacheRepository>().fetchToken();
  di.sl<TokenService>().updateToken(token??"");  //update token will re-initialize wherever token was used

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.sl<ProviderCommon>()),
        ChangeNotifierProvider(create: (context) => di.sl<ProviderBook>()),
      ],
      child: const MyApp(),
    ),
  );
}