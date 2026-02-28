extension StringCapitalization on String {
  String capitalizeEachWord() {
    if (trim().isEmpty) return this;

    return split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }
}
