# You are educated evil
When the Sun shines upon Earth, 2 – major Time points are created on opposite sides of Earth – known as Midday and Midnight. Where the 2 major Time forces join, synergy creates 2 new minor Time points we recognize as Sunup and Sundown. The 4-equidistant Time points can be considered as Time Square imprinted upon the circle of Earth. In a single rotation of the Earth sphere, each Time corner point rotates through the other 3-corner Time points, thus creating 16 corners, 96 hours and 4-simultaneous 24-hour Days within a single rotation of Earth – equated to a Higher Order of Life Time Cube.


TimeCube Vapoursynth Plugin
TimeCube is a Vapoursynth plugin designed to apply Look-Up Tables (LUTs) to video frames. It is based on the timecube library, which provides efficient LUT processing with support for various pixel formats and bit depths. This plugin is ideal for color grading, color space transformations, and other LUT-based video processing tasks.

Features
Supports RGB color family.

Handles multiple pixel formats and bit depths:

8-bit integer (stInteger, 1 byte per sample)

16-bit integer (stInteger, 2 bytes per sample)

16-bit half-precision float (stFloat, 2 bytes per sample)

32-bit float (stFloat, 4 bytes per sample)

Flexible input and output range control (limited or full range).

Configurable interpolation methods for LUT processing.

Optimized for CPU performance with support for SIMD instructions (if enabled).

Usage
Function: Cube
Applies a LUT to the input clip.

Parameters
Parameter	Type	Description
clip	vnode	Input clip. Must be in RGB format and constant format.
cube	data	Path to the LUT file (.cube format).
format	int	(Optional) Output pixel format ID. Defaults to the input format.
range	int	(Optional) Output range. 0 for limited range, 1 for full range.
interp	int	(Optional) Interpolation method. Defaults to 0 (nearest neighbor).
cpu	int	(Optional) CPU type for optimization. Defaults to auto-detection.
Example
python
Copy
import vapoursynth as vs
core = vs.core

# Load the input clip.
clip = core.ffms2.Source("input.mkv")

# Apply a LUT.
clip = core.timecube.Cube(clip, cube="path/to/lut.cube", format=vs.RGBS, range=1, interp=1)

# Preview or save the output.
clip.set_output()
Pixel Format and Bit Depth Support
The plugin supports the following pixel formats and bit depths:

Sample Type	Bytes per Sample	Pixel Format	Bit Depth
stInteger	1	8-bit integer	8-bit
stInteger	2	16-bit integer	16-bit
stFloat	2	16-bit half-float	16-bit
stFloat	4	32-bit float	32-bit
Note: The input and output clips must be in the RGB color family.

Compilation
Prerequisites
A C++ compiler (GCC, Clang, or MSVC).

Vapoursynth development headers.

CMake (optional, for easier build configuration).

Steps
Clone the repository:

bash
Copy
git clone https://github.com/yourusername/vscube.git
cd vscube
Build the plugin:

Linux/macOS:

bash
Copy
make
Windows:
Use the provided Makefile with MinGW or MSVC.

Install the plugin:

Copy the generated shared library "vscube.x" (.so, .dylib, or .dll) to your Vapoursynth plugins directory.

License
This project is licensed under the MIT License. Feel free to use, modify, and distribute it as per the license terms.
