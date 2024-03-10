import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medcs_dashboard/core/constant/app_constant.dart';
import 'package:medcs_dashboard/core/constant/colors.dart';
import 'package:medcs_dashboard/core/utlity/styles.dart';
import 'package:medcs_dashboard/models/product_model.dart';
import 'package:medcs_dashboard/views/dashboard_view.dart';
import 'package:medcs_dashboard/widgets/custom_description_field.dart';
import 'package:medcs_dashboard/widgets/custom_inventory_qunatity.dart';
import 'package:medcs_dashboard/widgets/custom_price_field.dart';
import 'package:medcs_dashboard/widgets/custom_volume_filed.dart';
import 'package:medcs_dashboard/widgets/cutom_drop_down_field.dart';
import 'package:medcs_dashboard/widgets/title_form_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({Key? key, this.productsModel}) : super(key: key);

  final ProductsModel? productsModel;
  @override
  State<AddProductView> createState() => _AddProductViewState();
}

TextEditingController _titleController = TextEditingController();
TextEditingController _priceController = TextEditingController();
TextEditingController _volumeController = TextEditingController();
TextEditingController _descriptionController = TextEditingController();
TextEditingController _inventoryQuantityController = TextEditingController();

class _AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormState>();

  String categoryValue = 'basic';
  bool isEditing = false;
  bool _isLoading = false;
  String? productImageUrl;
  Uint8List? _imageBytes;
  String? _fileExtension;

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'svg'],
    );

    if (result != null) {
      // Use the `bytes` property directly for web compatibility
      _imageBytes = result.files.single.bytes;
      _fileExtension = result.files.single.extension;

      setState(() {});
    }
  }

  void _removeImage() {
    setState(() {
      _imageBytes = null;
    });
  }

  void _removeData() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _volumeController.clear();
      _inventoryQuantityController.clear();
      _imageBytes = null;
    });
  }

  Future<void> _uploadProduct() async {
    _formKey.currentState!.save();
    if (_imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('please provide and image ')));
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final ref = FirebaseStorage.instance
          .ref()
          .child("productsImages")
          .child('${_titleController.text.trim()}.$_fileExtension');
      await ref.putData(_imageBytes!);
      productImageUrl = await ref.getDownloadURL();

      final productID = const Uuid().v4();
      await FirebaseFirestore.instance
          .collection("products")
          .doc(productID)
          .set({
        'productID': productID,
        'productTitle': _titleController.text,
        'productPrice': _priceController.text,
        'productImage': productImageUrl,
        'productCategory': categoryValue,
        'productDescription': _descriptionController.text,
        'productQuantity': _volumeController.text,
        'inventoryQuantity':
            int.parse(_inventoryQuantityController.text), // Add this line

        'createdAt': Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Product added successfuly ',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        );
        if (mounted) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()));
        }
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text('an error has occured ${e.message}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text('an error has occured $e')));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    if (widget.productsModel != null) {
      isEditing = true;
    }
    _titleController =
        TextEditingController(text: widget.productsModel?.productTitle);
    _priceController = TextEditingController(
        text: widget.productsModel?.productPrice.toString());
    _volumeController = TextEditingController(
        text: widget.productsModel?.productVolume.toString());
    _descriptionController = TextEditingController(
        text: widget.productsModel?.productDescription.toString());

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _volumeController.dispose();
    super.dispose();
  }

  Widget getImageWidget(Uint8List bytes) {
    if (_isSvg(bytes)) {
      return SvgPicture.memory(bytes);
    } else {
      return Image.memory(bytes);
    }
  }

  bool _isSvg(Uint8List bytes) {
    String header = String.fromCharCodes(bytes.sublist(0, 4));
    return header == '<svg' || header == '<?xm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              isEditing ? 'Edit Product' : 'Add New Medicine',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '(All Fields are mandatory)',
              style: TextStyle(
                color: AppColors.secondryLight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: isEditing
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  height: 200,
                  child: DottedBorder(
                    color: Colors.deepOrange,
                    radius: const Radius.circular(12),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              _imageBytes != null
                                  ? getImageWidget(_imageBytes!)
                                  : const Icon(
                                      Icons.image_outlined,
                                      size: 80,
                                      color: Colors.deepOrange,
                                    ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _imageBytes == null
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: TextButton(
                                            onPressed: _pickImage,
                                            child: const Text(
                                                'Pick Product Image'),
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: TextButton(
                                            onPressed: _removeImage,
                                            child: const Text(
                                                'Remove Product image '),
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: isEditing
                      ? const EdgeInsets.only(right: 371)
                      : EdgeInsets.zero,
                  child: const Text(
                    'Medicine name',
                    style: StylesLight.bodyLarge17,
                  ),
                ),
                CustomTitleFormField(controller: _titleController),
                Row(
                  mainAxisAlignment: isEditing
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Medicine Price',
                          style: StylesLight.bodyLarge17,
                        ),
                        CustomPriceField(controller: _priceController),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Medicine Volume',
                          style: StylesLight.bodyLarge17,
                        ),
                        CustomVolumeField(controller: _volumeController),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Quantity',
                          style: StylesLight.bodyLarge17,
                        ),
                        CustomInventoryQuantity(
                            controller: _inventoryQuantityController)
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: isEditing
                      ? const EdgeInsets.only(right: 355)
                      : EdgeInsets.zero,
                  child: const Text(
                    'Medicine category',
                    style: StylesLight.bodyLarge17,
                  ),
                ),
                CustomDropdownFormField(
                  onChanged: (String? value) {
                    setState(() {
                      categoryValue = value!;
                    });
                  },
                  items: AppConstent.categoriesDropDownList,
                ),
                Padding(
                  padding: isEditing
                      ? const EdgeInsets.only(right: 340)
                      : EdgeInsets.zero,
                  child: const Text(
                    'Medicine description',
                    style: StylesLight.bodyLarge17,
                  ),
                ),
                CustomDescriptionField(controller: _descriptionController),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: isEditing
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 46,
                      width: 200,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepOrange),
                        ),
                        onPressed: () async {
                          if (isEditing) {
                            await _editProduct();

                            if (mounted) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardScreen()));
                            }
                          } else {
                            await _uploadProduct();
                          }
                        },
                        child: Text(
                          isEditing ? "Update Product" : 'Upload Product',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 46,
                      width: 200,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepOrange),
                        ),
                        onPressed: () {
                          _removeData();
                        },
                        child: const Text(
                          'Clear Data',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editProduct() async {
    _formKey.currentState!.save();
    if (_imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('please provide and image ')));
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final ref = FirebaseStorage.instance
          .ref()
          .child("productsImages")
          .child('${_titleController.text.trim()}.$_fileExtension');
      await ref.putData(_imageBytes!);
      productImageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("products")
          .doc(widget
              .productsModel!.productID) // Use existing product ID for editing
          .update({
        'productTitle': _titleController.text,
        'productPrice': _priceController.text,
        'productImage': productImageUrl,
        'productCategory': categoryValue,
        'productDescription': _descriptionController.text,
        'productQuantity': _volumeController.text,
        'updatedAt': Timestamp.now(),
        'inventoryQuantity':
            int.parse(_inventoryQuantityController.text), // Add this line
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Product updated successfully',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        );
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text('An error has occurred: ${e.message}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text('An error has occurred: $e')));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
