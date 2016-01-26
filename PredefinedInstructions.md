<wiki:gadget border="0" width="100%" url="http://packet-bnetp.googlecode.com/svn/resources/gadgets/message.xml" up\_class="noteimportant" up\_message="This document is not complete. In the meanwhile, some documentation can be found in the source code. See: http://code.google.com/p/packet-bnetp/source/browse/#svn/trunk/src/api"/>



# Constructor functions #

Constructor functions encapsulate the initialization of commonly used instruction objects in a way they become easier to type an read.

In _packet-bnetp_ constructor functions are overloaded to act as constructors
```
  cons ( arg1, arg2, arg3 )
```
and copy-constructors
```
  cons { attr1="val1" }
```

Constructors receive the instruction attributes in formal parameters. Each instruction constructor has its own parameter list and they are documented in the following sections.

Copy-constructors receive a template of the instruction object as its only parameter. The attributes of the template are copied to the new instruction object overriding those inherited from the base instruction type.

# Field Description #


---


## uint ##

<pre>
_uint8  ( label, base, string-map )<br>
uint16 ( label, base, string-map )<br>
uint32 ( label, base, string-map )<br>
uint64 ( label, base, string-map )_<br>
</pre>

These functions create a field for an unsigned integer of the specified size. The base argument is the base the number is displayed in when the field is shown in Wireshark and it must be one of
> base.HEX <br />
> base.DEC <br />
> base.OCT <br />

The label argument must be a non-empty string.

The string-map argument maps integer values to meaningful strings. It must be given as a lua table where the strings are stored using its corresponding integer value as a key. For example:
```
uint8 ( "Num", base.DEC, {
    "ONE",
    "TWO",
    "THREE",
    [1000] = "ONE THOUSAND",
    [0] = "CERO",
})
```

When constructing the field from a template object the following attributes are given special meaning:

```
uint8 {
    label="foo",      -- the label argument
    display=base.HEX, -- the base argument
    desc={...},       -- the string-map argument
    big_endian=false, -- the endianness of the integer.
                      -- (default: little-endian)
}
```


---
