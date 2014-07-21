import System.IO
import System.Process
import System.Exit
import Text.Regex.PCRE
import Control.Monad
-- import Debug.Trace

data ConfigEntry    = ConfigEntry {iface::String, srcPort::String, lxcName::String, dstPort::String} deriving (Show)
data ContainerEntry = ContainerEntry {name::String, ipv4::String} deriving (Show)

main = do
  config <- readFile "./lxc-bind.conf"
  let configEntries = parseConfig (lines config)
  print configEntries
  ls <-readProcess "lxc-ls" ["--fancy", "--fancy-format name,ipv4"] ""
  let containerEntries = parseLs (lines ls)
  print containerEntries
  let rules = mapRules configEntries containerEntries
  print rules
  return ()

parseConfig::[String] -> [ConfigEntry]
parseConfig = foldl (\list line -> case line =~ "^([\\w\\d_-]+):(\\d+)\\s*>\\s*([\\w\\d_-]+)(?::(\\d+))?(?:\\s*#.*)?$" of 
  [[_, _iface, _srcPort, _lxcName, ""]]       -> ConfigEntry _iface _srcPort _lxcName _srcPort : list
  [[_, _iface, _srcPort, _lxcName, _dstPort]] -> ConfigEntry _iface _srcPort _lxcName _dstPort : list
  _                                           -> list) []

parseLs::[String] -> [ContainerEntry]
parseLs = foldl (\list line -> case line =~ "^([\\w\\d_-]+)\\s+((?:\\d{1,3}\\.?){4})$" of
  [[_, _name, _ipv4]]       -> ContainerEntry _name _ipv4 : list
  _                         -> list) []

mapRules::[ConfigEntry] -> [ContainerEntry] -> [[String]]
mapRules = zipWith (\config container -> if iface config == "any" then
  ["-t nat", "-A lxc-bind", "-p tcp", "--dprot " ++ srcPort config, "-j DNAT", "--to "++ipv4 container++":" ++dstPort config] else
  ["-t nat", "-A lxc-bind", "-i " ++ iface config, "-p tcp", "--dprot " ++ srcPort config, "-j DNAT", "--to "++ipv4 container++":" ++dstPort config])
