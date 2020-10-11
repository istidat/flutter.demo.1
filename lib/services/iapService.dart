import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/services/index.dart';

class IAPService extends GetxService {
  static const bool kAutoConsume = true;
  static const Set<String> _skus = {
    bir_yil_premium,
  };

  StreamSubscription<List<PurchaseDetails>> _subscription;
  Function(PurchaseDetails) _historiesHandler;
  Function(IAPError error) _iapErrorHandler;
  Function() _purchasedHandler;

  InAppPurchaseConnection _connection;
  InAppPurchaseConnection get connection => _connection;

  Future<IAPService> init() async {
    await initService();
    return this;
  }

  void dispose() {
    _subscription.cancel();
  }

  Future<bool> initService() async {
    InAppPurchaseConnection.enablePendingPurchases();
    _connection = InAppPurchaseConnection.instance;
    final isAvailable = await _connection.isAvailable();
    return isAvailable;
  }

  Future<void> initConnection({
    @required Function(IAPError error) onError,
    Function() onPurchase,
    Function(PurchaseDetails) onHistory,
  }) async {
    _purchasedHandler = onPurchase;
    _iapErrorHandler = onError;
    final purchaseUpdates = _connection.purchaseUpdatedStream;
    _subscription =
        purchaseUpdates.listen(_listenToPurchaseUpdated, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      print("purchase update error: $error");
    });
    _historiesHandler = onHistory;
  }

  Future<void> restorePurchases() async {
    final QueryPurchaseDetailsResponse purchaseResponse =
        await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      print("purchase history error: ${purchaseResponse.error}");
    }
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (_historiesHandler != null) _historiesHandler(purchase);
      if (purchase.productID == bir_yil_premium) {
        await Get.find<PremiumService>().setPurchased(true);
      }
      await _connection.completePurchase(purchase);
    }
  }

  void _handleError(IAPError error) {
    print("iapError: ${error.message}");
    print("iapError: ${error.details}");
    print("iapError: ${error.source}");
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchase) async {
      if (purchase.status == PurchaseStatus.pending) {
        //showPendingUI();
      } else {
        if (purchase.status == PurchaseStatus.error) {
          _handleError(purchase.error);
          if (_iapErrorHandler != null) {
            _iapErrorHandler(purchase.error);
          }
        } else if (purchase.status == PurchaseStatus.purchased) {
          if (_purchasedHandler != null) {
            _purchasedHandler();
          }
          bool valid = await _verifyPurchase(purchase);
          if (valid) {
            //save details.purchaseID to db
          } else {
            //_handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!kAutoConsume) {
            await _connection.consumePurchase(purchase);
          }
        }
        if (purchase.pendingCompletePurchase) {
          await _connection.completePurchase(purchase);
        }
      }
    });
  }

  Future<void> purchase(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    if (_isConsumable(productDetails)) {
      await _connection.buyConsumable(purchaseParam: purchaseParam);
    } else {
      await _connection.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Future<List<ProductDetails>> getSubscriptions() async {
    // Set literals require Dart 2.2. Alternatively, use `Set<String> _kIds = <String>['product1', 'product2'].toSet()`.
    final response = await _connection.queryProductDetails(_skus);
    if (response.notFoundIDs.isNotEmpty) {
      print("notFoundIDs");
      print(response.notFoundIDs);
    }
    if (response.error != null) {
      print("getSubscriptions error: ${response.error.message}");
    }
    List<ProductDetails> products = response.productDetails;
    return products;
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    if (purchase != null &&
        (purchase.status == PurchaseStatus.purchased ||
            purchase.transactionDate != null) &&
        _skus.contains(purchase.productID)) {
      if (purchase.productID == bir_yil_premium) {
        await Get.find<PremiumService>().setPurchased(true);
        return true;
      } else if (purchase.productID == 'bir_gun_ucretsiz') {
        await Get.find<PremiumService>().setRewarded();
        return true;
      }
    }
    return false;
  }

  bool _isConsumable(ProductDetails productDetails) {
    return productDetails.id.startsWith("consumable_");
  }
}
