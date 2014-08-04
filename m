From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Date: Mon, 4 Aug 2014 15:06:27 +0200
Message-ID: <20140804150627.4563b6a7@pluto>
References: <20140804113435.34ed8c76@pluto>
	<20140804122728.GH15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140804122728.GH15082-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: P J P <ppandit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Matt,

On Mon, 4 Aug 2014 13:27:28 +0100 Matt Fleming wrote:
> On Mon, 04 Aug, at 11:34:35AM, Bruno Pr=C3=A9mont wrote:
> > Hi,
> >=20
> > Since 3.13 kernels with built-in initrd fail to boot on Fujitsu har=
dware
> > in EFI mode (efi stub) though the exact same kernel binary does boo=
t in
> > BIOS mode (grub).
> > Interestingly EFI kernels with different config do boot under VMWar=
e.
> >=20
> > Your patch "initramfs: read CONFIG_RD_ variables for initramfs
> > compression" is the trigger.
> >=20
> >=20
> > Is something missing in EFI stub or why do things behave differentl=
y?
> =20
> Nuts. I suspect it's an EFI boot stub bug. Have you definitely tried =
out
> 3.16? In particular the following commit might make a difference,
>
>   commit c7fb93ec51d4
>   Author: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
>   Date:   Thu Jul 10 12:26:20 2014 +0100
>=20
>       x86/efi: Include a .bss section within the PE/COFF headers
>    =20
>       The PE/COFF headers currently describe only the initialised-dat=
a
>       portions of the image, and result in no space being allocated f=
or the
>       uninitialised-data portions.  Consequently, the EFI boot stub w=
ill end
>       up overwriting unexpected areas of memory, with unpredictable r=
esults.
>    =20
>       Fix by including a .bss section in the PE/COFF headers (functio=
nally
>       equivalent to the init_size field in the bzImage header).
>    =20
>       Signed-off-by: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
>       Cc: Thomas B=C3=A4chler <thomas-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
>       Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
>       Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>       Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Yes, I did as I have seen that patch flying by, but it did not help
(I tried at 3.16-rc7).

On 3.16-rc7 I even tried adding earlyprintk=3Defi,keep, console=3Defi,
ignore_loglevel and added some efi_printk() in EFI stub (in the spirit
of https://bugzilla.kernel.org/show_bug.cgi?id=3D68761)
The last message I get is my efi_printk() right before exiting boot
services. Without my efi_printk() there is no output at all.

Then system reboots.

There is no output on serial console either (via BMC),
(earlycon=3Duart,io,0x3f8,115200 or earlyprintk=3Dserial,ttyS0,115200)


I even tried without initrd (setting CONFIG_INITRAMFS_SOURCE=3D"")
and got the same end-result.

> > Looking at compiled kernel with and without this patch the resultin=
g
> > bzImage is similar in size but in build directory I get:
>=20
> Could you send me the initrd image? I'd like to try and reproduce thi=
s
> on my end, even though I regularly boot with a built-in initrd.

I could share a slightly modified one, replacing the
contained /etc/passwd. It's about 16MiB in size due to RAID controller
management blobs for recovery. Except for that it just tries to find
ROOT partition, setting up dmcrypt if needed.


Note: System is Fujitsu Primergy RX200 S7 server, BIOS revisions
tested: R2.21.0 and R2.25.0.
The same initrd works on Fujitsu laptop (Lifebook U904, EFI, other kern=
el
config) works though.



Any hint on how to find out what fails would be nice!
initrd issues tend not to be easy to debug (it would help if initrd
issues could be reported at the time kernel tries to start init - e.g.
when console outputs are up and running).


Bruno
