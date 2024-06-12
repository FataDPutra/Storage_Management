// Ini adalah import statement untuk mengimpor library yang diperlukan
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Mengimpor provider untuk manajemen state
import 'package:storage_management/providers/product_provider.dart'; // Mengimpor provider product
import 'package:storage_management/providers/category_provider.dart'; // Mengimpor provider category
import 'package:slider_button/slider_button.dart'; // Mengimpor widget SliderButton

// Ini adalah class untuk halaman form produk yang merupakan stateful widget
class FormProductPage extends StatefulWidget {
  final String username;

  // Constructor FormProductPage dengan parameter username
  const FormProductPage({required this.username, super.key});

  @override
  _FormProductPageState createState() => _FormProductPageState();
}

// Ini adalah state dari FormProductPage
class _FormProductPageState extends State<FormProductPage> {
  // initState dipanggil ketika state pertama kali dibuat
  @override
  void initState() {
    super.initState();
    // Mereset controllers pada ProductProvider
    context.read<ProductProvider>().resetControllers();
    // Mengeset selectedImage menjadi null pada ProductProvider
    context.read<ProductProvider>().selectedImage = null;
  }

  // Ini adalah method untuk membangun tampilan halaman
  @override
  Widget build(BuildContext context) {
    // Mengambil instance ProductProvider dari context
    final productProvider = context.watch<ProductProvider>();
    // Mengambil instance CategoryProvider dari context
    final categoryProvider = context.read<CategoryProvider>();

    // Mengembalikan widget Scaffold sebagai kerangka halaman
    return Scaffold(
      // AppBar sebagai bagian atas halaman
      appBar: AppBar(
        title: const Text('Add Product'), // Judul AppBar
        titleTextStyle: const TextStyle(
          // Gaya teks untuk judul
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20,
        ),
        backgroundColor: Colors.amber, // Warna latar belakang AppBar
      ),
      // Body dari halaman
      body: Container(
        color:
            const Color.fromARGB(255, 42, 98, 154), // Warna latar belakang body
        // Padding untuk memberikan jarak dari pinggir halaman
        child: Padding(
          padding: const EdgeInsets.all(16),
          // FutureBuilder untuk menunggu data dari Future
          child: FutureBuilder(
            future: categoryProvider
                .getCategories(), // Future untuk mendapatkan kategori
            builder: (context, snapshot) {
              // Jika masih dalam proses pengambilan data
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator()); // Tampilkan loading indicator
              }

              // Jika sudah selesai mengambil data
              return Form(
                key: productProvider.formKey, // Key untuk Form
                // ListView untuk menampilkan form
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Judul "Product Name"
                    const Text(
                      'Product Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10), // Spasi
                    // TextFormField untuk input nama produk
                    TextFormField(
                      controller: productProvider
                          .nameController, // Controller untuk input nama produk
                      validator: (value) {
                        // Validator untuk validasi input
                        if (value!.isEmpty) {
                          return 'Please enter product name'; // Pesan error jika input kosong
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        // Dekorasi input
                        hintText: "Product Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 236, 170),
                      ),
                    ),
                    const SizedBox(height: 10), // Spasi
                    // Judul "Quantity"
                    const Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10), // Spasi
                    // TextFormField untuk input jumlah produk
                    TextFormField(
                      controller: productProvider
                          .quantityController, // Controller untuk input jumlah produk
                      keyboardType: TextInputType
                          .number, // Keyboard type untuk input angka
                      validator: (value) {
                        // Validator untuk validasi input
                        if (value!.isEmpty) {
                          return 'Please enter quantity'; // Pesan error jika input kosong
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        // Dekorasi input
                        hintText: "Quantity",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 236, 170),
                      ),
                    ),
                    const SizedBox(height: 10), // Spasi
                    // Judul "Category"
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10), // Spasi
                    // DropdownButtonFormField untuk memilih kategori produk
                    DropdownButtonFormField<int>(
                      value:
                          productProvider.categoryIdController.text.isNotEmpty
                              ? int.tryParse(
                                  productProvider.categoryIdController.text)
                              : null,
                      items: categoryProvider.listCategory?.map((category) {
                        return DropdownMenuItem<int>(
                          value: category.id ?? 0,
                          child: Text(category.name ?? ''),
                        );
                      }).toList(),
                      onChanged: (value) {
                        productProvider.categoryIdController.text =
                            value.toString();
                      },
                      decoration: const InputDecoration(
                        // Dekorasi input
                        hintText: "Category",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 236, 170),
                      ),
                      validator: (value) {
                        // Validator untuk validasi input
                        if (value == null) {
                          return 'Please select a category'; // Pesan error jika kategori tidak dipilih
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10), // Spasi
                    // Judul "Image"
                    const Text(
                      'Image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10), // Spasi
                    // Menampilkan gambar produk yang dipilih
                    productProvider.selectedImage != null
                        ? Image.file(
                            productProvider.selectedImage!,
                            width: 175,
                            height: 175,
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            'lib/assets/images/default.png',
                            width: 175,
                            height: 175,
                            fit: BoxFit.fill,
                          ),
                    const SizedBox(height: 10), // Spasi
                    // Button untuk memilih gambar produk
                    ElevatedButton(
                      onPressed: () async {
                        await context
                            .read<ProductProvider>()
                            .pickImage(); // Memilih gambar produk
                        setState(
                            () {}); // Memperbarui tampilan setelah memilih gambar
                      },
                      style: ElevatedButton.styleFrom(
                          // Gaya button
                          backgroundColor: const Color.fromARGB(255, 255, 236,
                              170)), // Warna latar belakang button
                      child: const Text('Pick Image'), // Teks pada button
                    ),
                    const SizedBox(height: 10), // Spasi
                    // SliderButton untuk menambahkan produk
                    SliderButton(
                      action: () async {
                        // Memeriksa apakah semua field telah diisi
                        if (productProvider.nameController.text.isNotEmpty &&
                            productProvider
                                .quantityController.text.isNotEmpty &&
                            productProvider
                                .categoryIdController.text.isNotEmpty) {
                          try {
                            // Mengatur createdBy dan updatedBy dengan username
                            productProvider.createdByController.text =
                                widget.username;
                            productProvider.updatedByController.text =
                                widget.username;
                            // Memasukkan produk ke dalam database
                            await productProvider.insertProduct(context);
                          } catch (e) {
                            productProvider.messageError = e.toString();
                            // Menampilkan pesan error jika terjadi kesalahan
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(productProvider.messageError),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          // Menampilkan pesan error jika ada field yang kosong
                          productProvider.messageError =
                              'Please fill out all fields';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(productProvider.messageError),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      label: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      icon: const Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.75,
                      radius: 10,
                      height: 50,
                      buttonSize: 50,
                      buttonColor: Colors.amber,
                      backgroundColor: Colors.blue,
                      highlightedColor: Colors.white,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
