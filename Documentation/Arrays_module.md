# PCapture-ArrayLib

Enhanced arrays module.

### arrayLib.new(...)

Create a new arrayLib instance from arguments.

```
local arr = arrayLib.new(1, 2, 3)
```

- `...` (any): The values for the array.
- Returns: The new arrayLib instance.

>Syntax sugar: 
>`local arr = arrayLib([1, 2, 3])`

### arrayLib.append(val)

Append a value to the array.

```
arr.append(4)
```

- `val` (any): The value to append.
- Returns: The new array length.

### arrayLib.apply(func)

Apply a function to each element.

```
arr.apply(function(val) return val * 2)
```

- `func` (function): The function to apply.

### arrayLib.clear()

Clear the array and table.

```
arr.clear()
```

### arrayLib.extend(other)

Extend the array with another array.

```
arr.extend([4, 5, 6])
```

- `other` (array|arrayLib): The array to extend from.

### arrayLib.filter(func)

Filter the array by a predicate function.

```
local filteredArray = arr.filter(function(idx, val) return val > 2 end)
```

- `func` (function(idx, val, newArray)): The predicate function.
- Returns: The filtered array.

### arrayLib.find(match)

Check if the array contains a value.

```
local found = arr.find(3)
```

- `match` (any): The value to find.
- Returns: Whether the value is found.

### arrayLib.search(match)

Search for a value in the array.

```
local idx = arr.search(function(val) return val > 2 end)
```

- `match` (any|function): The value or predicate to search for.
- Returns: The index of the match or null.

### arrayLib.insert(idx, val)

Insert a value into the array.

```
arr.insert(1, "a")
```

- idx (int): The index to insert at.
- val (any): The value to insert.

### arrayLib.len()

Get the array length.

```
local length = arr.len()
```

- Returns: The array length.

### arrayLib.map(func)

Map the array to a new array via a function.

```
local mappedArray = arr.map(function(val) return val * 2 end)
```

- `func` (function): The mapping function.
- Returns: The mapped array.

### arrayLib.pop()

Pop a value off the end of the array.

```
local value = arr.pop()
```

- Returns: The popped value.

### arrayLib.push(val)

Append a value to the array.

```
arr.push(4)
```

- `val` (any): The value to append.

### arrayLib.remove(idx)

Remove an element by index.

```
arr.remove(1)
```

- idx (int): The index to remove.

### arrayLib.resize(size, fill = null)

Resize the array.

```
arr.resize(5, 0)
```

- `size` (int): The new size.
- `fill` (any, optional): The fill value for new slots.

### arrayLib.reverse()

Reverse the array in-place.

```
arr.reverse()
```

- Returns: The reversed array.

### arrayLib.slice(start, end = null)

Slice a portion of the array.

```
local slicedArray = arr.slice(1, 3)
```

- `start` (int): The start index.
- `end` (int, optional): The end index.
- Returns: The sliced array.

### arrayLib.sort(func = null)

Sort the array.

```
arr.sort()
```

- `func` (function, optional): Optional compare function.
- Returns: The sorted array.

### arrayLib.top()

Get the last element.

```
local lastElement = arr.top()
```

- Returns: The last element.

### arrayLib.join(joinstr = "")

Join the array into a string.

```
local joinedString = arr.join(", ")
```

- `joinstr` (string, optional): The separator string.
- Returns: The joined string.

### arrayLib.get(idx, defaultVal = null)

Retrieve the element at the specified index in the array.

```
local element = arr.get(0)
```

- `idx` (integer): The index of the element to retrieve.
- `defaultVal` (any, optional): Optional default value to return if the index is out of bounds. Defaults to null.
- Returns: The element at the specified index or the default value if the index is out of bounds.

### arrayLib.totable(recreate = false)

Convert the array to a table.

```
local table = arr.totable()
```

- `recreate` (boolean, optional): Whether to recreate the table.
- Returns: The table representation.