import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});
  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  
  String name = '', description = '';
  double price = 0;
  int stock = 0;
  bool _isLoading = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final productData = {
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
      };

      final createdProduct = await ApiService.createProduct(productData);
      
      if (createdProduct != null) {
        _showSuccessDialog();
      } else {
        throw Exception('Gagal membuat produk');
      }
    } catch (e) {
      _showErrorSnackBar('Gagal menambahkan produk: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.green, size: 24),
          SizedBox(width: 8),
          Text(
            'Berhasil!',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      content: const Text('Produk berhasil ditambahkan.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Tutup dialog
            Navigator.pop(context, true); // Kembali ke halaman sebelumnya
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildFormFields(),
                const SizedBox(height: 32),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Tambah Produk',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: const Color(0xFF6366F1),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.add_business,
                color: Color(0xFF6366F1),
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Produk Baru',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Lengkapi informasi produk di bawah ini',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(
          label: 'Nama Produk',
          icon: Icons.shopping_bag_outlined,
          controller: _nameController,
          onChanged: (val) => name = val,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Nama produk tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Deskripsi',
          icon: Icons.description_outlined,
          controller: _descriptionController,
          maxLines: 3,
          onChanged: (val) => description = val,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Harga',
          icon: Icons.attach_money,
          controller: _priceController,
          keyboardType: TextInputType.number,
          prefix: 'Rp ',
          onChanged: (val) => price = double.tryParse(val) ?? 0,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Harga tidak boleh kosong';
            }
            if (double.tryParse(value.trim()) == null) {
              return 'Harga harus berupa angka';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Stok',
          icon: Icons.inventory_outlined,
          controller: _stockController,
          keyboardType: TextInputType.number,
          suffix: 'pcs',
          onChanged: (val) => stock = int.tryParse(val) ?? 0,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Stok tidak boleh kosong';
            }
            if (int.tryParse(value.trim()) == null) {
              return 'Stok harus berupa angka';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    String? prefix,
    String? suffix,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        enabled: !_isLoading,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF1F2937),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF6366F1),
            size: 22,
          ),
          prefixText: prefix,
          suffixText: suffix,
          prefixStyle: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 16,
          ),
          suffixStyle: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF6366F1),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFEF4444),
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFEF4444),
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : saveProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: const Color(0xFF9CA3AF),
        ),
        child: _isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Menyimpan...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : const Text(
                'Simpan Produk',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}