# SFExEmu

A crude reimplementation of StarfallEx in the browser. This only supports clientside code and will never support 3D.

## Security

This probably isn't a secure sandbox.

## Completion

`hook`, `material`, `math`, `os`, `render`, `string`, and `timer` are implemented.

### Built-ins

Most builtins are supported, minus `getfenv`, `setfenv`, `crc`, `setSoftQuota`, `getScripts`, `getLibraries`, `setClipboardText`, `dodir`, `requiredir`, `setName`, `concmd`, `printMessage`, `getMethods`, `try`, anything that has to do with worldspace, permissions, or memory usage, and any enums for which their corresponding functions don't exist.

### `render`

3D rendering functions will never be supported.

Fonts might render incorrectly, but it should still be close enough with the exception of Marlett, HL2MPTypeDeath, FontAwesome, HalfLife2, hl2mp, and csd.

All of the weird behavior with non-left-aligned text in `render.drawText` has not been implemented. Tabs are just replaced with 5 spaces.

### `material`

Materials are pretty sloppily implemented, but they do work. Currently, you can only use `radon/starfall2` but you can add more to the `materials` folder. Only PNG files are supported; no VTF. Corresponding VMF files are required but are completely ignored.

## Usage

Put the folder somewhere on your webserver. It doesn't matter where. Serverside scripting is not required. If you want a quick and easy static webserver, I'd recommend [static-server](https://github.com/nbluis/static-server#readme).

## License

`bit32.lua`: [MIT License; Copyright © 2018-2020 Egor Skriptunoff](https://github.com/Egor-Skriptunoff/pure_lua_SHA/blob/master/LICENSE)

`fengari-web.js`: [MIT License; Copyright © 1994-2019 Benoit Giannangeli, Daurnimator, Lua.org, PUC-Rio](https://github.com/fengari-lua/fengari/blob/master/LICENSE)

`middleclass.lua`: [MIT License; Copyright © 2011-2018 Enrique García Cota](https://github.com/kikito/middleclass/blob/master/MIT-LICENSE.txt)

Some of the files in this project contain derivative code from StarfallEx, which is licensed under [the 3-clause BSD license](https://github.com/thegrb93/StarfallEx/blob/master/License.txt)

Some of the files in this project contain derivative code from [Garry's Mod](https://github.com/Facepunch/garrysmod), which is proprietary.

This project, minus any parts that are derivatives from non-free code, is licensed under the MIT license. See `LICENSE.txt` for details.
