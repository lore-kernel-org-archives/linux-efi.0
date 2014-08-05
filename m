From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Date: Tue, 5 Aug 2014 14:11:42 +0200
Message-ID: <20140805141142.437ecb17@pluto>
References: <20140804113435.34ed8c76@pluto>
	<20140804122728.GH15082@console-pimps.org>
	<20140804150627.4563b6a7@pluto>
	<20140804135452.GJ15082@console-pimps.org>
	<20140805100242.425e1093@pluto>
	<20140805084542.GM15082@console-pimps.org>
	<20140805111330.3cf9319f@pluto>
	<20140805091848.GN15082@console-pimps.org>
	<20140805135130.2d180b69@pluto>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140805135130.2d180b69@pluto>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: P J P <ppandit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 5 Aug 2014 13:51:30 +0200 Bruno Pr=C3=A9mont wrote:

> On Tue, 5 Aug 2014 10:18:48 +0100 Matt Fleming wrote:
> > On Tue, 05 Aug, at 11:13:30AM, Bruno Pr=C3=A9mont wrote:
> > >=20
> > > I get at least to just before
> > >   status =3D efi_call_early(exit_boot_services, handle, key);
> > > in eboot.c on line 1310. A efi_printk inserted there is displayed=
=2E
> >=20
> > This is worth pointing out in case you're unaware, but do you know =
that
> > it's not valid to call efi_printk() after ExitBootServices()? Doing=
 so
> > will almost certainly cause your machine to fault.
>=20
> I am aware that efi_printk() uses boot services!
>=20
>=20
> Now I tried out loops at many places and have gotten up to line 340 i=
n
>=20
>   arch/x86/kernel/head_64.S

oops, bad copy&paste, should have been
  arch/x86/boot/compressed/head_64.S

> System reboots within the following assembler instructions (does not
> reach line 359).
>=20
> So efi_main() returns successfully but the assembler code following i=
t
> gets something wrong.
>=20
> I'm going to try further to determine which line between 340 and 359 =
is
> the "bad" one.

arch/x86/boot/compressed/head_64.S
341 /*
342  * Copy the compressed kernel to the end of our buffer
343  * where decompression in place becomes safe.
344  */
345         pushq   %rsi
346         leaq    (_bss-8)(%rip), %rsi
347         leaq    (_bss-8)(%rbx), %rdi
348         movq    $_bss /* - $startup_32 */, %rcx
349         shrq    $3, %rcx
350         std

code gets up to here

351         rep     movsq

this location is never reached but instead system reboots

352         cld
353         popq    %rsi
354=20
355 /*     =20
356  * Jump to the relocated address.
357  */
=20


Bruno
