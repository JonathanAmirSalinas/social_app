import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/router/app_router.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    // using SharedPreferences allows us check if user has been authenticated
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool authenticated = pref.getBool('authenticated') ?? false;
    // Check if user is still authenticated before allowing user to navigate
    if (authenticated) {
      // if user is authenticated, continue
      resolver.next(true);
    } else {
      // navigate user back to Login Page
      router.push(Login(onResult: (result) {
        if (result == true) {
          resolver.next(true);
          router.removeLast();
        }
      }));
    }
  }
}
