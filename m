From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [RFC] [PATCH] x86/efi: Adding efi_printks on memory allocationa
 and pci.reads
Date: Thu, 11 Sep 2014 09:08:41 +0100
Message-ID: <20140911080841.GH18582@console-pimps.org>
References: <20140906230251.140a99c9@bert>
 <20140907021133.7184c28c@bert>
 <20140908211856.GC18582@console-pimps.org>
 <20140910010022.21b2707b@bert>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140910010022.21b2707b@bert>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andre <andre.muller-S0/GAf8tV78@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 10 Sep, at 01:00:22AM, Andre wrote:
> All other calls to allocate memory seem to make some noise already, w=
ith the
> exception of two calls (for gop, uga) in the setup_graphics path.
>=20
> The purpose is to be noisy on worrysome errors immediately.
>=20
> > commit fb86b2440de0ec10fe0272eb19d262ae7a01adb8
> > Author: Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>
> > Date:   Thu Jul 10 02:12:41 2014 +0200
> >
> >     x86/efi: Add better error logging to EFI boot stub
>=20
> introduces printing false alarms for lots of hardware. Rather than pl=
aying
> Whack a Mole with non-fatal exit conditions, try the other way round.
=20
The usual way to reference existing commits is to quote the commit sha1
(abbreviated to 12-characters) with the patch subject in parenthesis an=
d
quotes, i.e. commit fb86b2440de0 ("x86/efi: Add better error logging to
EFI boot stub") - I fixed this up.

> This is per Matt Fleming's suggestion:
>=20
> > Where I think we could improve things
> > is by adding efi_printk() message in certain error paths. Clearly, =
not
> > all error paths need such messages, e.g. the EFI_INVALID_PARAMETER =
path
> > you highlighted above, but it makes sense for memory allocation and=
 PCI
> > read failures.
>=20
> http://article.gmane.org/gmane.linux.kernel.efi/4628
>=20
> After this, the status check on the setup_efi_pci() function
> can go away again.
>=20
> Signed-off-by: Andre M=FCller <andre.muller-S0/GAf8tV78@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c | 29 ++++++++++++++++++++++-------
>  1 file changed, 22 insertions(+), 7 deletions(-)

Patch looks good to me. Applied, thanks!

--=20
Matt Fleming, Intel Open Source Technology Center
