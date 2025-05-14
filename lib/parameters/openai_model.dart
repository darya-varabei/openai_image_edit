enum OpenAIModel {
  gpt_image_1('gpt-image-1');

  final String value;
  const OpenAIModel(this.value);

  @override
  String toString() => value;
}