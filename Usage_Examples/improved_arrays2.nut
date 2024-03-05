// Include the PCapture-Lib which provides the arrayLib class.
IncludeScript("pcapture-lib/SRC/pcapture-lib")


// Create a new array using arrayLib with a variety of different data types.
local arr = arrayLib.new("test", GetPlayer(), self, printl, 11, 15)


// Print the contents of the array to the console, showcasing the array's diversity.
printl(arr) // output: "Array: [test, ([1] player), ([0] worldspawn), (function : 0x03E1BBC0), 11, 15]"

// Access and print the second element of the array, which is expected to be the player.
printl(arr.get(1)) // output: "([1] player)"

// Attempt to access and print the element at index 10, which does not exist, returns null as a default value.
printl(arr.get(10)) // output: "(null : 0x00000000)"

// Attempt to access the element at index 10 with a default return value of 'false' instead of null.
printl(arr.get(10, false)) // output: "false"


// Join all elements of the array into a single string, separated by a comma and a space.
local arr2str = arr.join(", ")

// Print the resulting string to the console.
printl(arr2str) // output: "test, ([1] player), ([0] worldspawn), (function : 0x03E1BBC0), 11, 15"

// Print the type of the 'arr2str' variable to verify it is a string.
printl(type(arr2str)) // output: "string"