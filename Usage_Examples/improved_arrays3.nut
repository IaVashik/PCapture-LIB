// Include the PCapture-Lib which provides the arrayLib class.
IncludeScript("pcapture-lib/SRC/pcapture-lib")

// Assuming 'arrayLib' is already included and initialized with some elements.
local myArray = arrayLib.new("apple", "banana", "cherry");

// Retrieve the element at index 1, which is "banana".
local element = myArray.get(1);
print(element); // output: "banana"

// Try to retrieve the element at index 5, which is out of bounds.
// Since the index is out of bounds, the default value "not found" is returned.
local notFoundElement = myArray.get(4, "not found");
print(notFoundElement); // output: "not found"