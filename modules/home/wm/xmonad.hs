import XMonad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import System.IO

main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ docks def
    { modMask = mod4Mask
    , terminal = "kitty"
    , layoutHook = smartBorders $ layoutHook def
    , manageHook = manageDocks <+> manageHook def
    , handleEventHook = docksEventHook
    , logHook = dynamicLogWithPP xmobarPP
        { ppOutput = hPutStrLn xmproc }
    , startupHook = spawnOnce "xmobar"
    }
    `additionalKeysP`
    [ ("M-<Return>", spawn "kitty")
    , ("M-b", spawn "firefox")
    , ("M-S-q", spawn "xmonad --recompile; xmonad --restart")
    ]
