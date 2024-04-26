import 'package:CLOSSET/models/wishlist.dart';
import 'package:flutter/material.dart';

class WishlistsProvider with ChangeNotifier {
  final List<Wishlist> _wishlists = [];

  List<Wishlist> get wishlists {
    return [..._wishlists];
  }

  void addWishlist(Wishlist wishlist) {
    _wishlists.add(wishlist);
    notifyListeners();
  }

  Future<void> setWishlists(List<Wishlist> wishlists) async {
    _wishlists.clear();
    _wishlists.addAll(wishlists);
    notifyListeners();
  }

  Future<void> updateWishlist(Wishlist wishlist) async {
    final index = _wishlists.indexWhere((element) => element.id == wishlist.id);
    if (index >= 0) {
      final w = await Wishlist.updateWishlist(wishlist);
      _wishlists[index] = w;
      notifyListeners();
    }
  }

  Future<void> addPost(int postId, int wishlistId) async {
    final index = _wishlists.indexWhere((element) => element.id == wishlistId);
    if (index >= 0) {
      _wishlists[index]
          .wishlistItems
          .add(WishlistItem(id: 0, wishlistId: 0, postId: postId));

      Wishlist w = await Wishlist.updateWishlist(_wishlists[index]);
      _wishlists[index] = w;
      notifyListeners();
    }
  }

  Future<void> removePost(int postId) async {
    for (var w in _wishlists) {
      for (var wi in w.wishlistItems) {
        if (wi.postId == postId) {
          w.wishlistItems.remove(wi);
          Wishlist wishlist = await Wishlist.updateWishlist(w);
          final index = _wishlists.indexWhere((element) => element.id == w.id);
          _wishlists[index] = wishlist;
          notifyListeners();
          return;
        }
      }
    }
  }

  bool isPostInWishlists(int postId) {
    for (var w in _wishlists) {
      for (var wi in w.wishlistItems) {
        if (wi.postId == postId) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> addNewWishlist(String name, int userId) async {
    Wishlist w = await Wishlist.createWishlist(
        Wishlist(id: 0, userId: userId, name: name, wishlistItems: []));
    _wishlists.add(w);
    notifyListeners();
  }

  void removeWishlist(Wishlist wishlist) {
    _wishlists.remove(wishlist);
    notifyListeners();
  }
}
