# pathutils
`nimble install pathutils`

## Overview
`pathutils` extends the capabilities of std/paths to offer strict definitions for paths, file paths and dir paths.
If a path is not valid, an exception is raised. 
This allows you to fail fast and handle errors early.

## Features
- **Strict Type Definitions**: `strictpath`, `strictdir`, and `strictfile` ensure clear distinctions between different types of file system entities.
- **Error Handling**: Custom exceptions like `PathNotFoundError`, `BadExtentionError`, and `BadFileNameError` for better error management.
- **Path Manipulation**: Borrows the `/` for manipulating and combining paths, files, and directories.
- **File and Directory Creation**: Functions to create files and directories, with options to handle non-existent paths.

## Usage

### Types
- `strictpath`: Represents a path, either a file or a directory that must exist.
- `strictdir` : Represents a directory path that must exist.
- `strictfile`: Represents a file that must exist.
- `filename`  : Represents a file name, with functions to extract the name and extension.

### Procedures
- `newStrictPath(path: string, mkIfNotExist: bool = false): strictpath`
- `newStrictFile(path: string, mkIfNotExist: bool = false, content: string = "", allowed_ext: seq[string] = @[]): strictfile`
- `newStrictDir(path: string, mkIfNotExist: bool = false): strictdir`
- `f(string): filename`: Converts a string to a `filename` type
- Overloaded `/` operator for combining `strictpath`, `strictdir`, `strictfile` and `filename` types with strings or each other.

### Error Handling
Custom exceptions are raised for various error conditions, such as non-existent paths or invalid file extensions.

### Examples
```nim
import pathutils

# if any of the paths do not exist, an exception is raised
let myStrictPath = newStrictPath(os.getCurrentDir() & r"\example_file.txt" )
let myStrictFile = newStrictFile(os.getCurrentDir() & r"\example_file.txt" )
let myStrictDir  = newStrictDir(os.getCurrentDir()  )

# if the file does not exist, an exception is raised
# If the file does exist, it returns a strictfile type
echo myStrictDir / f"example_file.txt" 

echo newStrictPath(r"C:\Program Files") / "nodejs" # If the path does not exist, an exception is raised

echo $myPath # prints the path as a string

echo f"example_file.txt".ext  # prints the file extension "txt"
echo f"example_file.txt".stem # prints the file stem "example_file"
echo $f"example_file.txt"     # prints the file path as a string "example_file.txt"
```

### Extension

This can be really useful when you wish to define your own StrictFile types.

Now you know with confidence that whatever file myThing is acting on is of the file type you need and actually exists at compile time.

```nim
type strictimg = distinct string

proc newStrictImg(path:string) : strictimg =
  try:
    discard newStrictFile(path, allowed_ext= @["png", "jpg", "jpeg", "gif"])
  finally:
    return path.strictimg

let p = newStrictImg(r"C:\Users\...\Screenshot 2023-11-23 181938.png")
echo p.string

proc myThing(t: strictimg) = 
  echo t.string

myThing(p)

```

## Testing
To run tests, use `nimble test`. The test suite covers a range of scenarios including path recognition, file and directory existence, error handling, and path concatenation.

## License
`pathutils` is released under the MIT License. See the LICENSE file for more details.

