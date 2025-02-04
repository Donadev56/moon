import 'dart:convert';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:moon/logger/logger.dart';
import 'dart:js_interop';

@JS()
external JSPromise RegisterUser(String sponsorId, String username);

class RegistrationManager {
  Future<bool> register(String sponsor, String name) async {
    try {
      final resultPromise = RegisterUser(sponsor, name);

      final network = await ethereum!.getChainId();
      if (network != 204) {
        log("Changing the network");
        await ethereum!.walletAddChain(
            chainId: 204,
            chainName: "opBNB",
            nativeCurrency: CurrencyParams(
              name: "BNB",
              symbol: "BNB",
              decimals: 18,
            ),
            rpcUrls: ["https://opbnb-mainnet-rpc.bnbchain.org"]);
        await ethereum!.walletSwitchChain(204);
        log("changed network");
      }

      final resultDart = await resultPromise.toDart;
      log("Result dart ${resultDart.toString()}");
      if (resultDart.toString() == "false") {
        log('Registration failed');
        return false;
      } else {
        log('Registration successful');
        return true;
      }
    } catch (e) {
      log('Error registering: $e');
      return false;
    }
  }
}
