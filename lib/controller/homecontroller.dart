import 'dart:math';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:imagegenrator/utilities/apiservices.dart';
import '../utilities/localstore.dart';

class homeController extends GetxController {
  var img = ''.obs;
  RxList cartList = [].obs;
  RxList historyList = [].obs;
  var totalPrice = 0.obs;

  Future getImgData({ctx}) async {
    var result = await STM().allApi(
        ctx: ctx, apitype: 'get', load: true, loadtitle: 'Loading img...');
    img.value = result['message'];

    /// when new image is fetched then directly added to history table
    final random = Random();
    addImgToHistory(img.value, random.nextInt(90) + 10);
    print(result);
    update();
  }

  /// add image and price to cart table
  Future<void> addImgToCart(img, price) async {
    await Store.addCart(img, price);
    /// for update cart list
    getDataCart();
    update();
  }

  /// fetch image and price from cart table
  getDataCart() async {
    var data = await Store.getItemsCart();
    cartList.value = data;
    print(cartList);
    update();
  }

  /// add image and price to history table
  Future<void> addImgToHistory(img, price) async {
    await Store.addHistory(img, price);
    update();
  }

  /// fetch image and price from history table
  getDataHistory() async {
    var data = await Store.getItemsHistory();
    historyList.value = data;
    print(historyList);
    update();
  }

  /// get total price from imgcart table
  getTotalPrice() async {
    totalPrice.value = (await Store.getTotalPrice()) as int;
    print(totalPrice);
  }

  /// delete imgcart table items
  deleteCart() async {
    return await Store.deleteimgCartTable();
  }

  /// delete imgHistory table items
  deleteHistory() async {
    return await Store.deleteimgHistoryTable();
  }
}
