import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../providers/products.dart';

import './../screens/edit_product_screen.dart';

class UserItem extends StatelessWidget {
  final String? id;
  final String? title;
  final String? imageUrl;

  const UserItem(
      {@required this.id,
      @required this.title,
      @required this.imageUrl,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      title: SizedBox(
        child: Text(
          title!,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            imageUrl!), // NetworkImage is a provider that yields a 'background image' // cannot set a fit // it is not an object // it just fetches and forwards to circle avatar
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).secondaryHeaderColor,
              )),
          IconButton(
              onPressed: () async {
                return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text("Are you sure?"),
                          content:
                              const Text("Do you want to remove the item?"),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  Navigator.of(ctx).pop(true);
                                  try {
                                    await Provider.of<ProductsProvider>(context,
                                            listen: false)
                                        .removeProduct(id!);
                                  } catch (e) {
                                    scaffoldMessenger.clearSnackBars();
                                    scaffoldMessenger.showSnackBar(SnackBar(
                                      backgroundColor: Theme.of(context)
                                          .secondaryHeaderColor,
                                      duration: const Duration(seconds: 2),
                                      content: const Text(
                                        "Failed to delete, try again later.",
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                                  }
                                },
                                child: const Text("Yes")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop(false);
                                },
                                child: const Text("No"))
                          ],
                        ));
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).primaryColor,
              ))
        ]),
      ),
    );
  }
}
