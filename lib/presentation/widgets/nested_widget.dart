// import 'package:flutter/material.dart';
//
// const routeHome = '/';
// const advertsList = '/adverts';
// const advertInfo = '/adverts/info';
//
//
// class SetupFlow extends StatefulWidget {
//   const SetupFlow({
//     super.key,
//     required this.setupPageRoute,
//   });
//
//   final String setupPageRoute;
//
//   @override
//   SetupFlowState createState() => SetupFlowState();
// }
//
// class SetupFlowState extends State<SetupFlow> {
//   final _navigatorKey = GlobalKey<NavigatorState>();
//
//   void _onAdvertsList() {
//     _navigatorKey.currentState!.pushNamed(advertsList);
//   }
//
//   void _onAdvertInfo(int advertId) {
//     _navigatorKey.currentState!.pushNamed(advertInfo);
//   }
//
//
//   Future<void> _onExitPressed() async {
//     final isConfirmed = await _isExitDesired();
//
//     if (isConfirmed && mounted) {
//       _exitSetup();
//     }
//   }
//
//   Future<bool> _isExitDesired() async {
//     return await showDialog<bool>(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('Are you sure?'),
//             content: const Text(
//                 'If you exit device setup, your progress will be lost.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                 },
//                 child: const Text('Leave'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(false);
//                 },
//                 child: const Text('Stay'),
//               ),
//             ],
//           );
//         }) ??
//         false;
//   }
//
//   void _exitSetup() {
//     Navigator.of(context).pop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _isExitDesired,
//       child: Scaffold(
//         appBar: _buildFlowAppBar(),
//         body: Navigator(
//           key: _navigatorKey,
//           initialRoute: widget.setupPageRoute,
//           onGenerateRoute: _onGenerateRoute,
//         ),
//       ),
//     );
//   }
//
//   Route _onGenerateRoute(RouteSettings settings) {
//     late Widget page;
//     switch (settings.name) {
//       case advertsList:
//
//       case advertInfo:
//     }
//
//     return MaterialPageRoute<dynamic>(
//       builder: (context) {
//         return page;
//       },
//       settings: settings,
//     );
//   }
//
//   PreferredSizeWidget _buildFlowAppBar() {
//     return AppBar(
//       leading: IconButton(
//         onPressed: _onExitPressed,
//         icon: const Icon(Icons.chevron_left),
//       ),
//       title: const Text('Bulb Setup'),
//     );
//   }
// }