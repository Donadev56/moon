import 'package:flutter_web3/flutter_web3.dart';
import 'package:moon/logger/logger.dart';
import 'package:moon/utils/prefs.dart';

class Web3Manager {
  final prefs = PrefsManager();
  final name = "preview-mode-address";

  Future<bool> savePreviewAddress({required String address}) async {
    try {
      final res = await prefs.saveDataInPrefs(data: (address), key: name);
      return res;
    } catch (e) {
      logError(e.toString());
      return false;
    }
  }

  Future<bool> deleteLastPreviewAddress() async {
    try {
      final res = await prefs.removeDataFromPrefs(key: name);
      return res;
    } catch (e) {
      logError(e.toString());
      return false;
    }
  }

  Future<String> getEthereumAddress() async {
    try {
      if (ethereum != null) {
        final accounts = await ethereum?.requestAccount();
        if (accounts != null) {
          return accounts[0];
        } else {
          logError("No accounts found \n Please connect Metamask");
          return "";
        }
      } else {
        logError(" Ethereum not found \n Please install Metamask");
        return "";
      }
    } catch (e) {
      logError(e.toString());
      return "";
    }
  }

  Future<bool> isPreviewAddressAvailable() async {
    try {
      final res = await prefs.getDataFromPrefs(key: name);
      if (res != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logError(e.toString());
      return false;
    }
  }

  Future<String> getAddress() async {
    try {
      if (ethereum != null) {
        final savedAddress = await prefs.getDataFromPrefs(key: name);
        if (savedAddress != null) {
          return savedAddress;
        } else {
          return await getEthereumAddress();
        }
      } else {
        return "";
      }
    } catch (e) {
      logError(e.toString());
      return "";
    }
  }
}
