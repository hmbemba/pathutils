# pathutil

## Overview
`pathutils` extends the capabilities of std/paths to offer a type of strict definitions for paths, file paths and dir paths.
If a path is not valid, an exception is raised. This allows you to fail fast and handle errors early.

## Features
- **Strict Type Definitions**: `strictpath`, `strictdir`, and `strictfile` ensure clear distinctions between different types of file system entities.
- **Error Handling**: Custom exceptions like `PathNotFoundError`, `BadExtentionError`, and `BadFileNameError` for better error management.
- **Path Manipulation**: Borrows the `/` for manipulating and combining paths, files, and directories.
- **File and Directory Creation**: Functions to create files and directories, with options to handle non-existent paths.

## Installation
To install `pathutils`, add the following to your Nimble file:
```nim
# Add this to your .nimble file
nimble install pathutils
```

## Usage

### Types
- `strictpath`: Represents a path, either a file or a directory that must exist.
- `strictdir` : Represents a directory path that must exist.
- `strictfile`: Represents a file that must exist.

### Procedures
- `newStrictPath(path: string, mkIfNotExist: bool = false): strictpath`
- `newStrictFile(path: string, mkIfNotExist: bool = false, content: string = "", allowed_ext: seq[string] = @[]): strictfile`
- `newStrictDir(path: string, mkIfNotExist: bool = false): strictdir`
- `f(string): file`: Converts a string to a `file` type, ensuring it has a file extension.

### Path Concatenation
- Overloaded `/` operator for combining `strictpath`, `strictdir`, and `strictfile` types with strings or each other.

### Error Handling
Custom exceptions are raised for various error conditions, such as non-existent paths or invalid file extensions.

### Examples
```nim
import pathutils

# if any of the paths do not exist, an exception is raised
let myPath = newStrictPath(os.getCurrentDir() & "\example_file.txt" )
let myFile = newStrictFile(os.getCurrentDir() & "\example_file.txt" )
let myDir  = newStrictDir(os.getCurrentDir()  )

echo myDir / f"example_file.txt" # if the file does not exist, an exception is raised

echo newStrictPath("C:\Program Files") / "nodjs" # If the path does not exist, an exception is raised

echo $myPath # prints the path as a string

echo f"example_file.txt".ext # prints the file extension "txt"
echo f"example_file.txt".name # prints the file name "example_file"
echo $f"example_file.txt" # prints the file path as a string "example_file.txt"


```

## Testing
To run tests, use `nimble test`. The test suite covers a range of scenarios including path recognition, file and directory existence, error handling, and path concatenation.

## License
`pathutils` is released under the MIT License. See the LICENSE file for more details.

