<div align="center">
<img src="other\logo.png" alt="Logo" width="660" height="350">

<h2 align="center">
    Unleash the Full Potential of Portal 2 Scripting with PCapture-Lib!
</h2>
</div>

![version](https://img.shields.io/badge/Pcapture--Lib-v3.0--Stable-informational)

**PCapture-Lib v3.0 is a groundbreaking VScripts library for Portal 2, empowering modders to create truly innovative and immersive gameplay experiences.**  It offers a most powerful suite of tools and enhancements, simplifying complex scripting challenges and allowing you to focus on bringing your creative vision to life. Whether you're a seasoned modder or just starting out, PCapture-Lib will elevate your mod projects to the next level.

# Killer Features

* **Advanced Ray Tracing with Portal Support:** Seamlessly integrate portal interactions into your raycasts with `TracePlus.PortalBbox` (precise) and `TracePlus.PortalCheap` (fast). This game-changing feature opens up a world of possibilities for portal-based mechanics, previously unattainable with standard VScripts.

* **Optimized Bounding Box TraceCasting:** Perform highly efficient collision detection with `TracePlus.Bbox`, utilizing advanced techniques like segment-based search, entity filtering and caching, and optional binary refinement. This ensures smooth performance even in complex map scenarios.

* **Powerful `CBaseEntity` Wrapper:** The `pcapEntity` class, accessible through `entLib`, provides an extensive set of methods for manipulating entity properties, controlling animations, handling sounds, managing outputs and inputs, and much more. This dramatically simplifies entity scripting and allows for advanced entity control.

* **Asynchronous Event Scheduling:** The `ActionScheduler` module offers a robust event scheduling system with support for delayed actions, intervals, and asynchronous operations using the `yield` keyword. This allows for more flexible and responsive scripting compared to standard VScripts mechanisms.

* **Enhanced Data Structures:** Leverage powerful data structures like `ArrayEx`, `List`, and `AVLTree` from the `IDT` module to manage and manipulate data efficiently. These additions provide significant improvements over standard VScripts arrays and offer more flexibility for complex data handling.

* **Comprehensive Math Module:** Utilize a rich set of mathematical functions and objects, including quaternions (`Quaternion`), matrices (`Matrix`), linear interpolation (`lerp`), and easing functions (`ease`), for complex calculations and animations.

* **File Operations and Utilities:** Streamline file reading and writing with the `File` class and access various utility functions for tasks like logging, player hooks, portal management, and more.

* **Entity Script Animations:** Easily create smooth animations for entity alpha (opacity), color and etc. using functions like `AlphaTransition`, `ColorTransition`, `PositionTransition`... Real-time animation variants are also available for more dynamic control.

* **HUD Elements:** Create custom HUD elements like screen text (`ScreenText`) and instructor hints (`HintInstructor`) to provide feedback and guidance to players.

### And more! You can find the whole list [here](Short_Documentation.md)

# Getting Started

1. **Installation:** Copy the PCapture-Lib folder into your Portal 2 scripts directory (`portal2/scripts/vscripts`).

2. **Initialization:** Include the library in your VScripts using `IncludeScript("PCapture-Lib")` or `IncludeScript("PCapture-Lib/SRC/PCapture-Lib")`.

3. **Documentation:** Refer to the [documentation](Short_Documentation.md) for detailed information on each module and its functions. A quick reference guide is also available [link to short-dock].

# About

PCapture-Lib was originally developed as part of the Project Capture modification, but it has evolved into a standalone library to benefit the entire Portal 2 modding community. By addressing common scripting challenges and providing powerful tools, PCapture-Lib aims to empower modders of all levels to create more ambitious and innovative maps.

## Contributing

Contributions to PCapture-Lib are welcome and encouraged! If you encounter any bugs, have feature requests, or would like to contribute code improvements, please open an issue or submit a pull request on the [GitHub repository](https://github.com/iaVashik/PCapture-LIB/).

## License

This library was created by [laVashik](https://lavashik.lol/). **Credit is required when using this library in your projects**

Licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.