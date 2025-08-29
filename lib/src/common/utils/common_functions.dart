/// Utility class containing common functions used throughout the app
class CommonFunctions {
  /// Determines if a grid item should be shown based on edit state and visibility settings
  ///
  /// [isEditPressedYellow] - Whether the edit mode is currently active
  /// [hideImage] - Whether the image should be hidden
  /// [hideTitle] - Whether the title should be hidden
  ///
  /// Returns true if the item should be shown, false otherwise
  static bool getCheckforGridShow({
    required bool isEditPressedYellow,
    required bool hideImage,
    required bool hideTitle,
  }) {
    if (!isEditPressedYellow) {
      if (hideImage == true && hideTitle == true) {
        return false;
      }
    }
    return true;
  }
}
