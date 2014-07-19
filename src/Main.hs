import System.IO (readFile)
import Text.Regex.PCRE
import Debug.Trace
-- import Control.Monad
-- import System.Environment (getArgs)
-- import System.Process (createProcess, waitForProcess, proc)
-- import System.Exit (ExitCode(..))

data ConfigEntry = ConfigEntry {iface::String, srcPort::String, lxcName::String, dstPort::String} deriving (Show)

main = do
  config <- readFile "./lxc-bind.conf"
  let configEntries = parseConfig (lines config)
  print (map show configEntries)
  return ()

parseConfig::[String] -> [ConfigEntry]
parseConfig = foldl (\list line -> case line =~ "^([\\w\\d_-]+):(\\d+)\\s*>\\s*([\\w\\d_-]+)(?::(\\d+))?(?:\\s*#.*)?$" of 
  [[_, _iface, _srcPort, _lxcName, ""]] -> ConfigEntry _iface _srcPort _lxcName _srcPort : list
  [[_, _iface, _srcPort, _lxcName, _dstPort]] -> ConfigEntry _iface _srcPort _lxcName _dstPort : list
  _ -> list) []
