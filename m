From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Date: Tue, 5 Aug 2014 13:51:30 +0200
Message-ID: <20140805135130.2d180b69@pluto>
References: <20140804113435.34ed8c76@pluto>
	<20140804122728.GH15082@console-pimps.org>
	<20140804150627.4563b6a7@pluto>
	<20140804135452.GJ15082@console-pimps.org>
	<20140805100242.425e1093@pluto>
	<20140805084542.GM15082@console-pimps.org>
	<20140805111330.3cf9319f@pluto>
	<20140805091848.GN15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140805091848.GN15082-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: P J P <ppandit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 5 Aug 2014 10:18:48 +0100 Matt Fleming wrote:
> On Tue, 05 Aug, at 11:13:30AM, Bruno Pr=C3=A9mont wrote:
> >=20
> > I get at least to just before
> >   status =3D efi_call_early(exit_boot_services, handle, key);
> > in eboot.c on line 1310. A efi_printk inserted there is displayed.
>=20
> This is worth pointing out in case you're unaware, but do you know th=
at
> it's not valid to call efi_printk() after ExitBootServices()? Doing s=
o
> will almost certainly cause your machine to fault.

I am aware that efi_printk() uses boot services!


Now I tried out loops at many places and have gotten up to line 340 in

  arch/x86/kernel/head_64.S

System reboots within the following assembler instructions (does not
reach line 359).

So efi_main() returns successfully but the assembler code following it
gets something wrong.

I'm going to try further to determine which line between 340 and 359 is
the "bad" one.

Bruno
