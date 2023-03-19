import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JoinGameDialog extends StatefulWidget {
  const JoinGameDialog({super.key});

  @override
  State<JoinGameDialog> createState() => _JoinGameDialogState();
}

class _JoinGameDialogState extends State<JoinGameDialog> {
  final TextEditingController gameKeyControeller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 17, 17, 17),
      title: Center(
        child: Text(
          "Join Game",
          style: GoogleFonts.poppins(
            fontSize: 24,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Game Key",
            style: GoogleFonts.poppins(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: gameKeyControeller,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
            style: GoogleFonts.poppins(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              fillColor: Color.fromARGB(255, 53, 53, 53),
              filled: true,
              hintText: "key",
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            "Join",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            // Do something when the user presses the "Join" button
          },
        ),
      ],
    );
  }
}
