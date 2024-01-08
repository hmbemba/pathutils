# pathutils

## Installation

```
nimble install pathutils
```

## Overview

`pathutils` enhances the standard Nim `std/paths` module by introducing strict path types and robust error handling mechanisms. It is designed to enforce strict compliance with path definitions and to identify errors early in the development process.

## Key Features

- **Strict Path Types**: Introduces `strictdir` and `strictfile` types. These types let you ensure that the path to the dir or file exists at compile time 
- **Path Manipulation**: Borrows the `/` for manipulating and combining paths, files, and directories. - **File and Directory Creation**: Functions to create files and directories, with options to handle non-existent paths.
## Usage

### Types

- `strictdir`: A distinct path type for directories.
- `strictfile`: A distinct path type for files.
- `filename`: A type representing a file name, allowing extraction of stem and extension.

### Functions

- `newStrictFile`: Creates or validates a file path.
- `newStrictDir`: Creates or validates a directory path.
- `f`: Converts a string to a `filename` type.
- Overloaded `/` operator: Combines path types and strings for path manipulation.

### Error Handling

Custom exceptions are thrown for various scenarios such as non-existent paths or invalid file extensions, enhancing the robustness of path handling.

### Examples
#### Basics

```
import pathutils

# Create or validate paths; exceptions are thrown for non-existent paths
let myStrictDir  = newStrictDir("path/to/directory")
if not myStrictDir.ok:
  echo "handle error"

let dir_path = myStrictDir.val.get

# Combining paths using the `/` operator
echo myStrictDir / f"file.txt" 

# Printing path information
echo $myStrictFile
echo f"file.txt".ext  
echo f"file.txt".stem 
```

#### Real Use Case 
- One could create a proc that only takes a strictfile ensuring that it exists

```
import pathutils

proc newDB(file:strictfile) = 
  create_connection $strictfile
```

- Then users of that proc would need to make sure they're passing in a strictfile

```
import pathutils

let db_path = "path/to/db".newStrictFile
if not db_path.ok:
  echo "dang"
  quit()

let my_db = db_path.val.get.newDB
```

- If a user of your library doesn't check if the strictfile is ok the option will return none
```
import pathutils

let db_path = "path/to/db".newStrictFile

# "path/to/db" doesn't exist so val is a none(strictfile)
let my_db = db_path.val.get.newDB
```

#### Custom Extensions

Easily extend the library to create your own strict path types, ensuring files of specific filetypes exist.

```
type strictimg = distinct string

proc newStrictImg(path: string): tuple[ok:bool, err:string, val:Option[strictimg]] =
  let img = newStrictFile(path, allowed_ext=@["png", "jpg", "jpeg", "gif"])
  if not img.ok:
    (img.ok, img.err, none(strictimg))
  else:
    (img.ok, img.err, some(path.strictimg))

let myImage = newStrictImg("path/to/image.png")
echo $myImage.val.get

proc processImage(image: strictimg) = 
  echo $image

processImage(myImage)

```

## Testing

Run `nimble test` to execute the test suite, covering various scenarios like path validation, file and directory management, and error handling.

## License

`pathutils` is available under the MIT License. For more information, see the LICENSE file included with the distribution.