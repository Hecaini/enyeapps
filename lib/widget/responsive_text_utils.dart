class ResponsiveTextUtils {
  static bool getLayout(double width) {
    if (width <= 800) {
      return true;
    } else if (width > 800 && width <= 1100) {
      return false;
    } else {
      return false;
    }
  }

  static double getXSmallFontSize(double width) {
    if (width <= 500) {
      return 9.0;
    } else if (width > 500 && width <= 800) {
      return 12.0;
    } else if (width > 800 && width <= 1100) {
      return 15.0;
    } else {
      return 21.0;
    }
  }

  static double getSmallFontSize(double width) {
    if (width <= 500) {
      return 12.0;
    } else if (width > 500 && width <= 800) {
      return 15.0;
    } else if (width > 800 && width <= 1100) {
      return 18.0;
    } else {
      return 24.0;
    }
  }

  static double getNormalFontSize(double width) {
    if (width <= 500) {
      return 14.0;
    } else if (width > 500 && width <= 800) {
      return 18.0;
    } else if (width > 800 && width <= 1100) {
      return 24.0;
    } else {
      return 29.0;
    }
  }

  static double getExtraFontSize(double width) {
    if (width <= 500) {
      return 16.0;
    } else if (width > 500 && width <= 800) {
      return 22.0;
    } else if (width > 800 && width <= 1100) {
      return 28.0;
    } else {
      return 33.0;
    }
  }

  static double getXFontSize(double width) {
    if (width <= 500) {
      return 18.0;
    } else if (width > 500 && width <= 800) {
      return 24.0;
    } else if (width > 800 && width <= 1100) {
      return 30.0;
    } else {
      return 35.0;
    }
  }

  static double getXXFontSize(double width) {
    if (width <= 500) {
      return 24.0;
    } else if (width > 500 && width <= 800) {
      return 30.0;
    } else if (width > 800 && width <= 1100) {
      return 37.0;
    } else {
      return 47.0;
    }
  }

  static double getXXXFontSize(double width) {
    if (width <= 500) {
      return 36.0;
    } else if (width > 500 && width <= 800) {
      return 43.0;
    } else if (width > 800 && width <= 1100) {
      return 50.0;
    } else {
      return 56.0;
    }
  }
}
