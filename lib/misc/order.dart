

enum Order {
  alphabetical("ALPHABETICAL"),
  dateModified("DATE_MODIFIED"),
  size("SIZE"),
  ;

  final String apiName;
  const Order(this.apiName);
}
