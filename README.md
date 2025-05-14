# 🎨 openai_image_edit

A minimal and flexible Flutter package to interact with OpenAI’s `gpt-image-1` model for **image editing** and **generation**, using natural language prompts and one or more image inputs.

![License: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)

---

## ✨ Features

- 🧠 Interact with `gpt-image-1` for **smart image editing**
- 🖼️ Generate new images from text prompts
- 📦 Easy integration with `http`, `dio`, or other networking tools
- 🧪 Typed responses and `base64` decoding included
- 🔐 Works with your OpenAI API key

---

## 🚀 Getting Started

### 1. Add Dependency

In your `pubspec.yaml`:

```yaml
dependencies:
  openai_image_edit: ^0.0.1
```

Then run:

```bash
flutter pub get
```

---

## 🛠️ Usage

### 🔧 Initialize the Client

```dart
final client = OpenAIImageEditClient(apiKey: 'your-api-key-here');
```

### 🧠 Image Edit Example

<pre>```dart

final imageBytes = await loadImageAsBytes('sunset_image.png');

final imageData = await client.editImages(
prompt: "Make the image more futuristic",
images: [imageBytes],
size: OpenAIImageSize.x1536x1024);

if (imageData.isNotEmpty) {
  await saveImage(imageData.first);
} else {
  print('No image was returned.');
}

```</pre>

---

### 🎨 Image Generation Example

<pre>```dart

final imageData = await client.generateImage(
  prompt: "Draw a cat in a basket",
  size: OpenAIImageSize.x1536x1024);

if (imageData.isNotEmpty) {
  await saveImage(imageData.first);
} else {
  print('No image was returned.');
}

```</pre>

---

## 📦 Supported Sizes

```dart
enum OpenAIImageSize {
  x1024x1024,
  x1536x1024,
  x1024x1536,
  auto
}
```

---

## 🧪 Testing

You can test the core methods using:

```bash
flutter test
```

Make sure to include a valid `.env` or pass your API key securely during tests.

---

## 📄 License

This package is released under the MIT License. See [LICENSE](LICENSE) for details.

---

## 💬 Contributions

Feel free to open issues, PRs, or discussions! Contributions are welcome.

---

## 🔗 Links

- [OpenAI Image API Docs](https://platform.openai.com/docs/api-reference/images)
- [pub.dev Package](https://pub.dev/packages/openai_image_client)
