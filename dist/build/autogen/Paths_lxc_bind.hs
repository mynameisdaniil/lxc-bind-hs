module Paths_lxc_bind (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1,0,0], versionTags = []}
bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "/home/daniil/.cabal/bin"
libdir     = "/home/daniil/.cabal/lib/lxc-bind-0.1.0.0/ghc-7.6.3"
datadir    = "/home/daniil/.cabal/share/lxc-bind-0.1.0.0"
libexecdir = "/home/daniil/.cabal/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catchIO (getEnv "lxc_bind_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "lxc_bind_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "lxc_bind_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "lxc_bind_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
