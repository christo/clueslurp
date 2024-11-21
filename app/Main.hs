{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad (unless, when)
import System.Environment (getArgs)
import System.IO (
  BufferMode (..),
  Handle,
  IOMode (AppendMode),
  hPutStr,
  hSetBuffering,
  isEOF,
  stderr,
  stdout,
  withFile,
 )
import Text.Regex.TDFA ((=~))

main :: IO ()
main = do
  args <- getArgs
  case args of
    [clueFile] -> do
      hSetBuffering stdout NoBuffering
      hSetBuffering stderr NoBuffering

      -- clues consume a whole line and look like this:
      -- DSFSSF.FOO=292@234328|097a2f97afaf97af7af9af7af9af7a9
      withFile clueFile AppendMode $ \handle -> do
        processInput "^[A-Z]+\\.[A-Z]+=\\d@\\d+|[0-9a-f]{31}$" handle ""
    
    _ -> do
      putStrLn "Usage clueslurp <cluefile>"
      putStrLn "  <cluefile>: file containing clues to be read and updated"

processInput :: String -> Handle -> String -> IO ()
processInput regex handle buffer = do
  eof <- isEOF
  unless eof $ do
    char <- getChar
    putChar char -- echo
    let newBuffer = buffer ++ [char]
    if char == '\n'
      then do
        when (newBuffer =~ regex) $ hPutStr handle newBuffer
        processInput regex handle "" -- reset
      else processInput regex handle newBuffer -- continue
