From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Fri, 8 Dec 2017 00:02:38 +0100
Message-ID: <20171207230238.GW729@wotan.suse.de>
References: <20171111023240.2398ca55@alans-desktop>
 <20171113174250.GA22894@wotan.suse.de>
 <20171113210848.4dc344bd@alans-desktop>
 <454.1510609487@warthog.procyon.org.uk>
 <CA+55aFzrK29hbxoKs3GsvVUY4_uR7aBgZv2eeVyVq7MzfATY3w@mail.gmail.com>
 <1510662098.3711.139.camel@linux.vnet.ibm.com>
 <CA+55aFzvuvqOfsJ9arzcc1QbTGs+U-TsNmsyem9UAVVQC8YkZQ@mail.gmail.com>
 <CACdnJuvP=0AHGtfGJ5+cT+kHRy3fU4BLjwkvzP0rLO6q5ejAQQ@mail.gmail.com>
 <CA+55aFxeLwgwxh2iJTf6Dz0T_a_TZfTdhBw5TkcSsCmjt2N5pw@mail.gmail.com>
 <20171205102757.GA12982@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171205102757.GA12982@amd>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jan Blunck <jblunck-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, Marcus Meissner <meissner-l3A5Bk7waGM@public.gmane.org>, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 05, 2017 at 11:27:58AM +0100, Pavel Machek wrote:
> Hi!
> 
> > > Our ability to determine that userland hasn't been tampered with
> > > depends on the kernel being trustworthy. If userland can upload
> > > arbitrary firmware to DMA-capable devices then we can no longer trust
> > > the kernel. So yes, firmware is special.
> > 
> > You're ignoring the whole "firmware is already signed by the hardware
> > manufacturer and we don't even have access to it" part.
> 
> Well... I guess we'd prefer the firmware _not_ be signed, so we can
> fix security holes in that after the vendor lost interest... Bugs in
> the wifi stacks seemed patcheable that way.
> 
> There is GPLed firmware available for some USB wifi's. We really
> should make sure firmware signing is not mandatory/encouraged for the hw vendors.

I share this concern and interest, specially as more device drivers get purposely
stupid and most of the technology and fun things shift to firmware. Its precisely
for this same reason why most manufacturers won't be opening up more firmware, as
they could argue tons of value-add is in firmware now.

One has to be realistic though, as one of the few folks who pushed to open
source (and GPL) a few of the open source firmwares we have for WiFi, I realize
we have no option but to accept the fate that most manufacturers *will*
use and require signed firmware in the future.

If you're concerned about this you have only a few options.

One is to get more and more folks reverse engineer firmware. This won't help
if you can't deploy unsigned firmware though. But you have to also look at it
from a practical point of view, in order to do development you *have* to have
some sort of knobs to turn off fw signing verification, so it should be a
matter of looking hard. And for devices where this is not obvious or almost
impossible, hope for an exploit.

Another option is to argue for the engineering gain for having open firmware,
and a viable sensible and responsible option to continue to do R&D and innovation
with open firmware. We did this with WiFi long ago, see CFG80211_CERTIFICATION_ONUS
and the slew of open firmware released. The fact that we have open firmware
repositories and also a respective proprietary firmwares for the same device
could be used to metrically show the gains that such development had over time,
in a quantifiable form (features, bug fixes, security issues fixed). There's
tons of data available which could enable a researcher to have a field with
this.

And the last option is to just argue for a sensible opt-out knob to be documented
as part of our rights or due to general long term community security interests.
Just as with UEFI one can say one does not trust any key present already on the
platform, one should also be able to do the same for peripheral devices and their
own corresponding firmware -- a knob to disable firmware signing.

Sadly *all* of these are lofty pie in the sky objectives.

What the likely outcome will be is we sit and wait for the worst of the possible
security shit issues to hit the fan for the large IoT universe, and then hope
we can use this as leverage to require documenting such opt-out knobs just as
with UEFI's opt-out mechanism.

Although one would expect that such exploits already have happened, in practice
not at the interface we're talking about here, which is for /lib/firmware/.
For instance the Intel Management Engine does not use this interface, and
neither do some of the storage driver and arrays I've been bluntly told have
had tons of backdoors for years. Its precisely because of this lack of known
issues with security for /lib/firmware exploits that I'm willing to put signing
of /lib/firmware on the side for now.

We just haven't had many known attacks come in through here.

  Luis
