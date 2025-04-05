# MyMinUI-Deci-Custom

A collection of custom tools and PAKs designed for and ported to **[MyMinUI](https://github.com/Turro75/MyMinUI)**.

Currently the PAKs only support the r36s, however, almost everything should work on other MyMinUI-supported handhelds. Simply change the `r36s` folders' names to the corresponding ones you use in your MyMinUI install.

## Why?

There are several reasons behind the creation of this project:

- **Incomplete MyMinUI**
  While MyMinUI is an amazing port of MinUI to ArkOS, it lacks several features present in ES (EmulationStation).

- **Terminal Output Limitations**
  MinUI doesn't display terminal output, meaning TUIs (Text User Interfaces) and CLIs (Command Line Interfaces) aren't possible in the default setup. As a result, custom solutions must be developed graphically. Interestingly, this limitation pushed me to create a more user-friendly solution, and I encourage others to do the same.

- **Learning Experience**
  As a beginner to Linux handhelds, I’m eager to learn and contribute to the community as much as I can.

---

## Tools and Features

### Plymouth Selector

A remake of the original [Plymouth-cp.sh](https://drive.google.com/file/d/1SR_N3XlwQMJTkAR9RnmhG-ZfZOk_3vwq/view?usp=sharing) script by [Sucharek233](https://www.reddit.com/r/R36S/comments/1gnri3v/plymouth_theme_selector/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button), now written in **Lua** with **Love2D**. This tool uses a custom MinUI-like interface that I built from scratch. It allows you to:

- Browse and preview available Plymouth themes
- Apply a selected theme
- Reset to the default theme

---

### PortMaster

_Currently a work in progress._

I'm developing a version of **PortMaster** that:

- Works without inconveniences
- Can be updated easily
- Integrates seamlessly with MyMinUI

---
