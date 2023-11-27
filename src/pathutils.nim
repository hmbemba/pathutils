import std/paths, os, sequtils, strutils, strformat, options

export paths, os


type
    strictpath* = distinct Path   
    strictdir*  = distinct Path
    strictfile* = distinct Path
    file*       = object
      ext*      : string
      name*     : string


    PathNotFoundError* = object of ValueError
    BadExtentionError* = object of ValueError
    BadFileNameError* = object of ValueError

proc `$`*(self: strictfile | strictpath | strictdir): string =
    return string(self)

proc `$`*(self: file): string = 
  self.name & 
    (
      if self.ext != "":
        "." & self.ext
      else: ""
    )

proc has_a_file_ext*(path: string): bool = 
    if path.split(".").len > 1:
        true
    else:
        false

proc get_file_ext*(path: string, with_dot = true): Option[string] =
    if path.has_a_file_ext:
        let dot = 
          if with_dot: "."
          else: ""
        some(dot & path.split(".")[1])
    else:
        none(string)

proc newStrictPath*(
                    path                      : string, 
                    mkIfNotExist              = false ,
                ) : strictpath =
  if path.fileExists:
    return strictpath(path)
  if path.dirExists:
    return strictpath(path)
  if mkIfNotExist:
    if path.has_a_file_ext:
      writeFile(path, "")
    else:
      createDir(path)
    return strictpath(path)
  else:
    raise newException(PathNotFoundError, "Path not found: " & path)

proc newStrictFile*(
                    path                      : string, 
                    mkIfNotExist              = false,
                    content                   = "",
                    allowed_ext : seq[string] = @[],
                ) : strictfile =    
    if allowed_ext.len > 0:
        let file_ext_get = path.get_file_ext(with_dot=false)#.get.toLower
        if file_ext_get.isNone:
            raise newException(BadExtentionError,fmt"""Path "{path}" does not have a valid extension! Allowed extensions include :{allowed_ext}""")
        
        let file_ext = file_ext_get.get.toLower
        if file_ext notin allowed_ext.mapIt(it.toLower).mapIt(it.replace(".", "")):
            raise newException(BadExtentionError,fmt"""Path "{path}" does not have a valid extension! Allowed extensions include :{allowed_ext}""")

    if not path.fileExists:
        if mkIfNotExist:
            writeFile(path,content)
            return strictfile(path)
        else:
            raise newException(PathNotFoundError, "File not found: " & path)
    return strictfile(path)

proc newStrictDir*(
                    path                      : string, 
                    mkIfNotExist              = false,
                ) : strictdir =
    if not path.dirExists:
        if mkIfNotExist:
            createDir(path)
            return strictdir(path)
        else:
            raise newException(PathNotFoundError, "Directory not found: " & path)
    return strictdir(path)

proc `f`*(self: string):file = 
  if "/" in self:
    raise newException(BadFileNameError, "File name cannot contain '/'")
  if "\\" in self:
    raise newException(BadFileNameError, "File name cannot contain '\\'")
  if not self.has_a_file_ext:
    return file(name:self)
  return file(ext:self.get_file_ext(with_dot=false).get, name:self.split(".")[0])

# newStrictPath("...") / newStrictPath("...")
proc `/`*(head, tail: strictpath ): strictpath        = newStrictPath($head / $tail)

# newStrictDir("...") / "..."
proc `/`*(head: strictdir, tail: string ): strictdir   = newStrictDir($head / tail)

# newStrictDir("...") / f"my_file.text" 
proc `/`*(head: strictdir, tail: file ): strictfile    = newStrictFile($head / $tail)

# newStrictPath("...") / "..."
proc `/`*(head: strictpath, tail: string ): strictpath = newStrictPath($head / tail)

# newStrictPath("...") / f"my_file.text"
proc `/`*(head: strictpath, tail: file ): strictfile   = newStrictFile($head / $tail)


