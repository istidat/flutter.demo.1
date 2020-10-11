import 'package:get/get.dart' hide Trans;
import 'package:videotor/api/index.dart';
import 'package:videotor/metadata/index.dart';
import 'package:videotor/entities/index.dart';
import 'package:videotor/services/index.dart';

class User extends GenericEntity<User> {
  var sortMode = false.obs;
  var loaded = (defaultEnvironment == Environment.prerelease).obs;

  var email = "".obs;
  var identity = "".obs;
  var initials = "".obs;
  var apiToken = "".obs;
  var password = "".obs;

  Rx<AppSettings> appSettings = AppSettings().obs;

  @override
  String toString() => initials.value;

  @override
  TableInfo<User> get tableInfo => TableInfo<User>(
        version: 1,
        tableName: "users",
        resource: "user",
        translation: "entity.user",
        fieldInfos: [
          FieldInfo(
            name: "email",
            repr: "E-Posta",
            prop: Prop(
              getter: (e) => e.email.value,
              setter: (e, val) => e.email.value = val,
            ),
          ),
          FieldInfo(
            name: "identity",
            repr: "Benzersiz Kimlik",
            prop: Prop(
              getter: (e) => e.identity.value,
              setter: (e, val) => e.identity.value = val,
            ),
          ),
          FieldInfo(
            name: "initials",
            repr: "Ad Soyad",
            prop: Prop(
              getter: (e) => e.initials.value,
              setter: (e, val) => e.initials.value = val,
            ),
          ),
          FieldInfo(
            name: "apiToken",
            repr: "Giriş Anahtarı",
            prop: Prop(
              getter: (e) => e.apiToken.value,
              setter: (e, val) => e.apiToken.value = val,
            ),
          ),
          FieldInfo(
            name: "password",
            repr: "Şifre",
            prop: Prop(
              getter: (e) => e.password.value,
              setter: (e, val) => e.password.value = val,
            ),
          ),
        ],
        one2OneReferences: [
          One2OneReferenceInfo(
            prop: Prop(
              getter: (e) => e.appSettings.value,
              setter: (e, val) => e.appSettings.value = val,
            ),
            referenceRepository: DataService.repositoryOf<AppSettings>(),
            foreignTable: DataService.tableNameOf<AppSettings>(),
            referencingColumn: "app_settings_id",
          ),
        ],
      );

  @override
  int get hashCode =>
      email.hashCode ^
      identity.hashCode ^
      apiToken.hashCode ^
      password.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          email == other.email &&
          identity == other.identity &&
          initials == other.initials &&
          apiToken == other.apiToken &&
          password == other.password &&
          appSettings == other.appSettings;
}
