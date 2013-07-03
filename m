From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH -v2 4/4] x86, efi: Map runtime services 1:1
Date: Wed, 03 Jul 2013 14:19:03 +0800
Message-ID: <1372832343.26878.6.camel@linux-s257.site>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
	 <1371491416-11037-5-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1371491416-11037-5-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=80=EF=BC=8C2013-06-17 =E6=96=BC 19:50 +0200=EF=BC=8CBo=
rislav Petkov =E6=8F=90=E5=88=B0=EF=BC=9A
> +#ifdef CONFIG_X86_64
> +               efi_scratch.pgt11 =3D (pgd_t *)(unsigned long)real_mo=
de_header->trampoline_pgd;
> +#endif
> +               efi_use_11_map =3D true;
> +=20

I think "efi_use_11_map =3D true" should moved to before "#endif",
otherwise kernel will build fail on i586 architecture.

I got build error:
arch/x86/platform/efi/efi.c:1074: error: =E2=80=98efi_use_11_map=E2=80=99=
 undeclared (first use in this function)
arch/x86/platform/efi/efi.c:1074: error: (Each undeclared identifier is=
 reported only once
arch/x86/platform/efi/efi.c:1074: error: for each function it appears i=
n.)


Thanks a lot!
Joey Lee
