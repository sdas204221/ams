import 'package:flutter/material.dart';
import 'package:lms/app.dart';
import 'package:lms/core/utils/api_client.dart';
import 'package:lms/data/repositories/api/auth_repository.dart';
import 'package:lms/data/repositories/api/listing_repository.dart';
import 'package:lms/data/repositories/api/user_repository.dart';
import 'package:lms/data/repositories/db/shared_prefs_storage.dart';
import 'package:lms/data/repositories/db/storage.dart';
import 'package:lms/providers/auth_provider.dart';
import 'package:lms/providers/listing_provider.dart';
import 'package:lms/providers/user_provider.dart';
import 'package:lms/services/auth_service.dart';
import 'package:lms/services/listing_service.dart';
import 'package:lms/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Storage storage = SharedPrefsStorage(sharedPreferences);

  ApiClient apiClient = ApiClient();
  AuthRepository authRepository = AuthRepository(apiClient: apiClient);
  ListingRepository listingRepository = ListingRepository(apiClient: apiClient);
  UserRepository userRepository=UserRepository(apiClient: apiClient);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: AuthService(authRepository, storage)),
        ),
        ChangeNotifierProvider(
          create: (_) => ListingProvider(listingService: ListingService(listingRepo: listingRepository,storage: storage)),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(userService: UserService(userRepo: userRepository,storage: storage)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
