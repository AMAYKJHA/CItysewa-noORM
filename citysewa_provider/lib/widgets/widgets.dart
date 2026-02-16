import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";

const defaultProfileImage = "assets/images/avatar.png";

class AppLogo extends StatelessWidget {
  static const appLogo = 'assets/images/test.png';
  final double size;
  const AppLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(appLogo, width: 2 * size, height: 2 * size),
    );
  }
}

class ProfileIcon extends StatelessWidget {
  final String? userPhoto;
  final VoidCallback? onClick;
  final double radius;
  const ProfileIcon({
    super.key,
    this.userPhoto,
    this.onClick,
    this.radius = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    print(userPhoto);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onClick,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.transparent,
          backgroundImage: userPhoto != null
              ? CachedNetworkImageProvider(userPhoto!)
              : AssetImage(defaultProfileImage) as ImageProvider,
        ),
      ),
    );
  }
}

class VerifyYourselfBanner extends StatelessWidget {
  const VerifyYourselfBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/verify');
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFCE8E1),
          border: Border.all(color: const Color(0xFFF5B7A3)),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              offset: Offset(0, 6),
              blurRadius: 6,
            ),
          ],
        ),
        child: RichText(
          text: const TextSpan(
            text: 'You are not verified yet. Please submit the ',
            style: TextStyle(fontSize: 15, color: Color(0xFF7A2F1C)),
            children: [
              TextSpan(
                text: "verification form.",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Color(0xFFCC4C2B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
