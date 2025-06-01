import 'package:lms/data/repositories/db/mock_storage.dart';
import 'package:lms/data/repositories/db/storage.dart';

import 'repositories/auth_repository_test.dart' as auth_test;
import 'repositories/listing_repository_test.dart' as listing_test;
import 'repositories/user_repository_test.dart' as user_test;
import 'service/auth_service_test.dart' as auth_service_test;
import 'service/listing_service_test.dart' as listing_service_test;
import 'service/user_service_test.dart' as user_service_test;

void main() async{
  auth_test.main();
  user_test.main();
  listing_test.main();
  Storage storage=MockStorage();
  await auth_service_test.runAuthServiceTests(storage);
  await listing_service_test.runListingServiceTests(storage);
  await user_service_test.runUserServiceTests(storage);

}