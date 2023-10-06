// ignore_for_file: file_names, non_constant_identifier_names

import 'package:crm_client/util/LicenseKey.dart';

class ApiClass {
  //static String BaseURL = "crmapi.lbmsolutions.in"; // Base Url
  static String BaseURL = Base_Url_For_App;
  static String api_key = Api_Key_by_Admin;
  static String IMAGEBASEURL =
      "https://ppscs.io/crm/uploads/staff_profile_images/";
  //static String api_key="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoidGVzdCIsIm5hbWUiOiJ0ZXN0IiwicGFzc3dvcmQiOm51bGwsIkFQSV9USU1FIjoxNTk1NzM0NDM2fQ.rw5jGmbadmM5uS2pwH9VhsQN8cSvBFJoZuaEZliG9lQ";
  static String LOGIN_URL =
      "/crm/clientapi/Auth_user"; //Post api-key,username,password
  static String GET_CATEGORY_DATA = "/crm/clientapi/Category_list";
  static String GET_PROFILE = "/crm/clientapi/Clientprofile";
  static String GET_SUPPORT = "/crm/clientapi/Support";
  static String ADD_TICKET = "/crm/clientapi/Tickets";
  static String TICKET_REPLY = "/crm/clientapi/Tickets/ticketreply";
  static String GET_INVOICE_ITEMS = "/crm/clientapi/Invoiceitem";
  static String GET_PROJECT_DETAIL = "/crm/clientapi/Projectdetail";
  static String UPLOAD_PROJECT_FILES = "/crm/clientapi/Uploadprojectfile";
  static String StaffClientList = "/crm/api/prchat/StaffclientList";
  static String OldChatList = "/crm/api/prchat/oldmessage";
  static String SEND_MESSAGE = "/crm/api/prchat/sendClienttoServerChat";
  static String UPDATE_READMESSAGE = "/crm/api/prchat/updateUnreadClient";
}
