
#[demo-fmt:
[2024-02-12 16:33:39:295 INFO] Running AutoCompaction...

[2024-02-12 16:37:25:583 INFO] Player connected: litlighilit, xuid: 2535424657680505
[2024-02-12 16:37:38:094 INFO] Player Spawned: litlighilit xuid: 2535424657680505, pfid: 585d8f4c62e4633e
[2024-02-12 16:37:57:839 INFO] Player disconnected: litlighilit, xuid: 2535424657680505, pfid: 585d8f4c62e4633e
]#

const Version* = "1.1.0"
const
  DTFormat = "yyyy-MM-dd HH:mm:ss:fff"
  SepBeforeUname = ','
import std/times
import std/strutils
import std/parseutils
import std/logging
from std/os import `/`, removeFile

type
  User = string
  Op = enum
    Conn = "+"
    Disconn = "-"

template toStr(u: User, op: Op): string = $u & ' ' & $op
proc parseUser(s: string, start=0): User =
  var res: string
  let resLen = parseUntil(s, res, SepBeforeUname, start)
  if resLen == 0: warn "can't parseUser user name in Line: ", s
  User(res.strip(chars={' ','\t'}))

type Date = tuple
  year: int
  mon: Month
  day: MonthDayRange

proc toDate(dt: DateTime): Date = (dt.year, dt.month, dt.monthday)
proc `$`(d: Date): string = $d.year & '-' & $ord(d.mon) & '-' & $d.day

proc toTimeStr(dt: DateTime): string = dt.format"HH:mm"


type Filter* = object
  nowDate: Date
  outFilePath: string
  outDir: string
  inFile: File

proc update*(filt: var Filter, date: Date){.inline.} =
  filt.nowDate = date
  let fname = $filt.nowDate & ".log"
  filt.outFilePath = filt.outDir / fname
  info "update log filename: ",fname
proc initFilter*(srcFilePath: string, destDir:string): Filter =
  result.inFile = open srcFilePath
  result.outDir = destDir
  result.update now().toDate

proc `=destroy`*(filt: Filter) =
  filt.inFile.close()

proc process*(filt: var Filter)

proc appendLine*(filt: Filter, line: string) =
  var f = open(filt.outFilePath, fmAppend)
  f.writeLine line
  f.close()

when isMainModule:
  import std/parseopt
  proc err(s: string)=
    # differ from logging.eror
    # to stderr and exit with failure code
    stderr.writeLine s
    quit QuitFailure
  template priHelp=
    echo """
usage:
  <this> filepath [-d,--dest-dir DIR] [-L,--no-log]
  <this> -h,--help
  <this> -v,--version
"""
    quit()
  template priVersion =
    echo Version
    quit()
  var filepath: string
  var destDir = "."
  var log = true
  var logger: Logger
  for kind, key, val in getopt(shortNoVal={'h','L'}, longNoVal = @["help","no-log"]):
    case kind
    of cmdEnd: assert false # Doesn't happen with getopt()
    of cmdArgument:
      if filepath != "": err "more than one file path is given"
      filepath = key
    of cmdLongOption, cmdShortOption:
      case key
      of "d", "dest-dir": destDir=val
      of "L", "no-log": log=false
      of "h", "help": priHelp()
      of "v", "version": priVersion()
  
  if filepath=="":  err "please pass file path as arg"
  if log:
    logger = newConsoleLogger(fmtStr="$appname::[$date $time]-$levelname: ")
    addHandler logger

  var filt = initFilter(filepath, destDir)
  try:
    filt.process()
  except CatchableError:
    error "process file abort due to ", $(getCurrentException()[]),": ",getCurrentExceptionMsg()

proc process(filt: var Filter) =
  for line in filt.inFile.lines:
    if line.len==0: continue
    if line[0] == '[':
      var arr = line.split(']', 1)
      let preStr=arr[0][1..^1]
      var info=arr[1]
      arr = preStr.rsplit(' ', 1)
      let timeStr=arr[0]
      let msg=arr[1]
      if msg != "INFO": continue
      let dt = timeStr.parse DTFormat
      let date = dt.toDate
      if date > filt.nowDate:
        filt.update date

      info = info.strip(chars={' '}, trailing=false)
      let
        conn = "Player connected:"
        disconn = "Player disconnected:"
      var
        user: User
        op: Op 
      if info.startsWith conn:
        op = Conn
        user = parseUser(info, conn.len)
      elif info.startsWith disconn:
        op = Disconn
        user = parseUser(info, disconn.len)
      else: continue

      filt.appendLine dt.toTimeStr & ' ' & toStr(user, op)
      

