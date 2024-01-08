when not defined(js):

    import std/paths, os, sequtils, strutils, strformat, options, json

    export paths, os

    type
        strictdir*  = distinct Path
        strictfile* = distinct Path
        filename*   = object
          ext*      : string
          stem*     : string

    proc `$`*(self: strictfile | strictdir): string =
        return string(self)

    proc `%`*(self: strictfile | strictdir): JsonNode =
        return %string(self)

    proc `$`*(self: filename): string = 
      self.stem & 
        (
          if self.ext != "":
            "." & self.ext
          else: ""
        )

    proc newStrictFile*(
                          path                      : string, 
                          mkIfNotExist              = false,
                          content                   = "",
                          allowed_ext : seq[string] = @[],
                    ) : tuple[ok:bool, err:string, val:Option[strictfile]] =  
        if allowed_ext.len > 0:
            let (dir,name,file_ext) = os.splitFile path 
            if file_ext == "":
                return (false, fmt"""Path "{path}" does not have a valid extension! Allowed extensions include :{allowed_ext}""", none(strictfile))
            
            let file_ext_no_dot = file_ext.toLower.replace(".", "")
            if file_ext_no_dot notin allowed_ext.mapIt(it.toLower.replace(".", "")):
                return (false, fmt"""Path "{path}" does not have a valid extension! Allowed extensions include :{allowed_ext}""", none(strictfile))

        if not path.fileExists:
            if mkIfNotExist:
                writeFile(path,content)
                return (true, "", some(strictfile(path)))
            else:
                return (false, "File not found: " & path, none(strictfile))
        return (true, "", some(strictfile(path)))

    proc newStrictDir*(
                          path         : string, 
                          mkIfNotExist = false,
                    ) : tuple[ok:bool, err:string, val:Option[strictdir]] = 
        if not path.dirExists:
            if mkIfNotExist:
                createDir(path)
                return (true, "", some(strictdir(path)))
            else:
                return (false, "Directory not found: " & path, none(strictdir))
        return (true, "", some(strictdir(path)))

    proc `f`*(self: string):filename = 
      let (dir,name,file_ext) = os.splitFile self 
      return filename(ext:file_ext, stem:name)

    # newStrictDir("...") / "..." -> strictdir
    proc `/`*(head: strictdir, tail: string ): tuple[ok:bool, err:string, val:Option[strictdir]]     = newStrictDir($head / tail)
    
    # newStrictDir("...") / f"my_file.text"  -> strictfile
    # newStrictDir("...") / f"my_file"       -> strictfile
    proc `/`*(head: strictdir, tail: filename ): tuple[ok:bool, err:string, val:Option[strictfile] ] = newStrictFile($head / $tail)




