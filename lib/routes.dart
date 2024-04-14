import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/screens/goal_details.dart';
import 'package:flutter_boilerplate/screens/home.dart';
import 'package:go_router/go_router.dart';

/*
This file contains all the routes used in the app. You can add more routes here and delete the /sample route.
*/

// The route configuration.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (context, state) => FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => SignInScreen(
        actions: [
          AuthStateChangeAction<SignedIn>((context, _) {
            GoRouter.of(context).pushReplacement("/home");
          }),
        ],
        showPasswordVisibilityToggle: true,
      ),
    ),
    GoRoute(
        path: '/profile',
        builder: (context, state) => ProfileScreen(
              appBar: AppBar(
                title: const Text('Profile'),
              ),
              actions: [
                SignedOutAction((context) {
                  GoRouter.of(context).go("/");
                }),
              ],
            )),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/goal/:id',
      builder: (context, state) => GoalDetailsScreen(id: state.pathParameters['id']!),
    ),
  ],
);
