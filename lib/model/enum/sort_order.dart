enum TagOrder {
  TAG_NAME("Name"),
  NUM_SUBTAGS("Total Subtags"),
  NUM_FILES("Total Files"),
  ;

  final String displayName;

  const TagOrder(this.displayName);
}

enum FileOrder {
  FILE_NAME("Name"),
  MODIFICATION_DATE("Date"),
  FILE_SIZE("Size"),
  NUM_TAGS("Tags"),
  FILE_TYPE("Type"),
  ;

  final String displayName;

  const FileOrder(this.displayName);
}
