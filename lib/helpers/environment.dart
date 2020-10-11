//import 'package:flutter/foundation.dart';

enum Environment {
  localhost,
  prerelease,
  production,
}

const Environment defaultEnvironment =
    // kReleaseMode ? Environment.production : Environment.development;
    Environment.prerelease;
