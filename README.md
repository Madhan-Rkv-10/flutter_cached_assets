<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
</head>
<body>
    <h1>Flutter Cached Assets Project</h1>
    <table align="center" style="margin: 0px auto;">
  <tr>
    <td style="text-align: center;">
      <div>
        <img src="output/flutter_caching.gif" alt="CoverSliderView" height="250">
        <p><a href="lib/main.dart" target="_blank">Flutter Caching</a></p>
      </div>
    </td>
  </tr>
  <tr> 
  </tr>
</table>
    <h2>Table of Contents</h2>
    <ul>
        <li><a href="#overview">Overview</a></li>
        <li><a href="#features">Features</a></li>
        <li><a href="#getting-started">Getting Started</a></li>
        <li><a href="#usage">Usage</a></li>
        <li><a href="#project-structure">Project Structure</a></li>
        <li><a href="#dependencies">Dependencies</a></li>
        <li><a href="#contributing">Contributing</a></li>
        <li><a href="#license">License</a></li>
    </ul>
    <h2 id="overview">Overview</h2>
    <p>The Flutter Cached Assets project demonstrates how to fetch and cache various image formats (PNG, JPEG, GIF, SVG, and JSON for Lottie animations) in a Flutter application using the Hive database for local storage. This project provides utility functions and widgets to efficiently manage and display cached assets.</p>
    <h2 id="features">Features</h2>
    <ul>
        <li>Fetch image data from URLs and cache it locally.</li>
        <li>Support for multiple image formats: PNG, JPEG, GIF, SVG, and JSON (Lottie).</li>
        <li>Reuse cached images to reduce network requests and improve performance.</li>
        <li>Custom widgets for displaying network and memory images with different formats.</li>
    </ul>
    <h2 id="getting-started">Getting Started</h2>
    <h3>Prerequisites</h3>
    <p>Ensure you have the following installed:</p>
    <ul>
        <li><a href="https://flutter.dev/docs/get-started/install">Flutter</a></li>
        <li><a href="https://dart.dev/get-dart">Dart</a></li>
    </ul>
    <h3>Installation</h3>
    <ol>
        <li>Clone the repository:
            <pre><code>git clone https://github.com/Madhan-Rkv-10/flutter-cached-assets.git
cd flutter-cached-assets</code></pre>
        </li>
        <li>Install dependencies:
            <pre><code>flutter pub get</code></pre>
        </li>
        <li>Run the application:
            <pre><code>flutter run</code></pre>
        </li>
    </ol>
    <h2 id="usage">Usage</h2>
    <h3>Main Application</h3>
    <p>The main application is located in <code>lib/main.dart</code>. It initializes Hive, opens a Hive box, and starts the <code>MyApp</code> widget.</p>
    <h3>Widgets</h3>
    <ul>
        <li><strong>CommonNetworkImage</strong>: A widget for displaying network images with support for PNG, JPEG, GIF, SVG, and JSON (Lottie) formats.</li>
        <li><strong>CommomMemoryImage</strong>: A widget for displaying images from a <code>Uint8List</code> in various formats.</li>
    </ul>
    <h3>Utility Functions</h3>
    <ul>
        <li><strong>Utils</strong>: Contains static methods for fetching and caching image data.
            <ul>
                <li><code>getConvertedUintListData</code>: Fetches image data from a URL and converts it to <code>Uint8List</code>.</li>
                <li><code>getAndUpdateToLocal</code>: Fetches image data, caches it locally using Hive, and returns the cached data if available.</li>
            </ul>
        </li>
    </ul>
    <h3>Example Usage</h3>
    <pre><code>CommonNetworkImage(
  imageUrl: 'https://example.com/image.png',
  width: 100,
  height: 100,
  imageType: ImageType.global,
  fit: BoxFit.cover,
);</code></pre>
    <h2 id="project-structure">Project Structure</h2>
    <pre><code>lib/
├── main.dart
├── utils.dart
├── common_memory_image.dart
└── common_network_image.dart</code></pre>
    <ul>
        <li><code>main.dart</code>: Entry point of the application.</li>
        <li><code>utils.dart</code>: Contains utility functions and extensions.</li>
        <li><code>common_memory_image.dart</code>: Widget for displaying images from memory.</li>
        <li><code>common_network_image.dart</code>: Widget for displaying network images.</li>
    </ul>
    <h2 id="dependencies">Dependencies</h2>
    <ul>
        <li><a href="https://flutter.dev">Flutter</a></li>
        <li><a href="https://pub.dev/packages/hive">Hive</a></li>
        <li><a href="https://pub.dev/packages/http">Http</a></li>
        <li><a href="https://pub.dev/packages/cached_network_image">Cached Network Image</a></li>
        <li><a href="https://pub.dev/packages/flutter_svg">Flutter SVG</a></li>
        <li><a href="https://pub.dev/packages/lottie">Lottie</a></li>
    </ul>
    <p>Add these dependencies to your <code>pubspec.yaml</code> file.</p>
    <h2 id="contributing">Contributing</h2>
    <p>Contributions are welcome! Please follow these steps:</p>
    <ol>
        <li>Fork the repository.</li>
        <li>Create a new branch.</li>
        <li>Make your changes.</li>
        <li>Commit and push your changes.</li>
        <li>Create a pull request.</li>
    </ol>
    <h2 id="license">License</h2>
    <p>This project is licensed under the MIT License - see the <a href="LICENSE">LICENSE</a> file for details.</p>
</body>
</html>
