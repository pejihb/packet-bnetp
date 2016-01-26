  * display summary in info field in packet list and in decoder view
    * ~~Packet ID and direction~~
    * Other packet dependent information.
    * Some framework may be needed to specify this in the packet description.
      * See iterator suggestion lower.
  * [statstring decoder](http://code.google.com/p/ghostplusplus/source/browse/trunk/ghost/util.cpp?r=321#520) game and user statstrings
    * Client dependent data types.
  * Add Config.client value to decide how to decode the raw data.
    * http dissector remembers that a connect proxy was used in previous packets, maybe our plugin can the same, remember clienttag since login?
  * Support different sessions of the protocol in the same capture file.
    * Conversation API is no available in lua.
    * A session is identified by it's src/dst ip and src/dst port.
    * At the init entry point, called when Wireshark is going to load a new file, the structures to store the sessions' properties should be initialized.
    * New functions should allow a packet description to read or write those structures.
    * Existing functions that rely on keys (iterator, when) may need to be improved to support session's properties to be used.
  * don't make dropdown list on iterator with counter if iterator's repeatable block consists of only one operator?
    * Workaround: add alias="none" parameter to iterator constructor.
      * Readability?
    * 2 keys needed
      * Create a node for iterator itself?
      * Create a node for every iteration (mandatory if there are many items in iterator)?
    * There are 3 types of iterators:
      * (no, no) Flat, like S>0x0b channel list (if only 1 item in iterator)
      * (yes, no) Nested, with 1 common tree per iterator (if only 1 item in iterator)
      * (yes, yes) Nested, with a tree for every iteration (if more than 1 item in iterator)
    * Add a possibility to add count to labels, e.g. "%num%". Numbers are counted from 1.
    * Usind variables in labels, like "%varname%" (format can vary). Variables are substituted after iteration.
  * Allow field reuse
    * Keep a cache of fields used by packet descriptions.
    * When defining a field first look in the cache.
      * A field is equal to another if their label, filter, type, etc. are equal.
    * Remember to clean the cache after initialization is done.
  * Move todo list to the Issues tab.
  * Define useful positional parameters for each primitive
    * ~~`[`u`]`intX(label, base, value\_string\_map)~~
    * ~~array(label, type, size)~~
    * ~~strdw(label, value\_string\_map)~~
    * iterator
    * flags
    * ~~when~~
  * More Documentation?
    * Document API (data decoder API, like uint32())
    * LuaDoc
  * Suppress double value output in ipv4() and version()
    * In ipv4, one of the values got replaced with DNS if DNS resolving is turned on
    * If workaround not found for version() - decode it manually?
  * Use Wireshark's "User Preferences" to allow run-time changes in the configuration.
  * [llvm-lua](http://code.google.com/p/llvm-lua/): JIT/Static compiler for Lua using LLVM on the backend.
    * It may be worth to try to integrate a JIT compiler into Wireshark's Lua based plugins :)
      * Agree, lua plugins are hell slow, simplest dissector slows shark down 2-3 times.
  * strdw issues
    * Non-existing desc table in strdw(): no error message
      * As in `strdw("akj", Desc.NotDefined)`?
    * strdw(): key not exists in the table - display "Unknown" as for other types?
      * Other types display "Unknown"?
  * Specify length as key in array()
  * stringz valuemaps
  * valuemaps for filters, so they can be displayed in "Expression..." dialog.

## done ##
### most important ###
  * ~~array of any basic type (actually, uint32[5](5.md) may be enough)~~
    * ~~display it as one value (e.g. passhash uint32 [5](5.md) - 40 char string)~~
  * ~~conditions (if..)~~
  * ~~string-dword (swap dword and output as string)~~
  * ~~supress raw values output on custom types (time, dwordstr)~~
  * ~~iterator from 0 to x (cdkey/gamelist)~~
    * Wireshark needs a patch to correctly highlight each element in the hexdump.
      * [Still not included in 1.2.3](https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=3994)
      * [Alien](http://alien.luaforge.net/): Lua's FFI. The patch may not be needed after all :) (at the cost of an extra dependency)
      * It will be available in Wireshark versions 1.4.x. (currently a release candidate)
  * ~~iteration until empty string (S>0x0b getchannellist)~~
    * don't display last empty entry?

### less important ###
  * ~~ip (network byte order, opposite to intel). For some reason lua's built-in ipv4 uses inter order (lol?)~~
  * ~~windows (?) file time, used in sid\_getfiletime~~
    * can be converted to posixtime
    * $unixtime = $wintime/1E7 - 11644473600
  * ~~unips file time~~
  * ~~exe version decoder (like ip, but in intel order)~~
  * ~~enclosed iterators (for s>0x26 readuserdata)~~
  * ~~make clienttag a type (so it's no need to write possible values every time)?~~ - valuemaps for strdw
  * ~~bitmap decoder (user flag)~~
  * ~~sid\_checkad: extension: string[4](4.md)~~
  * ~~"decode as" if both ports not 6112 (e.g. using proxy): can't define who is server and who client~~
    * ~~At least, add config section at the beginning of the file~~
    * ~~Add lite mode configuration.~~
  * ~~Add heading with instructions~~
  * Prevent Wireshark from crashing by properly validating the packets' descriptions and give useful feedback in case of errors.
    * Bug of lua interpreter / wireshark lua interface / wireshark itself?
      * Crashed, if hash and usual forms were mixed in function call.
    * Crashed 1.2.3 and [latest pre-release win32-1.2.7pre1-31873](http://www.wireshark.org/download/prerelease/wireshark-win32-1.2.7pre1-31873.exe). I think, we need to report bug. 1.2.6 [didn't even worked on 2000](https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=4176)
  * ~~Mixed parameter form in function call, like in python~~
    * Done. Does it work?
      * Yes, it does.
  * Investigate GeoIP.
    * It only shows something in IPv4 Tree.
  * ~~SID\_CHATEVENT event id and SID\_WARCRAFTGENERAL subcommand id as filter?~~
    * ~~Authomatically append "bnetp." to filter name~~