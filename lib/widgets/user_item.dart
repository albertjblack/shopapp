import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final String? title;
  final String? imageUrl;

  const UserItem({@required this.title, @required this.imageUrl, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).secondaryHeaderColor,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).primaryColor,
              ))
        ]),
      ),
    );
  }
}
