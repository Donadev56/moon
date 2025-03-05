import 'package:flutter_web3/flutter_web3.dart';
import 'package:moon/logger/logger.dart';
import 'dart:js_interop';

@JS()
external JSPromise RegisterUser(String sponsorId, String username);
@JS()
external JSPromise IsRegistered(String userAddress);
@JS()
external JSPromise getUserData(String userAddress);
@JS()
external JSPromise AddressById(int id);
@JS()
external JSPromise getContractEvents();
@JS()
external JSPromise getUserTeamData(String userAddress);
@JS()
external JSPromise NumberOfUsers();

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
      final resultPromise = getUserData(userAddress);
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

  Future<String> getSponsorAddress(int id) async {
    try {
      final resultPromise = AddressById(id);
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

  Future<String> getAddressById(int id) async {
    try {
      final resultPromise = AddressById(id);
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
      final resultPromise = getContractEvents();
      final resultDart = await resultPromise.toDart;
      final converted = dartify(resultDart);

      final jsonRes = (converted);
      return jsonRes;
    } catch (e) {
      logError(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> getUserTeam(String userAddress) async {
    try {
      final resultPromise = getUserTeamData(userAddress);
      final resultDart = await resultPromise.toDart;
      final converted = dartify(resultDart);

      final jsonRes = (converted);
      return jsonRes;
    } catch (e) {
      logError(e.toString());
      return {};
    }
  }

  Future<int> getNumberOfUsers() async {
    try {
      final resultPromise = NumberOfUsers();
      final resultDart = await resultPromise.toDart;
      return resultDart as int;
    } catch (e) {
      logError(e.toString());
      return 0;
    }
  }
}
