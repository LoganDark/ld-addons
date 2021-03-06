# LD Addons

This repository contains a collection of all my Garry's Mod addons. Full Lua sources, `.gma`s, and icons are provided.

Icons are generated by `ldaddon.sketch`, which is a [Sketch](https://sketchapp.com/) document. It uses the SF Pro Text font. You will likely need a macOS machine to use it.

## LD Spam Remover

My first custom Gmod addon actually wasn't created by me. It was created by `philxyz`, and then fixed/uploaded to Workshop by another user [here](https://steamcommunity.com/sharedfiles/filedetails/?id=1512058212). The "fixed" version, however, still crashed whenever you clicked on a non-entity (i.e. the world) since the client side didn't match the server side.

The new tool includes both formatting fixes in the Lua code and an updated description. You can find it on the Workshop [here](https://steamcommunity.com/sharedfiles/filedetails/?id=1538129802).

## LD Join/Leaves

One of my friends desired a simple way to know when someone joined the server. Of course, it says in the *console* when someone joins, but there's nothing in that - nothing for someone to see unless they continually check the console or leave it open.

LD Join/Leaves is a simple addon that shows join/connected/leave messages in chat. It's important to note that the addon recognizes the difference between "connected" and "connectING" - it does display when a user has fully loaded in addition to displaying when they begin connecting.

## Contact

Have a suggestion? Found a bug? Create a GitHub issue and I can help. Alternatively, you could create a pull request if you have a fix for a bug or a new feature to add.

Just please note that, at this time, I'm just starting out as an addon developer (I know Lua, but not GLua), so these addons are going to be very simple.
