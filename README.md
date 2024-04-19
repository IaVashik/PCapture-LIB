<div align="center">
<img src="other\logo.png" alt="Logo"> <!-- width="660" height="350" -->

<h2 align="center">
    PCapture-Lib - The library that you need!
</h2>
</div>

![version](https://img.shields.io/badge/Pcapture--Lib-v2.0.0.stable-informational)

**PCapture-Lib is a comprehensive VScripts library for Portal 2 that empowers mappers to create sophisticated and engaging gameplay experiences.** It provides a wealth of features and enhancements, streamlining development and allowing you to focus on the creative aspects of your maps.

# Key Features
* **Advanced Math Utilities:**
  * Quaternion rotations for precise 3D orientation manipulation.
  * Versatile vector operations for calculations and transformations.
  * Comprehensive interpolation functions for smooth transitions and animations.
* **Enhanced Entity Interaction:**
  * The `pcapEntity` wrapper class extends the functionality of `CBaseEntity` with convenient methods for setting bounding boxes, retrieving AABBs, managing user data, and more.
  * Simplify entity manipulation with intuitive functions for setting properties, creating outputs, playing sounds, and handling parent-child relationships.
* **Precise and Powerful Ray Tracing:**
  * `BboxCast` functionality with accurate surface normal calculation for detailed collision detection.
  * Customizable trace settings to control ignore lists, entity priorities, and error tolerance.
  * Presets for common trace types, including traces from the player's eyes.
  * Unique support for portal tracing, allowing rays to pass through portals and interact with objects in different portal spaces.
* **Robust Event Scheduling:**
  * Schedule events with precise timing and control using the enhanced event system.
  * Create complex events composed of multiple actions and manage them efficiently.
  * Cancel events as needed to dynamically adjust gameplay logic.
* **Smooth Property Animations:**
  * Effortlessly create animations for color, alpha (opacity), position, and angles.
  * Choose between time-based or speed-based animations for fine-grained control.
* **Enhanced Data Structures:**
  * The `arrayLib` class provides an improved array implementation with additional methods for manipulation, searching, sorting, and conversion.
  * Utilize the `List` class for efficient insertion and deletion operations with doubly linked lists.
  * Maintain sorted collections and perform efficient searches with the `AVLTree` class, implementing self-balancing binary search trees.

**And much more to come!**

## Getting Started

PCapture-Lib is designed for ease of use. Simply include `pcapture-lib.nut` in your VScripts, and you'll have access to all the powerful features and classes it offers. Refer to the [full documentation](Documentation.md) for detailed information about each module, including usage examples and API references.

# About

PCapture-Lib originated from the Project Capture modification, aiming to provide a comprehensive set of tools for Portal 2 mappers. By offering solutions for complex scripting challenges while maintaining an intuitive interface, it enables mappers of all skill levels to create more ambitious and immersive maps.

## Contributing

Contributions to PCapture-Lib are welcome! Feel free to open issues for any bugs you find or features you would like to see added. Join us in making PCapture-Lib the ultimate VScripts library for Portal 2 mapping!

## License

This library was created by [laVashik](https://www.youtube.com/@laVashikProductions). Please give credit to laVashik when using this library in your projects! Licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.
