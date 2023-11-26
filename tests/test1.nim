# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import pathutils


# Basic tests
### Path tests
test "Recognizes a strictpath exists",
  check newStrictPath("test_file.txt") is strictpath

test "Recognizes a strictfile exists",
  check newStrictFile("test_file1.txt") is strictfile

test "Recognizes a strictdir exists",
  check newStrictDir("test_dir") is strictdir

### file tests
test "Recognizes a strictfile is a file":
  check f"test_file.txt" is file

test "Validates file has correct extension":
  let file = f"image.png"
  check file.ext == "png"


### Tests with / proc
test "Recognizes a strictdir with / proc":
  check newStrictDir("test_dir") / "inner_test_dir"  is strictdir

test "Recognizes a strictfile with / proc":
  check newStrictDir("test_dir") / f"test_file_in_test_dir.txt"  is strictfile

# Error tests
test "Recognizes a bade file name":
  expect BadFileNameError:
    discard f"rjjreojr"

test "Recognizes a strictpath doesn't exist":
  expect PathNotFoundError:
    discard newStrictPath("hjewhjke.txt") 

test "Recognizes a strictfile doesn't exist":
  expect PathNotFoundError:
    discard newStrictFile("hjewhjke.txt")

test "Recognizes a strictdir with / proc doesn't exist":
  expect PathNotFoundError:
    discard newStrictDir("test_dir") / "inner_test_dirr"

test "Recognizes a strictdir doesn't exist":
  expect PathNotFoundError:
    discard newStrictDir("hjewhjke")

test "Recognizes a path not in allowed extensions":
  expect BadExtentionError:
    discard newStrictFile("test_file.txt", allowed_ext = @["png"])

test "Converts file to string correctly":
  let file = f"sample.txt"
  check $file == "sample.txt"


