import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pr_alpr_watchmen/src/blocs/user_finder_bloc/user_finder_event_handler.dart';

import '../models/user_model.dart';

class UserProfileListWidget extends StatefulWidget {
  const UserProfileListWidget(
    this.users,
    this.plate, {
    super.key,
    required this.cameraPageEventHandler,
  });

  final CameraPageEventHandler cameraPageEventHandler;
  final List<User> users;
  final String plate;

  @override
  State<UserProfileListWidget> createState() => _UserProfileListWidgetState();
}

class _UserProfileListWidgetState extends State<UserProfileListWidget> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: TapRegion(
          onTapOutside: (event) {
            widget.cameraPageEventHandler
                .handleVehicleRelatedUsersCardsClosed();
          },
          child: _buildContent(height, width),
        ),
      ),
    );
  }

  Widget _buildContent(double height, double width) {
    final PageController pageController = PageController(initialPage: 0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height * 0.65,
          width: width * 0.9,
          child: PageView.builder(
            controller: pageController,
            itemCount: widget.users.length,
            onPageChanged: (idx) {
              setState(() {
                currentPage = idx;
              });
            },
            itemBuilder: (context, idx) {
              final currentUser = widget.users[idx];
              return _buildUserCard(width, currentUser);
            },
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${currentPage + 1} / ${widget.users.length}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(double width, User currentUser) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: CircleAvatar(
              radius: width * 0.3,
              backgroundImage: _getUserImage(currentUser.urlPhoto),
              backgroundColor: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            flex: 1,
            child: Text(
              currentUser.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Flexible(
            flex: 2,
            child: Column(
              children: [
                _buildInfoCard(Icons.email_outlined, currentUser.email),
                const SizedBox(height: 12),
                _buildInfoCard(
                    Icons.phone, currentUser.phoneNumber ?? 'No especificado'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => widget.cameraPageEventHandler
                .handleTicketGeneration(widget.plate, currentUser.email),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.maxFinite, 40),
              backgroundColor: const Color(0xffe91e63),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Ingresar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  ImageProvider _getUserImage(String? photoUrl) {
    return photoUrl == null
        ? const AssetImage('assets/images/user_placeholder.png')
        : NetworkImage(photoUrl) as ImageProvider;
  }

  Widget _buildInfoCard(IconData icon, String data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xffF0F0F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: const Color(0xffB71685)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              data,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff212121),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
