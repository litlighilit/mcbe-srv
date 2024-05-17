
import std/os
import std/parsecfg


let mcHome = getenv "MC_HOME"

let
  srvDir = mcHome/"bedrock-server/"
  #worldsDir = srvDir/"worlds"
  cfgFp = srvDir/"server.properties"


let dict = loadConfig cfgFp

let levelName = dict.getSectionValue("", "level-name")

echo levelName


