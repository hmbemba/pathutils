# pathutils: Nim Library for Enhanced Path Handling

## Overview
`pathutils` is a Nim library designed to provide enhanced functionality for handling file paths, directories, and files. It extends the capabilities of standard path and file operations, offering strict type definitions and robust error handling. This library is ideal for developers who require precise control over file system operations in their Nim applications.

## Features
- **Strict Type Definitions**: `strictpath`, `strictdir`, and `strictfile` ensure clear distinctions between different types of file system entities.
- **Error Handling**: Custom exceptions like `PathNotFoundError`, `BadExtentionError`, and `BadFileNameError` for better error management.
- **Path Manipulation**: Convenient procedures for manipulating and combining paths, files, and directories.
- **File and Directory Creation**: Functions to create files and directories, with options to handle non-existent paths.

## Installation
To install `pathutils`, add the following to your Nimble file:
```nim
# Add this to your .nimble file
requires "pathutils >= 0.1.0"
```
Then run `nimble install` to install the library.

## Usage

### Types
- `strictpath`: Represents a strict path, either a file or a directory.
- `strictdir`: Represents a strict directory path.
- `strictfile`: Represents a strict file, with `name` and `ext` fields.

### Procedures
- `newStrictPath(path: string, mkIfNotExist: bool = false): strictpath`
- `newStrictFile(path: string, mkIfNotExist: bool = false, content: string = "", allowed_ext: seq[string] = @[]): strictfile`
- `newStrictDir(path: string, mkIfNotExist: bool = false): strictdir`
- `f(string): file`: Converts a string to a `file` type, ensuring it has a file extension.

### Path Concatenation
- Overloaded `/` operator for combining `strictpath`, `strictdir`, and `strictfile` types with strings or each other.

### Error Handling
Custom exceptions are raised for various error conditions, such as non-existent paths or invalid file extensions.

## Testing
To run tests, use `nimble test`. The test suite covers a range of scenarios including path recognition, file and directory existence, error handling, and path concatenation.

## Contributing
Contributions to `pathutils` are welcome. Please ensure that your contributions adhere to the following guidelines:
- Follow Nim's coding conventions.
- Write tests for new features or bug fixes.
- Document new code appropriately.

## License
`pathutils` is released under the MIT License. See the LICENSE file for more details.

---

This README provides a brief overview of the `pathutils` library. For detailed documentation and examples, refer to the official documentation.