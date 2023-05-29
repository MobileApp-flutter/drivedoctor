import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text(
          "Welcome to Admin Dashboard",
          style: TextStyle(
            fontSize: 24, // Set the desired font size
            fontWeight: FontWeight.bold, // Set the desired font weight
          ),
        ),
        Spacer(flex: 2),
        // Expanded(child: SearchField()),
        // Profile()
      ],
    );
  }
}

// class Profile extends StatelessWidget {
//   const Profile({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 8),
//       padding: const EdgeInsets.symmetric(
//         horizontal: 8,
//         vertical: 8 / 2,
//       ),
//       decoration: BoxDecoration(
//           color: Colors.green,
//           borderRadius: const BorderRadius.all(Radius.circular(10)),
//           border: Border.all(color: Colors.white10)),
//       child: Row(
//         children: [
//           Image.asset(
//             'assets/admin/images/profile_pic.png',
//             height: 38,
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 8 / 2),
//             child: Text("Admin"),
//           ),
//           const Icon(Icons.keyboard_arrow_down)
//         ],
//       ),
//     );
//   }
// }

// class SearchField extends StatelessWidget {
//   const SearchField({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: InputDecoration(
//         hintText: "Search",
//         fillColor: Colors.black,
//         filled: true,
//         border: const OutlineInputBorder(
//           borderSide: BorderSide.none,
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//         ),
//         suffixIcon: InkWell(
//           onTap: () {},
//           child: Container(
//             padding: const EdgeInsets.all(8 * 0.75),
//             margin: const EdgeInsets.symmetric(horizontal: 8 / 2),
//             decoration: BoxDecoration(
//                 color: Colors.blue.shade800,
//                 borderRadius: const BorderRadius.all(Radius.circular(10))),
//             child: SvgPicture.asset('assets/admin/icons/Search.svg'),
//           ),
//         ),
//       ),
//     );
//   }
// }
