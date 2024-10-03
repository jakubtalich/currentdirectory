import os, net, options, ../modules/printhostname

proc printVersion() =
  const versionFile = staticRead("../VERSION")
  echo versionFile

proc printLicense() =
  const licenseFile = staticRead("../LICENSE")
  echo licenseFile

proc printHelp() =
  const helpFile = staticRead("../HELP")
  echo helpFile

proc getCurrentIPv4(): string =
  var socket = newSocket()
  socket.connect("example.com", Port(80))
  let localAddr = socket.getLocalAddr()
  socket.close()
  return localAddr[0]

proc main() =
  let args = commandLineParams()
  if "--version" in args:
    printVersion()
  elif "--license" in args:
    printLicense()
  elif "--help" in args:
    printHelp()
  else:
    echo "📂 You are currently in: ", getCurrentDir()
    echo "🪐 Hostname: ", printHostname().get
    echo "🌐 IP address: ", getCurrentIPv4()

main()
