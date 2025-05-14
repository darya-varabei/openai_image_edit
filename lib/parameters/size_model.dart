enum OpenAIImageSize {
  x1024x1024('1024x1024'),
  x1536x1024('1536x1024'),
  x1024x1536('1024x1536'),
  auto('auto');

  final String value;
  const OpenAIImageSize(this.value);

  @override
  String toString() => value;
}

