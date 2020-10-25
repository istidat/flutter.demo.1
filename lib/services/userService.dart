import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Trans;
import 'package:videotor/api/index.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/services/index.dart';

class UserService extends GetxService {
  Future<UserService> init() async {
    var uRepo = DataService.repositoryOf<User>();
    final c = await DataService.repositoryOf<User>().count();
    if (c == 0) {
      final user = await uRepo.insert((await Api.login()).user);
      Get.put(user, permanent: true);
    } else {
      final dbUser = await uRepo.first();
      Get.put(dbUser, permanent: true);
    }
    return this;
  }

  Future<bool> resetUser() async {
    var uRepo = DataService.repositoryOf<User>();
    await uRepo.deleteAll();
    final u = (await uRepo.insert((await Api.login()).user));
    var user = Get.find<User>();
    user.copy(from: u, includeOne2OneRefs: !kReleaseMode);
    return true;
  }
}
