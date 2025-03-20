import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'package:uuid/uuid.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  ProductFormScreen({this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final ProductService _productService = ProductService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.tenSanPham;
      _typeController.text = widget.product!.loaiSanPham;
      _priceController.text = widget.product!.gia.toString();
      _imageController.text = widget.product!.hinhAnh;
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: widget.product?.id ?? Uuid().v4(),
        tenSanPham: _nameController.text,
        loaiSanPham: _typeController.text,
        gia: double.parse(_priceController.text),
        hinhAnh: _imageController.text,
      );

      if (widget.product == null) {
        _productService.addProduct(newProduct);
      } else {
        _productService.updateProduct(newProduct);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product == null ? "Thêm sản phẩm" : "Sửa sản phẩm")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Tên sản phẩm"),
                validator: (value) => value!.isEmpty ? "Không được để trống" : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(labelText: "Loại sản phẩm"),
                validator: (value) => value!.isEmpty ? "Không được để trống" : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "Giá"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Không được để trống" : null,
              ),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: "Hình ảnh (URL)"),
                validator: (value) => value!.isEmpty ? "Không được để trống" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text(widget.product == null ? "Thêm" : "Cập nhật"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
