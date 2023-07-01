import 'package:drivedoctor/bloc/models/product.dart';

class CartItem {
  ProductData product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class CartController {
  List<CartItem> cartItems = [];
  List<String> tempCart = [];

  void setCartItems(List<String> items) {
    tempCart = items;
  }

  void addToCart(ProductData product) {
    bool existsInCart = false;

    // Check if the product already exists in the cart
    for (var cartItem in cartItems) {
      if (cartItem.product.productId == product.productId) {
        // Product already in the cart, increment the quantity
        cartItem.quantity++;
        existsInCart = true;
        break; // Exit the loop once the product is found
      }
    }

    // Product not found in the cart, add it as a new item
    if (!existsInCart) {
      cartItems.add(CartItem(product: product, quantity: 1));
    }
  }

  void removeFromCart(ProductData product) {
    for (var cartItem in cartItems) {
      if (cartItem.product.productId == product.productId) {
        if (cartItem.quantity > 1) {
          // Decrease the quantity if it's greater than 1
          cartItem.quantity--;
        } else {
          // Remove the item completely if the quantity is 1
          cartItems.remove(cartItem);
        }
        return;
      }
    }
  }

  void removeFromCartCompletely(ProductData product) {
    cartItems.removeWhere(
        (cartItem) => cartItem.product.productId == product.productId);
  }

  void clearCart() {
    cartItems.clear();
  }

  int getQuantity(ProductData product) {
    for (var cartItem in cartItems) {
      if (cartItem.product.productId == product.productId) {
        return cartItem.quantity;
      }
    }
    return 0;
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var cartItem in cartItems) {
      totalPrice += cartItem.product.price * cartItem.quantity;
    }
    return totalPrice;
  }
}
