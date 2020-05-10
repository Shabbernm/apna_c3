import './auth.dart';

String conf_token = '';
String basic_URL = 'https://www.shabber.tech/';
var headers = {
  "Content-Type": "application/json",
  'Authorization': 'Token ${conf_token}'
};

double conf_latitude = 0;
double conf_longitude = 0;

bool onceDataIsFetched = false;
