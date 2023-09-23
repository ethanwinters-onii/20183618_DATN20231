// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:kitty_community_app/app/core/network/network_constants.dart';

class Endpoints {
  static const String BASE_URL = NetworkContants.DEV_BASE_URL;
  static const String CREATE_DATA =
      '$BASE_URL/ADInterface/services/rest/model_adservice/create_data';
  static const String UPDATE_DATA =
      '$BASE_URL/ADInterface/services/rest/model_adservice/update_data';
  static const String CREATE_UPDATE_DATA =
      '$BASE_URL/ADInterface/services/rest/model_adservice/create_update_data';
  static const String QUERY_DATA =
      '$BASE_URL/ADInterface/services/rest/model_adservice/query_data';
  static const String DELETE_DATA =
      '$BASE_URL/ADInterface/services/rest/model_adservice/delete_data';

  static const String INVOICE_INFO =
      "$BASE_URL/rest/pvoileasy/getInvoiceInfoByMST";
  static const String ISSUE_INVOICE = "$BASE_URL/rest/pvoileasy/issueInvoice";
}
