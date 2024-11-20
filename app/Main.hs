{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.IO (withFile, IOMode(AppendMode), Handle, isEOF, hPutStrLn)
import Text.Regex.TDFA ((=~))
import Control.Monad (unless, when)


main :: IO ()
main = do
  -- clues consume a whole line and look like this:
  -- DSFSSF.FOO=292@234328|097a2f97afaf97af7af9af7af9af7a9
  let clueRegex = "^[A-Z]+\\.[A-Z]+=\\d@\\d+|[0-9a-f]{31}$"
  let clueFile = "cbvclues.txt"

  withFile clueFile AppendMode $ \handle -> do
    processLines clueRegex handle

processLines :: String -> Handle -> IO ()
processLines regex handle = do
  eof <- isEOF
  unless eof $ do
    line <- getLine
    putStrLn line
    when (line =~ regex) $ hPutStrLn handle line
    processLines regex handle
