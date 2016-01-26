<wiki:gadget border="0" width="100%" url="http://packet-bnetp.googlecode.com/svn/resources/gadgets/message.xml" up\_class="noteimportant" up\_message="This document is not complete."/>

## Requirements ##

The main design requirement was that the only knowledge to write the protocol
format specification should be the knowledge about the protocol itself.

Which means that the protocol format specification language:
  * Should be as isolated as possible from the Wireshark plugin interface.
  * Should resemble the language the protocol is documented in.

Without writting an interpreter for a DSL, the Lua language is a much better
choice than C as it reduces the implementation effort. The performance
is much lower, though.

The plugin should also be as general as needed for dissecting different
protocols.

## General Idea ##

The plugin execution model is based on the instruction fetch-execute cycle used
by general purpose processors. When Wireshark calls the dissect entry point
the plugin runs some bootstrapping code and starts executing instructions.

Instuctions may be fetched from three memory regions:
  * Header: contains instructions to decode the header of each packet and jump to the appropiate block of instructions to decode the rest of the packet.
  * Server: contains instructions to decode packets originated at the server.
  * Client: contains instructions to decode packets originated at the client.

Each instruction in a block has access to a sequential buffer where the raw
packet is stored and an associative temporal memory from where it can read data
stored by previous instructions or write data which will be used later. The
execution of an instruction may advance the buffer's cursor or it may only look
at the data without advancing it.

Most instructions allow to describe a piece of the packet by assigning a label
and displaying its value inside Wireshark's details pane. Thus they are named
after the underlying data type.  There are also some instructions providing
limited control flow:

  * Field Description: uint16, posixtime, stringz, ipv4, ...
  * Control Flow: when, iterator.

## The Implementation ##

Instructions are implemented as an object that provides the IInstruction
interface:
<pre>
IInstruction {<br>
dissect (c: Context)<br>
}<br>
</pre>
where the _dissect_ method implements the desired effect of the instruction.

Memory regions are implemented as a table of blocks of instructions indexed
by the packet identification number of the packet each block describes:

  * Server: **SPacketDescription** table located at spacket.lua.
  * Client: **CPacketDescription** table located at cpacket.lua.

The Header region is integrated into the core as the concept of a program
counter is not implemented yet. It is processed in the boostrapping code
and then the selected Server or Client block is executed linearly from
beginning to end.

A Server region with only one block that prints a greeting message when
called, assuming its id is 1, may thus look like this:
```
	SPacketDescription = {
		[1] = { dissect = function (self, context) info("Hello World!") end }
	}
```
Due to the dynamic nature of the Lua language the _instruction set_ is not
fixed and new instructions suitable to the needs of the protocol being
dissected  may be created. However for easy of use it is recommended to
define constructor functions that return an instance of a predefined type
of instruction.

The [predefined set of instructions](PredefinedInstructions.md) available in _packet-bnetp_ that
implements field description and control flow is shown in the following
figure:

![http://packet-bnetp.googlecode.com/svn/resources/images/instruction-set.png](http://packet-bnetp.googlecode.com/svn/resources/images/instruction-set.png)

Instruction's constructors are named after its class name. The specification
of a packet format then looks like the following example:

<pre>
--[[<br>
Message ID:    0x72<br>
Message Name:  SID_CLANCREATIONINVITATION<br>
Direction:     Server -> Client (Received)<br>
Used By:       Warcraft III: The Frozen Throne, Warcraft III<br>
Format:        (DWORD) Cookie<br>
(DWORD) Clan Tag<br>
(STRING) Clan Name<br>
(STRING) Inviter's username<br>
(BYTE) Number of users being invited<br>
(STRING) [] List of users being invited<br>
Remarks:       Received when a user is inviting you to create a new clan on<br>
Battle.net.<br>
Related:       [0x72] SID_CLANCREATIONINVITATION (C->S)<br>
]]<br>
#define SID_CLANCREATIONINVITATION 0xFF72<br>
[SID_CLANCREATIONINVITATION] = { -- 0x72<br>
uint32("Cookie", base.HEX),<br>
uint32("Clan Tag"),<br>
stringz("Clan Name"),<br>
stringz("Inviter's username"),<br>
uint8{label="Number of users being invited", key="users"},<br>
iterator{refkey="users", label="Invited users", repeated={<br>
stringz("Name"),<br>
}},<br>
}<br>
</pre>