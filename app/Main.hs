{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.IO (withFile, IOMode(AppendMode), Handle, isEOF, hPutStrLn, stdout, stderr, hSetBuffering, BufferMode(..))
import Text.Regex.TDFA ((=~))
import Control.Monad (unless, when)


main :: IO ()
main = do
  -- clues consume a whole line and look like this:
  -- DSFSSF.FOO=292@234328|097a2f97afaf97af7af9af7af9af7a9
  let clueRegex = "^[A-Z]+\\.[A-Z]+=\\d@\\d+|[0-9a-f]{31}$"
  let clueFile = "cbvclues.txt"

  hSetBuffering stdout NoBuffering
  hSetBuffering stderr NoBuffering

  withFile clueFile AppendMode $ \handle -> do
    processInput clueRegex handle ""

processInput :: String -> Handle -> String -> IO ()
processInput regex handle buffer = do
  eof <- isEOF
  unless eof $ do
    char <- getChar
    putChar char -- echo
    let newBuffer = buffer ++ [char]
    if char == '\n'
      then do
        when (newBuffer =~ regex) $ hPutStrLn handle newBuffer
        processInput regex handle "" -- reset
      else processInput regex handle newBuffer -- continue
