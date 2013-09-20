From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 00/11] EFI runtime services virtual mapping
Date: Fri, 20 Sep 2013 10:49:13 +0100
Message-ID: <20130920094913.GG4785@console-pimps.org>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20130920072904.GA21922@dhcp-16-126.nay.redhat.com>
 <20130920090544.GA9574@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130920090544.GA9574-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 20 Sep, at 11:05:44AM, Borislav Petkov wrote:
> > Another concern is that is it safe for i386 efi boot?
>=20
> That's why I didn't put a git tree on k.org - I wanted to run tests
> myself before Fengguang's robot :)
>=20
> But no, 32-bit is not addressed here. Which just dawned on me: Matt, =
I
> probably should keep the ioremapping code for 32-bit, doh. I complete=
ly
> went 64-bit only here :-)

/home/build/git/efi/arch/x86/platform/efi/efi.c: In function =E2=80=98_=
_map_region=E2=80=99:
/home/build/git/efi/arch/x86/platform/efi/efi.c:753:24: error: =E2=80=98=
struct real_mode_header=E2=80=99 has no member named =E2=80=98trampolin=
e_pgd=E2=80=99
/home/build/git/efi/arch/x86/platform/efi/efi.c: In function =E2=80=98e=
fi_enter_virtual_mode=E2=80=99:
/home/build/git/efi/arch/x86/platform/efi/efi.c:863:64: error: =E2=80=98=
struct real_mode_header=E2=80=99 has no member named =E2=80=98trampolin=
e_pgd=E2=80=99
/home/build/git/efi/arch/x86/platform/efi/efi.c:867:2: error: implicit =
declaration of function =E2=80=98efi_sync_low_kernel_mappings=E2=80=99
[-Werror=3Dimplicit-function-declaration]

--=20
Matt Fleming, Intel Open Source Technology Center
