// import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:redux/redux.dart';

// import 'routes/app_router.dart';
// import 'state/store.dart';
// import 'utils/theme.dart';
// import 'utils/localization.dart';

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StoreProvider(
//       store: AppStore.instance.store,
//       child: MaterialApp(
//         title: 'Оксана Шик',
//         theme: AppTheme.light,
//         darkTheme: AppTheme.dark,
//         localizationsDelegates: AppLocalizations.localizationsDelegates,
//         supportedLocales: AppLocalizations.supportedLocales,
//         locale: const Locale('ru'),
//         onGenerateRoute: AppRouter.generateRoute,
//         initialRoute: '/splash',
//       ),
//     );
//   }
// }
