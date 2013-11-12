From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: arm/arm64 UEFI boot protocol
Date: Wed, 13 Nov 2013 00:12:16 +0100
Message-ID: <20131112231216.GS1557@rocoto.smurfnet.nu>
References: <20131111174321.GQ1557@rocoto.smurfnet.nu>
 <20131112164241.GD25953@mudshark.cambridge.arm.com>
 <20131112180050.GR1557@rocoto.smurfnet.nu>
 <CACxGe6uCMjNiSm7qN4fTBN=WgzdJriod9d7qKOr-P-UaiWhULQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACxGe6uCMjNiSm7qN4fTBN=WgzdJriod9d7qKOr-P-UaiWhULQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, Olivier Martin <Olivier.Martin-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org" <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 13, 2013 at 07:14:28AM +0900, Grant Likely wrote:
> In the interest of bike shedding, I would name the properties
> "linux,uefi-mmap-start" and "linux,uefi-mmap-size", but otherwise it
> is fine by me.

That makes sense to me, and makes for a prettier table :)

> Should you have a property for the descriptor version
> as returned by GetMemoryMap()?
 
Yes, I should, really. I did in an earlier version, but dropped it on
realising that this value has not changed since the inception of EFI.
But it needs to be passed back to SetVirtualAddressMap(), so it should
be kept. Mark never dropped it from his.

So, "linux,uefi-mmap-desc-ver"?

/
    Leif
