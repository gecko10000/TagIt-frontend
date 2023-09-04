import '../../../model/object/dimensions.dart';

Dimensions calculateIdealDimensions(
    Dimensions? fileDimensions, Dimensions widgetMaxDimensions) {
  // no file dimensions, can only estimate using the widget max
  if (fileDimensions == null) return widgetMaxDimensions;
  final fileWidth = fileDimensions.width, fileHeight = fileDimensions.height;
  final widgetWidth = widgetMaxDimensions.width,
      widgetHeight = widgetMaxDimensions.height;
  if (fileWidth <= widgetWidth && fileHeight <= widgetHeight) {
    return Dimensions(width: fileWidth, height: fileHeight);
  }
  // at this point, we are sure at least one ratio will be >= 1
  // the larger ratio takes precedence
  // (more shrinkage needed in that direction)
  final widthRatio = fileWidth / widgetWidth,
      heightRatio = fileHeight / widgetHeight;
  if (widthRatio > heightRatio) {
    return Dimensions(width: widgetWidth, height: fileHeight / widthRatio);
  }
  return Dimensions(width: fileWidth / heightRatio, height: widgetHeight);
}
