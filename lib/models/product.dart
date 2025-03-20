class Product {
  String id;
  String tenSanPham;
  String loaiSanPham;
  double gia;
  String hinhAnh;

  Product({
    required this.id,
    required this.tenSanPham,
    required this.loaiSanPham,
    required this.gia,
    required this.hinhAnh,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tenSanPham': tenSanPham,
      'loaiSanPham': loaiSanPham,
      'gia': gia,
      'hinhAnh': hinhAnh,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      tenSanPham: map['tenSanPham'],
      loaiSanPham: map['loaiSanPham'],
      gia: map['gia'].toDouble(),
      hinhAnh: map['hinhAnh'],
    );
  }
}
