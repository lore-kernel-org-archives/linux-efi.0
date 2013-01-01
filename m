From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] arch: x86: boot: compressed: eboot: fix cast warnings
 on 32b platforms
Date: Tue, 01 Jan 2013 09:34:16 -0800
Message-ID: <50E31E18.5010404@zytor.com>
References: <1356171805-16930-1-git-send-email-hasko.stevo@gmail.com> <20121226080019.GB11555@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121226080019.GB11555-f9CnO7I+Q6zU6FkGJEIX5A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Stefan Hasko <hasko.stevo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 12/26/2012 12:00 AM, Borislav Petkov wrote:
> On Sat, Dec 22, 2012 at 11:23:25AM +0100, Stefan Hasko wrote:
>> Fixed different size cast warnings in function setup_efi_pci
>>
>> Signed-off-by: Stefan Hasko <hasko.stevo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> You might want to add the actual compiler warnings to the commit
> message:
>=20
> arch/x86/boot/compressed/eboot.c: In function =E2=80=98setup_efi_pci=E2=
=80=99:
> arch/x86/boot/compressed/eboot.c:259:9: warning: cast to pointer from=
 integer of different size [-Wint-to-pointer-cast]
> arch/x86/boot/compressed/eboot.c:262:10: warning: cast to pointer fro=
m integer of different size [-Wint-to-pointer-cast]
> arch/x86/boot/compressed/eboot.c:348:17: warning: cast from pointer t=
o integer of different size [-Wpointer-to-int-cast]
> arch/x86/boot/compressed/eboot.c:350:29: warning: cast from pointer t=
o integer of different size [-Wpointer-to-int-cast]
>=20
> And yes, I see them in all{mod,yes}config builds here too. The issue,
> AFAICT, is that setup_data is __u64 to obviously accomodate 8-byte
> pointers on x86-64 but on 32-bit they're half the size. And we obviou=
sly
> cannot change struct setup_data since this is an ABI so I'd guess the
> casts to native pointer sizes are ok. So
>=20
> Acked-by: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
>=20

Yes, but stylistically: we don't use uintptr_t in Linux, but rather
"unsigned long".

	-hpa
