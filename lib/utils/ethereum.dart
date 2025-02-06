import 'package:flutter_web3/flutter_web3.dart';
import 'package:moon/logger/logger.dart';

class Web3Manager {
  Future<String> getAddress() async {
    try {
      if (ethereum != null) {
        final addresses = await ethereum!.requestAccount();

        log("address  : $addresses");
        return addresses[0];
      } else {
        return "";
      }
    } catch (e) {
      logError(e.toString());
      return "";
    }
  }
}
