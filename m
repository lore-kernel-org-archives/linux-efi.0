From: Mike Hodgin <mikeserv-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: embed linux in UEFI?
Date: Wed, 9 Oct 2013 11:48:35 -0700
Message-ID: <CA+C2mOa59xUXxAHT4MFGbt72oW9TdmG_OyYLa8nE81MxfRz6-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hey all,

I should first say that I'm not much of a programmer or expert in any
special way, and that I'm aware that there are probably perfectly
obvious technical reasons which elude me that prohibit and/or obviate
some or all of my notions. That said, if any one of you could take the
time to describe what it is I don't understand in way that I might I
would be very grateful.

Personally, I've always thought that the coreboot guys had it right
and that Linux in one form or another is really the ideal replacement
for BIOS. As I understand it, pretty much since the advent of
plug'n'play the OS's have been doing the majority of its work anyway.
In a video I watched once coreboot's Ron mentioned that Linux did
require BIOS for hardware intialization routines, especially where
embedded controllers and ACPI is concerned, but that once power was
confirmed Linux (and most others) just took the reins. Probably that's
an overly-simplistic description, but that's what I took away from it.

Unfortunately due to undocumented proprietary board and BIOS designs
coreboot is apparently very difficult to implement. This was
especially true when BIOS was BIOS and all its routines were stored in
a flash module averaging 512kb or so. The work involved in
reverse-engineering an undocumented system written in assembly often
specifically designed to protect trade secrets and which necessarily
already incorporated any and all possible hacks and compression
methods possible just to make it fit in the first place boggles my
mind, especially when a single failure can so often be your only
chance. I'm astounded they ever made any headway at all, much less
acheived compatibility with the more than 100 boards listed on their
site.

But most of us are nowhere near as capable, nor so motivated, and 100
or more compatible boards or none at all makes little difference if
our hardware is not included among them, as is the case for most. But
lately I've noticed some interesting goings-on in the UEFI world that
indicate a sort of compromise might be possible and so I thought I'd
run it by you guys just to find out how off-base I really am.

Some of the hackintosh guys have apparently managed to insert their
own .DXE driver modules in several system ROMs and for at least one
board have installed their own tailored bootloader enabling them to
boot OSX on their own PC hardware masked with custom DSDTs directly
from UEFI. Some others regularly update their own firmware option ROMs
in system flash beyond any board manufacturer support. I found one
script that scans an image file for possibly upgradeable modules,
installs them as necessary, recompresses and/or recompiles as
appropriate, and leaves the user with a flashable image file - all
automatically.

It seems to me that most of these happenings can be attributed to a
few core factors:

Firstly, where UEFI is concerned there are three main players: AMI's
Aptio, Pheonix's I-forget-the-name, and Intel's Tiano-based images. Of
course this was the case before as well, but then board vendors were a
lot more likely to modify their ROMs in any number of ways that were
little-understood. I'm a bit unclear on this, but I strongly suspect
that both AMI and Pheonix lean heavily on Intel's Tiano codebase
because of their "opensource" EDK2, even if the irony that it requires
a base system such as coreboot just to operate is a little ridiculous.
 Anyway, with fewer sources the system has become more approachably
understandable from a broader standpoint than did BIOS's more
specialized days.

Adding to that approachability is the move from assembly to a c
codebase. I vaguely grasp that it's actually some kind of c
specialization or perverse at least in some way, but I can't put my
finger on exactly what that means. In any case, it's not machine
language. C's adoption alone inflated ROM images many-fold, not to
mention whatever other so-called value-added UEFI services might
require. This has necessarily lead to the average consumer UEFI board
incorporating system flash chips of 4mbs and more just to contain it.
I also attribute the change from real- to protected-mode boots to the
c migration, though I'm very fuzzy on technicalities. Whereas before
BIOS hacking could offer rewards like a .5mb NOR or 64kb of
addressable memory, UEFI seems to bring much more to the table in that
respect.

Owing perhaps a great deal to larger flash chips, board vendors seem
to be following the UEFI spec in large part and are conveniently
rolling their applicable drivers and configuration images into UEFI
modules. Many of them do so with common toolkits provided them by the
likes of AMI and Intel. Whether or not any or all of them is very good
at it is beside the point;  what most interests me about this is that
this actually very frequently is described with words such as
"common," "toolkit," and "module."

I say all of this knowing that obviously anyone on the other end of
this email is likely very well aware of these things and much more
besides; I only wish to summarize my understanding in case I've got
something wrong and someone can help me to understand it better. As I
was reading through the various forum threads and about hackintosh
UEFI mods and similar that I mentioned before I came to suspect that
customizing my own UEFI firmware might be within my reach. The
hackintosh mods specifically seem to have mostly been made possible by
some curious guy with no special understanding plugging away with a
few (very possibly illicitly acquired) vendor drag-and-drop tools in a
trial-and-error sort of way until he achieved the results he wanted,
all the while allowing his Gigabyte UEFI DualBIOS chips to restore
itself themselves as necessary when he fucked it up. The self-updating
UEFI script is apparently hosted and maintained by the kind of person
you'd expect on a forum; when I asked him about the hows and whys he
was unclear and knew only that it worked to upgrade his Intel RAID and
did so for everyone else as far as he knew and that was enough.

I read through all of this and I thought, "Hey, I'm that guy. Two of
my boards have buggy UEFI ROMs that haven't seen an update in a year;
I have a DualBIOS backup; ; I can illicitly acquire software if need
be; I can fuck things up, too!" As I said before, I'm not a
programmer; I just tinker. I follow step-by-step instructions to root
my android phones and pride myself on 20-lines of shell-script that
I'll sweat over for an hour until finally my zsh prompt reliably
presents me with a frowny-face following a non-zero exit code. And I
think I can roll linux in my system rom.

Obviously the system initialization stuff is well beyond my reach, but
I expect some success at least in an attempt at adding a small,
kexec-capable, EFI-stub kernel to flash. Some inspection reveals that
my Gigabyte board in particular has 700kb to spare even now, and
that's before I replace the full 1mb shell module it mysteriously
incorporates without providing any discernible means to load. Likely
there are other driver modules as well that I have either no need for
at boot (such as the option ROM for the flaky consumer-grade RAID
controller my board advertises), or even that the vendor shipped
bundled because it could in the available storage but that are only
applicable to options offered on other similar boards. I know there
can be an issue with some UEFI implementations when available storage
trickles close to nothing, but I should be able plan for the free 32kb
or 64kb necessary to avoid that. And of course there's always
DualBIOS.

So finally I'm down to the questions (if you've read this far I
applaud you for your perseverence in the face of boredom and thank you
for your super-human tolerance). Mostly I'd like to know what I've got
wrong so far? I feel like I shouldn't be alone in considering this
possibility but no amount of googling has surfaced reports of similar
experiments. Though iPXE forums occasionally discuss installing a UEFI
version of their loader they seem to indicate it should be done to the
option ROM of a PCI card as per usual. This mailing list comes close
with the recent lengthy back-and-forths about kexec and UEFI possibly
mapping over the kernel after exit-boot-services is called, but
neither that thread or any other I've discovered mentions in-ROM
installation. I assume I must have overlooked something very obvious
for it not to have seriously crossed the minds of others.

Also, if it were possible, what should I consider? (Other than the
real and present danger of bricking my board, of course.) Would I need
to incorporate a block and/or filesystem driver for the flash chip or
would UEFI's call of the kernel in flash fully map it to memory and
obviate that requirement? I've noticed UEFI has this nasty habit of
byte-coding anything and everything I do in the EFI shell; a "dh >
fs0:\handledump" for instance is perfectly human-readable in its shell
but after boot requires a decompile. Is this signifcant?

I imagine a small kernel incorporating only the barest of necessities
for IP boot and/or to find and mount a disk loaded as a UEFI driver
that could then either pick up capabilities as made available by an
initramfs image offered on its new mount or kexec completely into
another kernel. I think it can work, do you? Have you advice?
Admonishment? Ridicule? I welcome all input.

-Mike
