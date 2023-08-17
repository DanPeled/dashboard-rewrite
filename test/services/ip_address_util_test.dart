import 'package:elastic_dashboard/services/ip_address_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ip address util', () {
    expect(IPAddressUtil.isTeamNumber('353'), true);
    expect(IPAddressUtil.isTeamNumber('10.03.53.2'), false);

    expect(IPAddressUtil.teamNumberToIP(353), '10.3.53.2');
    expect(IPAddressUtil.teamNumberToIP(47), '10.0.47.2');
    expect(IPAddressUtil.teamNumberToIP(3015), '10.30.15.2');
    expect(IPAddressUtil.teamNumberToIP(12053), '10.120.53.2');
  });
}