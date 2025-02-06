import 'package:flutter_web3/flutter_web3.dart';
import 'package:moon/logger/logger.dart';
import 'dart:js_interop';

@JS()
external JSPromise PurchaseLevel(int level);
@JS()
external JSPromise IsRegistered(String userAddress);
@JS()
external JSPromise getUserM50Data(String userAddress);
@JS()
external JSPromise Withdraw();
@JS()
external JSPromise getMoonContractEvents();

@JS()
external JSPromise getTotalEarned();
@JS()
external JSPromise getUserLevel(String addr);
@JS()
external JSPromise GetAvailableGlobalGain(String address);
@JS()
external JSPromise GetUserHistories();
@JS()
external JSPromise GetUserWithdraw();

class MoonContractManager {
  Future<bool> purchase(int level) async {
    try {
      final resultPromise = PurchaseLevel(level);

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
      if (resultDart.toString() == "false") {
        log('purchase failed');
        return false;
      } else {
        log('purchase successful');
        return true;
      }
    } catch (e) {
      log('Error registering: $e');
      return false;
    }
  }

  Future<bool> isRegistered(String userAddress) async {
    try {
      final resultPromise = IsRegistered(userAddress);
      final resultDart = await resultPromise.toDart;
      return resultDart.toString() == "true";
    } catch (e) {
      logError(e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>> getUserInfo(String userAddress) async {
    try {
      final resultPromise = getUserM50Data(userAddress);
      final resultDart = await resultPromise.toDart;
      final converted = dartify(resultDart);

      if (converted == "{}") {
        return {};
      } else {
        final converted = dartify(resultDart);

        final jsonRes = (converted);
        return jsonRes;
      }
    } catch (e) {
      logError(e.toString());
      return {};
    }
  }

  Future<String> withdraw(int id) async {
    try {
      final resultPromise = Withdraw();
      final resultDart = await resultPromise.toDart;
      if (resultDart != null) {
        return resultDart.toString();
      } else {
        return "";
      }
    } catch (e) {
      logError(e.toString());
      return "";
    }
  }

  Future<Map<String, dynamic>> getEvents() async {
    try {
      final resultPromise = getMoonContractEvents();
      final resultDart = await resultPromise.toDart;
      final converted = dartify(resultDart);

      final jsonRes = (converted);
      return jsonRes;
    } catch (e) {
      logError(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> getHistories() async {
    try {
      final resultPromise = GetUserHistories();
      final resultDart = await resultPromise.toDart;
      final converted = dartify(resultDart);

      final jsonRes = (converted);
      return jsonRes;
    } catch (e) {
      logError(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> getWithdrawals() async {
    try {
      final resultPromise = GetUserWithdraw();
      final resultDart = await resultPromise.toDart;
      final converted = dartify(resultDart);

      final jsonRes = (converted);
      return jsonRes;
    } catch (e) {
      logError(e.toString());
      return {};
    }
  }

  Future<int> getTotalEarnings() async {
    try {
      final resultPromise = getTotalEarned();
      final resultDart = await resultPromise.toDart;
      log("earned dart result ${resultDart.toString()}");
      return resultDart as int;
    } catch (e) {
      logError(e.toString());
      return 0;
    }
  }

  Future<int> getUserLevelInM50(String address) async {
    try {
      final resultPromise = getUserLevel(address);
      final resultDart = await resultPromise.toDart;
      log("Level result ${resultDart.toString()}");
      return int.parse(resultDart as String);
    } catch (e) {
      logError(e.toString());
      return 0;
    }
  }

  Future<int> checkAvailableAmount(String address) async {
    try {
      final resultPromise = GetAvailableGlobalGain(address);
      final resultDart = await resultPromise.toDart;
      log("Available gain result ${resultDart.toString()}");
      return int.parse(resultDart as String);
    } catch (e) {
      logError(e.toString());
      return 0;
    }
  }
}
