# FAQ

In general, most questions are best answered via the [official CID](https://github.com/ipld/cid) github and by its members.

If you have Elixir specific issues, please open an issue here. Do not open Multibase, Multicodec, Multihash, or generic CID issues here.

## Which CID version should I use?

As of now, use CID version 1.

## What about future CID versions?

This library tries to write most code in a generic way, but it attempts to stop you from being stupid if a new CID version is released. If such an event happens, it probably means the algorithms need some updating anyway.

## Can you add `x` to Multicodec, Multihash, Multibase?

Only if those standards mandate them. I do not control Multihash, but I will be working as appropriate with the library should the need arise.

## Why can't I use other codecs with CID v0?

You probably shouldn't be using CID v0. If you are, there is only 1 codec supported.

## Why is the buffer and the encoded value for CID v0 the same? Why are these values different for other CID versions?

CID v0 does not use Multibase. CID v1 does, and the buffer is just a returned value before encoding using Multibase.

## Why don't certain multihash values work for CID v0?

The length parameter needs to be set when you encode a CID v0 using Multihash.