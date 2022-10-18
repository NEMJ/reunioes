import 'package:flutter/material.dart';

class UserProfilePhotoWidget extends StatelessWidget {
  const UserProfilePhotoWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              border: Border.all(width: 4, color: Colors.white),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 1,
                  blurRadius: 10,
                  color: Colors.deepPurple,
                ),
              ],
              shape: BoxShape.circle,
              // image: DecorationImage(
              //   image: Image.asset(
              //     'images/user_account.png',
              //     fit: BoxFit.cover,
              //   ).image,
              // ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage("https://cdn.pixabay.com/photo/2017/11/19/07/30/girl-2961959_960_720.jpg"),
              ),
            ),
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
                padding: EdgeInsets.only(top: 0),
                icon: Icon(Icons.edit),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}