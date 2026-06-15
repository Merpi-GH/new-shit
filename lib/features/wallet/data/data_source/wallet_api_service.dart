import 'package:asood/core/constants/endpoints.dart';
import 'package:asood/core/http_client/api_client.dart';
import 'package:asood/core/http_client/api_status.dart';
import 'package:dio/dio.dart';

class WalletApiService {
  final DioClient dioClient;
  
  WalletApiService({required this.dioClient});
  
  Future getBalance() async {
    try {
      final res = await dioClient.getData(Endpoints.walletBalance);
      return apiStatus(res);
    } catch (e) {
      return customApiStatus();
    }
  }
  
  Future checkBalance(double amount) async {
    try {
      final res = await dioClient.postData(Endpoints.walletBalanceCheck, {
        'amount': amount,
      });
      return apiStatus(res);
    } catch (e) {
      return customApiStatus();
    }
  }
  
  Future getTransactions() async {
    try {
      final res = await dioClient.getData(Endpoints.walletTransactions);
      return apiStatus(res);
    } catch (e) {
      return customApiStatus();
    }
  }
  
  Future payWithWallet(Map<String, dynamic> data) async {
    try {
      final res = await dioClient.postData(Endpoints.walletPay, data);
      return apiStatus(res);
    } catch (e) {
      return customApiStatus();
    }
  }
}
