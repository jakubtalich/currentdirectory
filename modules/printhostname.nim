import options

when defined(freebsd): # This is for FreeBSD (tested on 14.1)
  const HOST_NAME_MAX: csize_t = 255
  proc getHostname(name: cstring, len: csize_t): int32 {.cdecl, importc: "gethostname", header: "<unistd.h>".}
else:
  when defined(solaris): # This is for Solaris/Illumos (tested on OmniOS r151050 and Solaris 11.4 CBE)
    const HOST_NAME_MAX: csize_t = 255
  else: # This is for POSIX - Linux (tested on Fedora 40)
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
