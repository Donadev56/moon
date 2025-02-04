import 'dart:convert';

import 'package:flutter_web3/flutter_web3.dart';
import 'package:moon/logger/logger.dart';
import 'package:http/http.dart';
import 'package:webthree/webthree.dart';

class Web3Manager {
  Future<Web3Client> getProvider() async {
    final apiUrl = "https://opbnb-mainnet-rpc.bnbchain.org";
    final httpClient = Client();
    final client = Web3Client(apiUrl, httpClient);

    final chainId = await client.getChainId();
    final gasPrice = await client.getGasPrice();
    log("ChainID: $chainId");
    log("Gas Price: $gasPrice");

    return client;
  }

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

  Future<DeployedContract> connectToContract(
      String contractAddress, String abiJson, String name) async {
    final contractAbi = ContractAbi.fromJson(abiJson, name);
    final ethAddress = EthereumAddress.fromHex(contractAddress);
    return DeployedContract(contractAbi, ethAddress);
  }
}
