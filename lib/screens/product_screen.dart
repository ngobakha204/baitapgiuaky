import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/auth_service.dart';
import 'product_form_screen.dart';
import 'login_screen.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductService _productService = ProductService();
  final AuthService _authService = AuthService();
  String _searchQuery = ""; // Biến để lưu từ khóa tìm kiếm

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: PreferredSize(
  preferredSize: Size.fromHeight(60),
  child: AppBar(
    backgroundColor: Colors.blue, // Giữ màu AppBar rõ ràng
    title: Container(
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white, // Nền trắng để làm nổi bật
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueAccent, width: 1), // Viền xanh
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.blueAccent), // Biểu tượng kính lúp
          SizedBox(width: 5), // Khoảng cách giữa icon và TextField
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Tìm kiếm sản phẩm...",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16), // Chữ gợi ý rõ ràng hơn
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.black, fontSize: 18), // Chữ rõ hơn
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ],
      ),
    ),
  ),
),

      body: StreamBuilder<List<Product>>(
        stream: _productService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Không có sản phẩm nào!"));
          }

          // Lọc danh sách sản phẩm theo từ khóa tìm kiếm
          final filteredProducts = snapshot.data!
              .where((product) =>
                  product.tenSanPham.toLowerCase().contains(_searchQuery))
              .toList();

          return ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  leading: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.hinhAnh,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  title: Text(product.tenSanPham),
                  subtitle: Text("Giá: ${product.gia}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductFormScreen(product: product),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _productService.deleteProduct(product.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "btn_logout",
            backgroundColor: const Color.fromARGB(255, 36, 184, 41),
            child: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btn_add",
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductFormScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
