From: "Ghannam, Yazen" <Yazen.Ghannam-5C7GfCeVMHo@public.gmane.org>
Subject: RE: [PATCH 4.4 05/27] x86/efi: Build our own page table structures
Date: Tue, 12 Dec 2017 17:24:32 +0000
Message-ID: <BN6PR1201MB013116597F8BD048AD3080FDF8340@BN6PR1201MB0131.namprd12.prod.outlook.com>
References: <20171204155942.271814507@linuxfoundation.org>
 <20171204155942.482436478@linuxfoundation.org>
 <1512686629.18523.217.camel@codethink.co.uk>
 <20171210212651.GA18497@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171210212651.GA18497-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ben Hutchings <ben.hutchings-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Toshi
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> Sent: Sunday, December 10, 2017 4:27 PM
> To: Ben Hutchings <ben.hutchings-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>; Ghannam, Yazen
> <Yazen.Ghannam-5C7GfCeVMHo@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Matt Fleming
> <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>; Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>; Andrew
> Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>; Andy Lutomirski
> <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>; Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; Ard Biesheuvel
> <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>; Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>; Brian Gerst
> <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>; Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>; Denys
> Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>; Linus
> Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>; Peter Zijlstra
> <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>; Sai Praneeth Prakhya
> <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>;
> Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>; Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>;
> linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; Ghannam,
> Yazen <Yazen.Ghannam-5C7GfCeVMHo@public.gmane.org>; Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
> Subject: Re: [PATCH 4.4 05/27] x86/efi: Build our own page table structur=
es
>=20
> On Thu, Dec 07, 2017 at 10:43:49PM +0000, Ben Hutchings wrote:
> > On Mon, 2017-12-04 at 16:59 +0100, Greg Kroah-Hartman wrote:
> > > 4.4-stable review patch.=A0=A0If anyone has any objections, please le=
t me
> know.
> > >
> > > ------------------
> > >
> > > From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> > >
> > > commit 67a9108ed4313b85a9c53406d80dc1ae3f8c3e36 upstream.
> > [...]
> >
> > It looks like this will cause regressions unless you also apply:
> >
> > 21cdb6b56843 x86/mm: Page align the '_end' symbol to avoid pfn
> conversion bugs
> > b61a76f8850d x86/efi: Map RAM into the identity page table for mixed
> mode
> > 753b11ef8e92 x86/efi: Setup separate EFI page tables in kexec paths
> >
> > and possibly also:
> >
> > 08914f436bdd x86/platform/UV: Bring back the call to map_low_mmrs in
> uv_system_init
> > 683ad8092cd2 x86/efi: Fix 7-parameter efi_call()s
> > 80e75596079f efi: Convert efi_call_virt() to efi_call_virt_pointer()
> > d1be84a232e3 x86/uv: Update uv_bios_call() to use efi_call_virt_pointer=
()
>=20
> Ugh, that's a mess.  Yazen is the one who reported this patch, and 2
> others, were needed to resolve an issue on their hardware.
>=20
> Yazen, any thoughts here?  Should I just revert the 3 patches, or do you
> also feel I need all 7 of these to ensure everything works properly?
>=20

I think it's okay to revert the 3 patches.

Thanks,
Yazen
