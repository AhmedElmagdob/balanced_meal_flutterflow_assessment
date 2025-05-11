import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/screen_utils.dart';
import 'custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class FoodCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String calories;
  final String price;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback? onRemove;

  const FoodCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.calories,
    required this.price,
    required this.onAdd,
    this.onRemove,
    this.quantity = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    return Container(
      width: ScreenUtils.getProportionateScreenWidth(183),
      padding: EdgeInsets.all(ScreenUtils.getProportionateScreenWidth(8)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtils.getProportionateScreenWidth(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(ScreenUtils.getProportionateScreenWidth(16)),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity,
              height: ScreenUtils.getProportionateScreenHeight(108),
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: ScreenUtils.getProportionateScreenHeight(108),
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(height: ScreenUtils.getProportionateScreenHeight(6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name.length > 12 ? name.substring(0, 12) + '...' : name,
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtils.getProportionateScreenWidth(16),
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                calories,
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtils.getProportionateScreenWidth(12),
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenUtils.getProportionateScreenHeight(6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price + "\$",
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtils.getProportionateScreenWidth(14),
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              quantity == 0
                  ? CustomButton(
                      text: 'Add',
                      onPressed: onAdd,
                      height: ScreenUtils.getProportionateScreenHeight(40),
                      padding: EdgeInsets.zero,
                      backgroundColor: const Color(0xFFF25700),
                      textColor: Colors.white,
                      borderRadius: ScreenUtils.getProportionateScreenHeight(24),
                      width: ScreenUtils.getProportionateScreenWidth(75),
                    )
                  : Row(
                      children: [
                        _CircleIconButton(
                          icon: Icons.remove,
                          onTap: onRemove!,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: ScreenUtils.getProportionateScreenWidth(8)),
                          child: Text(
                            '$quantity',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtils.getProportionateScreenWidth(16),
                            ),
                          ),
                        ),
                        _CircleIconButton(
                          icon: Icons.add,
                          onTap: onAdd,
                        ),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ScreenUtils.getProportionateScreenWidth(32),
        height: ScreenUtils.getProportionateScreenWidth(32),
        decoration: BoxDecoration(
          color: const Color(0xFFF25700),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: ScreenUtils.getProportionateScreenWidth(20)),
      ),
    );
  }
} 