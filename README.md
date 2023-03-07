# MutEmoticons for Unreal Tournament 2004

Away with text-based emoticons! Pimp your game's text box with lovely emoticons!

## Installation

Drop the files in the root of your UT2004's installation. e.g. all files in ```/System/``` should go in the corresponding root folder i.e. ```/UT2004/System/```

For server admins, use: ```MutEmoticons.MutEmoticons```, ```MutEmoticons_V1B.MutEmoticons```, or ```MutEmoticons_V1B_TAM_3141.MutEmoticons``` etc.

## Usage

In the in-game chat, simply write one of the following text-based emoticons:

> \>:( :( :) :p :d :D :| :/ :- B) xD

## Config

The configuration file can be found at ```/System/MutEmoticons.ini``` and should contain the following content:

```ini
; For V1B use [MutEmoticons_V1B.MutEmoticons], or [MutEmoticons_V1B_TAM_3141.MutEmoticons]
[MutEmoticons.MutEmoticons]
Smileys=(Event=">:(",Icon=Texture'MAD')
Smileys=(Event=":(",Icon=Texture'11_FROWN')
Smileys=(Event=":)",Icon=Texture'19_GREENLI2')
Smileys=(Event=":p",Icon=Texture'17_TONGUE1')
Smileys=(Event=":d",Icon=Texture'19_GREENLI1')
Smileys=(Event=":D",Icon=Texture'16_BIGGRIN')
Smileys=(Event=":|",Icon=Texture'12_INDIFFE')
Smileys=(Event=":/",Icon=Texture'13_OHWELL')
Smileys=(Event=":-",Icon=Texture'18_REDFACE')
Smileys=(Event="B)",Icon=Texture'COOL')
Smileys=(Event="xD",Icon=Texture'SCREAM6')
```

```ServerPackages```? No need the mutator will add itself to the ```ServerPackages``` list on startup.
However, if you have configured your own emoticons that reside in another .utx package you will have to manually add that package to the ```ServerPackages```

## Note

This mutator replaces the HUDClass in order to displace the text-based emoticons with their corresponding icon. Because of this, this may break non-standard gametypes or simply not work at all.

Supported standard gametypes:
* Assault (AS)
* BombingRun (BR)
* Capture the Flag (CTF)
* DeathMatch (DM), Team DeathMatch (TDM)
* Double Domination (DDOM)
* Invasion (INV)
* Last Man Standing (LMS)
* Onslaught (ONS)

Custom gametypes:
> **Requires a customized version of this mutator**
* Arena Master (AM), Team Arena Master (TAM)
* Freon

## Credits

This mutator was originally an integrated part of a modified Assault (**AssaultPlus**) circa 2006 by [Marco](https://github.com/Marco888) a.k.a **.:..:**

The mod was then ported over to work as a mutator for all supported gametypes, additionally support for admins to add new emoticons was added, released on December 28, 2007 by EliotVU.

The icons were borrowed from an unknown UT99 mod, if you happen to know, feel free to submit an issue :)

## Derivative Works

* Unreal Tournament 3 (UT3) [integrated with UT3X](https://github.com/xtremexp/UT3X) (the author claims copyright which is invalid)
* Killing Floor (KF) Link?

## See also

[V1 on UnrealArchive](https://unrealarchive.org/mutators/unreal-tournament-2004/M/mutemoticonsv1_147952ac.html)
