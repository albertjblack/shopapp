import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../providers/products.dart';
import './../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const String routeName = "/edit-product";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _imageUrlFocusNode = FocusNode();
  final TextEditingController _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id: "",
      title: "",
      description: "",
      price: 0,
      imageUrl: "",
      isFavorite: false);

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final _productId = ModalRoute.of(context)!.settings.arguments;
      final _products =
          Provider.of<ProductsProvider>(context, listen: false).items;

      if (_productId != null) {
        // if we are arriving through the edit button then we will assign initial values to the _editeProduct // else we will initialize it to an empty product
        _editedProduct =
            _products.firstWhere((element) => element.id == _productId);
        _imageUrlController.text = _editedProduct.imageUrl.toString();
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    bool isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    if (_editedProduct.id != "") {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct("edit", _editedProduct);
    } else {
      _editedProduct = Product(
          id: DateTime.now().toString(),
          title: _editedProduct.title,
          description: _editedProduct.description,
          price: _editedProduct.price,
          imageUrl: _editedProduct.imageUrl,
          isFavorite: _editedProduct.isFavorite);
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct("add", _editedProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(onPressed: () => _saveForm(), icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                  initialValue: _editedProduct.title,
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: value,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite);
                  },
                  decoration: const InputDecoration(labelText: "Title"),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    return value!.isEmpty ? "Title cannot be blank." : null;
                  },
                ),
                TextFormField(
                  initialValue: _editedProduct.price.toString(),
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(value!),
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite);
                  },
                  decoration: const InputDecoration(labelText: "Price"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Price cannot be blank.";
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) < 0) {
                      return "Please enter a valid number greater than 0.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _editedProduct.description,
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: value,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite);
                  },
                  decoration: const InputDecoration(labelText: "Description"),
                  textInputAction: TextInputAction.newline,
                  maxLength: 1000,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    return value!.length <= 9
                        ? "Description needs to be at least 10 characters long."
                        : null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value,
                                isFavorite: _editedProduct.isFavorite);
                          },
                          decoration:
                              const InputDecoration(labelText: "Image URL"),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Image URL cannot be blank.";
                            }
                            if (!value.startsWith("http") &&
                                !value.startsWith("https")) {
                              return "Please enter a valid url.";
                            }
                            if (!value.endsWith(".png") &&
                                !value.endsWith(".PNG") &&
                                !value.endsWith(".JPG") &&
                                !value.endsWith(".jpg") &&
                                !value.endsWith(".jpeg") &&
                                !value.endsWith(".JPEG")) {
                              return "Please enter a valid url for an image (jpg, png, jpeg).";
                            }
                            return null;
                          }),
                    ),
                    SizedBox(
                      width: 82,
                      height: 82,
                      child: _imageUrlController.text.isEmpty
                          ? const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://festivalofnationsstl.org/wp-content/themes/consultix/images/no-image-found-360x250.png"))
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                  _imageUrlController.text.toString())),
                    )
                  ],
                ),
              ]),
            )),
      ),
    );
  }
}
