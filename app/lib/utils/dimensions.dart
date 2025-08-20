import 'package:flutter/material.dart';

class Dimensions {
  final double screenHeight;
  final double screenWidth;

  // The constructor gets the screen size ONCE when you create an instance.
  Dimensions(BuildContext context)
      : screenHeight = MediaQuery.of(context).size.height,
        screenWidth = MediaQuery.of(context).size.width;

  // Reference dimensions from your design file (e.g., Figma, Adobe XD)
  static const double _referenceHeight = 844.0;
  static const double _referenceWidth = 390.0;

  // width and height
  double get height => screenHeight;
  double get width => screenWidth;

  // --- Scale Factors ---
  // These calculate the difference between the actual screen and your design.
  double get heightScaleFactor => screenHeight / _referenceHeight;
  double get widthScaleFactor => screenWidth / _referenceWidth;

  // --- Correctly Scaled Height Dimensions ---
  // The logic is now: base_size * scale_factor
  double get height10 => 10.0 * heightScaleFactor;
  double get height15 => 15.0 * heightScaleFactor;
  double get height20 => 20.0 * heightScaleFactor;
  double get height30 => 30.0 * heightScaleFactor;
  double get height45 => 45.0 * heightScaleFactor;

  // --- Correctly Scaled Width Dimensions ---
  double get width10 => 10.0 * widthScaleFactor;
  double get width15 => 15.0 * widthScaleFactor;
  double get width20 => 20.0 * widthScaleFactor;
  double get width30 => 30.0 * widthScaleFactor;
  double get width45 => 45.0 * widthScaleFactor;

  // --- Correctly Scaled Font Sizes ---
  // Note: Fonts usually scale best with the height factor.
  double get font10 => 10.0 * heightScaleFactor;
  double get font12 => 12.0 * heightScaleFactor;
  double get font15 => 15.0 * heightScaleFactor;
  double get font16 => 16.0 * heightScaleFactor;
  double get font18 => 18.0 * heightScaleFactor;
  double get font20 => 20.0 * heightScaleFactor;
  double get font24 => 24.0 * heightScaleFactor;
  double get font26 => 26.0 * heightScaleFactor;
}