# Elixir CID

Elixir version of [CID](https://github.com/ipld/cid). CID is currently being used as part of [IPFS](https://ipfs.io/) for identifying distributed content.

> Self-describing content-addressed identifiers for distributed systems

## Motivation

[**CID**](https://github.com/ipld/cid) is a format for referencing content in distributed information systems, like [IPFS](https://ipfs.io). It leverages [content addressing](https://en.wikipedia.org/wiki/Content-addressable_storage), [cryptographic hashing](https://simple.wikipedia.org/wiki/Cryptographic_hash_function), and [self-describing formats](https://github.com/multiformats/multiformats). It is the core identifier used by [IPFS](https://ipfs.io) and [IPLD](https://ipld.io).

## Features

* Encode/Decode CIDs
    * Encode a CID to a string
    * Encode a CID buffer to later Multibase encode
    * Decode a CID string to a CID and optionally, the Multibase encoding used
* Human readable CIDs for debugging and checking
* Error handling and exception versions of most major API functions
* Current support for all Multibase and Multicodec encodings
* Immutable Elixir struct for CID data
    * Easy comparisons, construction, validation, etc.
    * Send over the wire
    * Simple debugging and inspecting
* Consistent API
* Support for CID v0 and CID v1
* Tests

## Usage

The following examples show the basic usage of using this library to encode, decode, and introspect CIDs. 

*Note*: that in the case of codecs (Multicodec), multihashes (Multihash), and encodings (Multibase), we may select values for demonstration purposes. In other words, some usage may not match reality - pragmatic examples are the goal. 

Read more about [Multicodec](https://github.com/multiformats/multicodec), [Multihash](https://github.com/multiformats/multihash), and [Multibase](https://github.com/multiformats/multibase) to learn more.

### Create a CID

```elixir
# first let's create a Multihash to use for our examples
{:ok, multihash} = Multihash.encode(:sha2_256, :crypto.hash(:sha256, "like common people")) 
{:ok,
 <<18, 32, 149, 184, 131, 27, 7, 230, 246, 113, 26, 45, 235, 92, 130, 235, 240,
   88, 99, 208, 173, 179, 49, 200, 107, 43, 173, 200, 167, 153, 175, 31, 65,
   149>>}

# the default version is the latest (CID v1) and the default codec is "dag-pb" which is used for CID v0
CID.cid(multihash)
{:ok,
 %CID{
   codec: "dag-pb",
   multihash: <<18, 32, 149, 184, 131, 27, 7, 230, 246, 113, 26, 45, 235, 92,
     130, 235, 240, 88, 99, 208, 173, 179, 49, 200, 107, 43, 173, 200, 167, 153,
     175, 31, 65, 149>>,
   version: 1
 }}

# we can also use an exception raising version
# let's also change the codec too and explicitly pass the version
CID.cid!(multihash, "cbor", 1)  
%CID{
  codec: "cbor",
  multihash: <<18, 32, 149, 184, 131, 27, 7, 230, 246, 113, 26, 45, 235, 92,
    130, 235, 240, 88, 99, 208, 173, 179, 49, 200, 107, 43, 173, 200, 167, 153,
    175, 31, 65, 149>>,
  version: 1
}

# if for some reason we want a CID v0 ID, we can do it like so
{:ok, v0_multihash} = Multihash.encode(:sha2_256, :crypto.hash(:sha256, "like common people"), 32) 
{:ok,
 <<18, 32, 149, 184, 131, 27, 7, 230, 246, 113, 26, 45, 235, 92, 130, 235, 240,
   88, 99, 208, 173, 179, 49, 200, 107, 43, 173, 200, 167, 153, 175, 31, 65,
   149>>}

CID.cid!(v0_multihash, "dag-pb", 0)
%CID{
  codec: "dag-pb",
  multihash: <<18, 32, 149, 184, 131, 27, 7, 230, 246, 113, 26, 45, 235, 92,
    130, 235, 240, 88, 99, 208, 173, 179, 49, 200, 107, 43, 173, 200, 167, 153,
    175, 31, 65, 149>>,
  version: 0
}

# thankfully if we mess up, our lib stops us before catastrophe strikes
CID.cid(v0_multihash, "cbor", 0)   
{:error, :invalid_multicodec}

CID.cid(multihash, "barrel of feet", 1)
{:error, :invalid_multicodec}
```

### Encode a CID

Now let's actually encode a CID to a string, for use in an application perhaps like IPFS:

```elixir
CID.cid!(multihash, "dag-json", 1) |> CID.encode()
{:ok, "z4EBG9jACDDa7TeGCBUUk4ziuRsGmGnjefMx5GEofptsFxTaH8Q"}

# we also have our exception raising version
CID.cid!(multihash, "cbor", 1) |> CID.encode!()
"zadi4ekZWb9uwiPgSM1Fki5UAfvggkGC27Qy6acaYZ49jycsv"

# and we can do the same for a v0 CID
CID.cid!(v0_multihash, "dag-pb", 0) |> CID.encode()  
{:ok, "QmYR6e57B15cM77ankTPqxsQVbFVzcYSGrFGr5WtmR8jdn"}

# we can only encode a v0 CID with :base58_btc
CID.cid!(v0_multihash, "dag-pb", 0) |> CID.encode(:base64)    
{:error, :invalid_encoding}

# with CID v1 we can control the encoding - let's choose :base64
CID.cid!(multihash, "dag-pb", 1) |> CID.encode!(:base64)
"mAXASIJW4gxsH5vZxGi3rXILr8Fhj0K2zMchrK63Ip5mvH0GV"

# if we just want the buffer, we can also do this
CID.cid!(multihash, "cbor", 1) |> CID.encode_buffer()
{:ok,
 <<1, 81, 18, 32, 149, 184, 131, 27, 7, 230, 246, 113, 26, 45, 235, 92, 130,
   235, 240, 88, 99, 208, 173, 179, 49, 200, 107, 43, 173, 200, 167, 153, 175,
   31, 65, 149>>}
      
```

### Decode a CID

Decode a CID string:

```elixir
# let's decode some of our earlier strings
CID.decode("zadi4ekZWb9uwiPgSM1Fki5UAfvggkGC27Qy6acaYZ49jycsv")
# notice we also get the Multibase used
{:ok,
 {%CID{
    codec: "cbor",
    multihash: <<18, 32, 149, 184, 131, 27, 7, 230, 246, 113, 26, 45, 235, 92,
      130, 235, 240, 88, 99, 208, 173, 179, 49, 200, 107, 43, 173, 200, 167,
      153, 175, 31, 65, 149>>,
    version: 1
  }, :base58_btc}}

# we have our exception raising version again
CID.decode!("zadi4ekZWb9uwiPgSM1Fki5UAfvggkGC27Qy6acaYZ49jycsv")
{%CID{
   codec: "cbor",
   multihash: <<18, 32, 149, 184, 131, 27, 7, 230, 246, 113, 26, 45, 235, 92,
     130, 235, 240, 88, 99, 208, 173, 179, 49, 200, 107, 43, 173, 200, 167, 153,
     175, 31, 65, 149>>,
   version: 1
 }, :base58_btc}

# we can also get only the CID, exception raising version available
CID.decode_cid!("mAXASIJW4gxsH5vZxGi3rXILr8Fhj0K2zMchrK63Ip5mvH0GV") 
%CID{
codec: "dag-pb",
multihash: <<18, 32, 149, 184, 131, 27, 7, 230, 246, 113, 26, 45, 235, 92,
 130, 235, 240, 88, 99, 208, 173, 179, 49, 200, 107, 43, 173, 200, 167, 153,
 175, 31, 65, 149>>,
version: 1
}

# fortunately our error handling versions have some sanity checks too
CID.decode_cid("Why would a company named Franco American make Italian food?")
{:error, "unable to decode CID string"}

# let's tamper with a string by adding "Q" to prove it
CID.decode("QmAXASIJW4gxsH5vZxGi3rXILr8Fhj0K2zMchrK63Ip5mvH0GV")
{:error, "unable to decode CID string"}
```

## Human Readable CID Strings

Sometimes we want to better understand exactly *what* is in our CID. Fortunately, we can humanize a CID string like so:

```elixir

# help me make sense of all this
CID.humanize("zadi4ekZWb9uwiPgSM1Fki5UAfvggkGC27Qy6acaYZ49jycsv")          
{:ok,
 "base58_btc - CIDv1 - cbor - sha2_256 - 95b8831b07e6f6711a2deb5c82ebf05863d0adb331c86b2badc8a799af1f4195"}

# a custom separator
CID.humanize("z4EBG9jACDDa7TeGCBUUk4ziuRsGmGnjefMx5GEofptsFxTaH8Q", ":")
{:ok,
 "base58_btc:CIDv1:dag-json:sha2_256:95b8831b07e6f6711a2deb5c82ebf05863d0adb331c86b2badc8a799af1f4195"}

# we can get sassy too with our own custom separators
CID.humanize("QmYR6e57B15cM77ankTPqxsQVbFVzcYSGrFGr5WtmR8jdn", "\_(ツ)_/¯")
{:ok,
 "base58_btc_(ツ)_/¯CIDv0_(ツ)_/¯dag-pb_(ツ)_/¯sha2_256_(ツ)_/¯95b8831b07e6f6711a2deb5c82ebf05863d0adb331c86b2badc8a799af1f"}
```

### CID Validity

What if want to know whether or not a CID is valid? No problem:

```elixir
# vindication
CID.cid?("z4EBG9jACDDa7TeGCBUUk4ziuRsGmGnjefMx5GEofptsFxTaH8Q")
true

# sadly, not a valid ID
CID.cid?("I want to persuade you that I am an ID")
false
```

### Convert a CID

If we have some need to convert CID representations, we can do it. This is more useful in the long-term. A typical use-case is to convert a CID v0 to a CID v1.

The simplest route would just be to decode and re-encode, however if we are still working with our struct or if we already decoded it, we have a simple option:

```elixir
CID.cid!(multihash, "dag-pb", 0) |> CID.to_version(1)
{:ok,
 %CID{
   codec: "dag-pb",
   multihash: <<18, 32, 149, 184, 131, 27, 7, 230, 246, 113, 26, 45, 235, 92,
     130, 235, 240, 88, 99, 208, 173, 179, 49, 200, 107, 43, 173, 200, 167, 153,
     175, 31, 65, 149>>,
   version: 1
 }}
 
# we can't convert if we break the rules though of a version, such as CID v1 -> CID v0
CID.cid!(multihash, "dag-cbor", 1) |> CID.to_version(0)
{:error, :unsupported_conversion}

# we can convert from CID v1 to CID v0 though if we follow the rules
CID.cid!(v0_multihash, "dag-pb", 1) |> CID.to_version(0)  
# notice it works because the codec was "dag-pb"
{:ok,
 %CID{
   codec: "dag-pb",
   multihash: <<18, 32, 149, 184, 131, 27, 7, 230, 246, 113, 26, 45, 235, 92,
     130, 235, 240, 88, 99, 208, 173, 179, 49, 200, 107, 43, 173, 200, 167, 153,
     175, 31, 65, 149>>,
   version: 0
 }}
```

### Summary - Encode and Decode Round-Trip

Finally, to review let's round trip some data:

```elixir
# take a CID v1, encode it, then decode it back again
CID.cid!(multihash, "dag-pb", 1) |> CID.encode!() |> CID.decode!()
{%CID{
   codec: "dag-pb",
   multihash: <<18, 32, 149, 184, 131, 27, 7, 230, 246, 113, 26, 45, 235, 92,
     130, 235, 240, 88, 99, 208, 173, 179, 49, 200, 107, 43, 173, 200, 167, 153,
     175, 31, 65, 149>>,
   version: 1
 }, :base58_btc}

# changing the default encoding while round tripping
CID.cid!(multihash, "cbor") |> CID.encode!(:base32_z) |> CID.decode!()
{%CID{
   codec: "cbor",
   multihash: <<18, 32, 149, 184, 131, 27, 7, 230, 246, 113, 26, 45, 235, 92,
     130, 235, 240, 88, 99, 208, 173, 179, 49, 200, 107, 43, 173, 200, 167, 153,
     175, 31, 65, 149>>,
   version: 1
 }, :base32_z}

# round-tripping a v0 CID with some options 
 CID.cid!(v0_multihash, "dag-pb", 0) |> CID.encode!() |> CID.decode_cid!()
 %CID{
   codec: "dag-pb",
   multihash: <<18, 32, 149, 184, 131, 27, 7, 230, 246, 113, 26, 45, 235, 92,
     130, 235, 240, 88, 99, 208, 173, 179, 49, 200, 107, 43, 173, 200, 167, 153,
     175, 31, 65, 149>>,
   version: 0
 }
```

## Installation

Available in [Hex](https://hex.pm/packages/cid). The package can be installed by adding `cid` to your list of dependencies in mix.exs:

```elixir
def deps do
  [
    {:cid, "~> 0.0.1"}
  ]
end
```

API Documentation can be found at [https://hexdocs.pm/cid](https://hexdocs.pm/cid).

## Issues

In general, most questions are best answered via the [official CID project](https://github.com/ipld/cid) and by its members.

If you have Elixir specific issues, please open an issue here. Do not open Multibase, Multicodec, Multihash, or generic CID issues here.

You can also check the FAQ in the `docs` folder.

## Acknowledgments

* Motivation sections and other minor docs from [official CID project](https://github.com/ipld/cid)