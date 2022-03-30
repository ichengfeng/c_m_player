import 'package:flutter/material.dart';

class HomeNavBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        tooltip: "打开导航菜单",
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: const Text("一只小蛮吉",style: TextStyle(fontSize: 16,color: Colors.white70),),
      actions: [
        IconButton(
          tooltip: "收藏",
          icon: const Icon(
            Icons.favorite,
          ),
          onPressed: () {},
        ),
        IconButton(
          tooltip: "搜索",
          icon: const Icon(
            Icons.search,
          ),
          onPressed: () {},
        ),
        PopupMenuButton<Text>(
          tooltip: '显示菜单',
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                child: Text(
                  "第一个",
                ),
              ),
              const PopupMenuItem(
                child: Text(
                  "第二个",
                ),
              ),
              const PopupMenuItem(
                child: Text(
                  "第三个",
                ),
              ),
            ];
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size(100,49);
}

///非自定义写法
// class NavBar extends AppBar {
//   NavBar({required BuildContext context, Key? key}) : super(
//     key: key,
//     leading: IconButton(
//       tooltip: "打开导航菜单",
//       icon: const Icon(Icons.menu),
//       onPressed: () {
//         Scaffold.of(context).openDrawer();
//       },
//     ),
//     title: const Text("App Bar",),
//     actions: [
//       IconButton(
//         tooltip: "收藏",
//         icon: const Icon(
//           Icons.favorite,
//         ),
//         onPressed: () {},
//       ),
//       IconButton(
//         tooltip: "搜索",
//         icon: const Icon(
//           Icons.search,
//         ),
//         onPressed: () {},
//       ),
//       PopupMenuButton<Text>(
//         tooltip: '显示菜单',
//         itemBuilder: (context) {
//           return [
//             const PopupMenuItem(
//               child: Text(
//                 "第一个",
//               ),
//             ),
//             const PopupMenuItem(
//               child: Text(
//                 "第二个",
//               ),
//             ),
//             const PopupMenuItem(
//               child: Text(
//                 "第三个",
//               ),
//             ),
//           ];
//         },
//       )
//     ],
//   );
// }