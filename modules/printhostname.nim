import options

when defined(freebsd):
  const HOST_NAME_MAX: csize_t = 255
  proc getHostname(name: cstring, len: csize_t): int32 {.cdecl, importc: "gethostname", header: "<unistd.h>".}
else:
  when defined(solaris):
    const HOST_NAME_MAX: csize_t = 255
  else:
    let HOST_NAME_MAX {.importc: "HOST_NAME_MAX", header: "<unistd.h>".}: csize_t
  proc getHostname(name: cstring, len: csize_t): int32 {.cdecl, importc: "gethostname", header: "<unistd.h>".}

proc printHostname*(): Option[TaintedString] =
  runnableExamples:
    import hostname, options
    let hostname1 = hostname().get
    let hostname2 = hostname().get(otherwise = TaintedString("example.com"))

  var buf = cast[cstring](alloc0(HOST_NAME_MAX + 1))
  if 0 == getHostname(buf, HOST_NAME_MAX):
    result = some(TaintedString($buf))
  else:
    result = none[TaintedString]()
  dealloc(buf)
