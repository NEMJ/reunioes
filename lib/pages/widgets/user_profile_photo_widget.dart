import 'package:flutter/material.dart';

class UserProfilePhotoWidget extends StatelessWidget {
  UserProfilePhotoWidget({
    Key? key,
    required this.refImage,
  }) : super(key: key);

  String refImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Center(
        child: Stack(
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                border: Border.all(width: 4, color: Colors.white),
                boxShadow: const [
                  BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 10,
                    color: Colors.deepPurple,
                  ),
                ],
                shape: BoxShape.circle,
                image: refImage.isNotEmpty
                ?  DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(refImage),
                  )
                : DecorationImage(
                    image: Image.asset(
                      "images/user_account.png",
                      fit: BoxFit.cover,
                    ).image,
                  ),
              ),
              // child: Text('100%', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.purple.shade900)),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 3,
                    color: Colors.white,
                  ),
                  color: Colors.deepPurple,
                ),
                child: IconButton(
                  padding: const EdgeInsets.only(top: 0),
                  icon: const Icon(Icons.edit),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}