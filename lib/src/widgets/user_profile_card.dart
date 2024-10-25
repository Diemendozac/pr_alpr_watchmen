import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pr_alpr_watchmen/src/services/ticket_service.dart';

import '../models/user_model.dart';

class UserProfileCard extends StatefulWidget {
  const UserProfileCard(
    this.setUsersRequested,
    this.users,
    this.plate,{
    super.key,
  });

  final List<User> users;
  final String plate;
  final void Function() setUsersRequested;

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: Center(
          child: TapRegion(
              onTapOutside: (event) {
                widget.setUsersRequested();
              },
              child: _buildTestWidget(height, width)),
        ),
      ),
    );
  }

  Widget _buildTestWidget(double height, double width) {
    final PageController pageController = PageController(
      initialPage: 0,
    );

    return SizedBox(
      height: height * 0.65,
      width: width * 0.9,
      child: PageView.builder(
          controller: pageController,
          itemCount: widget.users.length,
          onPageChanged: (idx) {
            // Change current page when pageview changes
            setState(() {});
          },
          itemBuilder: (context, idx) {
            final currentUser = widget.users[idx];
            const textStyle = TextStyle(
                decoration: TextDecoration.none,
                fontSize: 18,
                fontFamily: 'SourceSansPro',
                color: Colors.black,
                // fontWeight: FontWeight.bold,
                letterSpacing: 0.33,
                overflow: TextOverflow.ellipsis);
            return _returnUserCard(width, currentUser, textStyle);
          }),
    );
  }

  Container _returnUserCard(
      double width, User currentUser, TextStyle textStyle) {

    final TicketService ticketService = TicketService();

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.teal, borderRadius: BorderRadius.circular(20)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: width * 0.35,
              backgroundImage: _getUserImage(currentUser.urlPhoto),
            ),
            buildUserName(currentUser.name),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 10, 0, 10),
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.mail_outline,
                    size: 25,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentUser.email,
                      style: textStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  dynamic response = await ticketService.issueTicket(currentUser.email, widget.plate);
                  if(response.statusCode == 200) widget.setUsersRequested();
                },
                child: const Text('Dar ingreso'))
          ]),
    );
  }

  Container buildUserName(String name) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(0, 12, 0, 7),
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: const TextStyle(
          decoration: TextDecoration.none,
          color: Colors.white,
          fontFamily: 'Pacifico',
          fontSize: 30,
          // fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ImageProvider _getUserImage(String? photoUrl) {
    return photoUrl == null
        ? const AssetImage('assets/images/default-user.png')
        : NetworkImage(photoUrl) as ImageProvider;
  }
}
