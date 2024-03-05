// Include the PCapture-Lib which contains the arrayLib class.
IncludeScript("pcapture-lib/SRC/pcapture-lib")


// Initialize a new arrayLib instance with a range of integers from 1 to 10.
local arr = arrayLib.new(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

// Print the initial array to the console.
printl(arr) // output: "Array: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]"


// Remove the last element from the array (i.e., number 10).
arr.pop()

// Add a string "test" at the end of the array.
arr.append("test")

// Print the updated array to the console.
printl(arr) // output: "Array: [1, 2, 3, 4, 5, 6, 7, 8, 9, test]"


// Check if the array contains the string "test" and print the result.
printl(arr.find("test")) // output: "true"

// Find the index of "test" in the array and remove it.
arr.remove(arr.search("test"))

// Check again if the array contains "test" and print the result.
printl(arr.find("test")) // output: "false"

/* 
    Note: the "find()" method is cheaper, but it only returns bool, whether the item itself is in the array
*/


// Initialize a second array with a set of numbers.
local arr2 = arrayLib.new(3, 6, 1, 4, 66, 999, 11, 1)

// Extend the first array with the second array.
arr.extend(arr2)

// Print the combined array to the console.
printl(arr) // output: "Array: [1, 2, 3, 4, 5, 6, 7, 8, 9, 3, 6, 1, 4, 66, 999, 11, 1]"


// Create a new array with unique elements from the combined array and sort it.
local uniqueSortedArray = arr.filter(function(index, item, arr) {
    // Only include elements that don't have a duplicate in the array.
    return arr.search(item) == null
}).sort()


// Print the sorted array of unique elements to the console.
printl(uniqueSortedArray) // output: "Array: [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 66, 999]"