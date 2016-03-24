From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v2] efi: Introduce EFI bootloader control driver
Date: Thu, 24 Mar 2016 14:47:41 +0000
Message-ID: <20160324144741.GA4328@codeblueprint.co.uk>
References: <1458295910-26557-1-git-send-email-daniel.baluta@intel.com>
 <20160318161505.GU2619@codeblueprint.co.uk>
 <1458328697.16385.21.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458328697.16385.21.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Stanacar, Stefan" <stefan.stanacar@intel.com>
Cc: "Baluta, Daniel" <daniel.baluta@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Abbas, Mohamed" <mohamed.abbas@intel.com>, "Gumbel, Matthew K" <matthew.k.gumbel@intel.com>, "Musca, Constantin" <constantin.musca@intel.com>, "Purdila, Octavian" <octavian.purdila@intel.com>, Darren Hart <dvhart@infradead.org>
List-Id: linux-efi@vger.kernel.org

(Sorry for the delay)

On Fri, 18 Mar, at 07:18:17PM, Stanacar, Stefan wrote:
>=20
> Hi Matt,
>=20
> It is possible, but that means modifying those userspace apps :)
> There are reboot implementations that do "reboot <reason>", such as
> Android's reboot command [1] and Upstart's reboot replacement [2], wh=
ich
> pass the reason as an argument to the reboot syscall.=A0
> Probably your first question will be - "Why don't you modify those
> apps?"

Your guess is correct ;)

> Well, I don't see platform-agnostic way how those could be
> modified to pass the reason to the bootloader, regardless of platform=
 or
> bootloader.

This is true. But then again, what you're proposing isn't boot loader
or platform agnostic anyway. Yes it's transparent to both the app and
boot loader, but it's only going to work on EFI platforms running
gummiboot.

And because of that, if this is going to be merged upstream I think
something like drivers/power/reset/ would be a more appropriate place,
or drivers/platform/x86.

If this does get merged, please rework the patch to use the efivar API
instead of accessing efi.set_variable() directly. We've also got a
bunch of ucs2 string functions in lib/ucs2_string.c that you could
use. In fact, this version of the driver I found on the net is much
more like what I had in mind,

  https://github.com/BORETS24/Kernel-for-Asus-Zenfone-2/blob/master/dri=
vers/external_drivers/drivers/platform/x86/reboot_target_uefi.c
