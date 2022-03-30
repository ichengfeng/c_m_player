import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        child: Column(
          children: [
            buildHeaderView(context),
            buildListTitle(context, const Icon(Icons.list_alt_outlined), "历史播放", (){
              Navigator.of(context).pop();
            }),
            buildListTitle(context, const Icon(Icons.settings), "我的收藏", (){

            }),
          ],
        ),
      ),
    );
  }

  Widget buildHeaderView(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      color: Colors.orangeAccent,
      alignment: const Alignment(0,0.5),
      margin: const EdgeInsets.only(bottom: 20),
      child: Text('个人中心',
        style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildListTitle(BuildContext context, Widget icon, String title, Function() handler) {
    return ListTile(
      leading: icon,
      title: Text(title, style: Theme.of(context).textTheme.headline6,),
      onTap: handler,
    );
  }
}
