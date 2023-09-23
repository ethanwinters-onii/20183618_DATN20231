// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class NetworkContants {
  static const String DEV_BASE_URL = 'https://testkhtv02.pvoil.vn:8443';
  static const String PROD_BASE_URL = 'https://oil.digitalbiz.com.vn';

  static const String FIREBASE_CLOUD_MESSAGING_URL =
      "https://fcm.googleapis.com/fcm/send";
  static const String FIREBASE_SERVER_KEY =
      "AAAAWDT-YbQ:APA91bESQYdS9MO-nd91mfkxOVk3fnjOpSCt3KmfBB0qWnqYSZ6OR3exWg5hYRiRvBwqPlV6vmEKE3zH8obfWqYAgMiJ6oUORH26Nw7x9JZqeGA7OGFrCltMgUOs99F70IKnvcb6dNtI";

  static const Map<String, dynamic> APIS_HEADER = {
    'user-agent': 'DBiz Stop Application Android/9.0 IOS/9.0',
    'Host': 'oil.digitalbiz.com.vn'
  };

  static const String CONTENT_TYPE = 'application/xml';

  static const int CONNECT_TIMEOUT = 40000;
  static const int RECEIVE_TIMEOUT = 20000;
}

class ADLoginRequest {
  static const String USER = 'WebService';
  static const String PASS = 'WebService';
  static const String LANG = 'en_US';
  static const String CLIENT_ID = '1000000';
  static const String ROLE_ID = '1000040';
  static const String ORG_ID = '0';
  static const String WARE_HOUSE_ID = '0';
  static const String STAGE = '0';
}
