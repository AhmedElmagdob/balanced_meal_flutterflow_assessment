import 'package:flutter/material.dart';
import '../utils/screen_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class HorizontalFoodCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String calories;
  final String price;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const HorizontalFoodCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.calories,
    required this.price,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: ScreenUtils.getProportionateScreenHeight(8),
        horizontal: ScreenUtils.getProportionateScreenWidth(8),
      ),
      padding: EdgeInsets.only(top: ScreenUtils.getProportionateScreenHeight(8),
      bottom: ScreenUtils.getProportionateScreenHeight(8),
        left: ScreenUtils.getProportionateScreenWidth(10),
        right: ScreenUtils.getProportionateScreenWidth(10),
    ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtils.getProportionateScreenWidth(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(ScreenUtils.getProportionateScreenWidth(16)),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: ScreenUtils.getProportionateScreenWidth(90),
              height: ScreenUtils.getProportionateScreenHeight(90),
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: ScreenUtils.getProportionateScreenWidth(90),
                  height: ScreenUtils.getProportionateScreenHeight(90),
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(width: ScreenUtils.getProportionateScreenWidth(16)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: ScreenUtils.getProportionateScreenWidth(16),
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      price,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtils.getProportionateScreenHeight(24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        calories,
                        style: GoogleFonts.poppins(
                          fontSize: ScreenUtils.getProportionateScreenWidth(18),
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    _CircleButton(
                      icon: Icons.remove,
                      onTap: onRemove,
                    ),
                    SizedBox(width: ScreenUtils.getProportionateScreenWidth(12)),
                    Text(
                      quantity.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: ScreenUtils.getProportionateScreenWidth(20),
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: ScreenUtils.getProportionateScreenWidth(12)),
                    _CircleButton(
                      icon: Icons.add,
                      onTap: onAdd,
                    ),

                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ScreenUtils.getProportionateScreenWidth(24),
        height: ScreenUtils.getProportionateScreenWidth(24),
        decoration: BoxDecoration(
          color: Color(0xFFF25700),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: ScreenUtils.getProportionateScreenWidth(14),
          ),
        ),
      ),
    );
  }
} 