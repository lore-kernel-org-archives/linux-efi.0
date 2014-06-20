From: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 2/7] efi: Introduce EFI_NO_DIRECT flag
Date: Fri, 20 Jun 2014 16:36:51 +0200
Message-ID: <20140620143651.GE28489@olila.local.net-space.pl>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-3-git-send-email-daniel.kiper@oracle.com>
 <20140618135229.GH24049@console-pimps.org>
 <20140618164835.GD28489@olila.local.net-space.pl>
 <20140619144112.GT24049@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140619144112.GT24049-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 19, 2014 at 03:41:12PM +0100, Matt Fleming wrote:
> On Wed, 18 Jun, at 06:48:35PM, Daniel Kiper wrote:
> > >
> > > Why don't you want to export efi.fw_vendor, etc? Rationale please.
> >
> > I am exporting real addresses (machine addresses) of things which
> > I am able to get. Stuff which was created artificially and lives
> > in dom0 address space or does not exist are not exported.
>
> So, wouldn't it be easier to just leave those fields as
> EFI_INVALID_TABLE_ADDR? If they're not usable why fill out an address?

It looks that EFI_PARAVIRT check is needed for efi.fw_vendor only.
Probably I prepared this chunk of code before filling
efi_systab_xen.runtime with EFI_INVALID_TABLE_ADDR. efi.fw_vendor
contains pointer to vendor name which lives in dom0 memory and it
is a copy of name living in EFI memory data. So, this pointer is useless
for potential user of /sys/firmware/efi/fw_vendor. efi.fw_vendor is
used in init code only. Hence, I was thinking once about wiping this
pointer with EFI_INVALID_TABLE_ADDR. However, it requires some changes
in arch/x86/platform/efi/efi.c (wipe it if EFI_PARAVIRT is set) and
it is a hack for me. I prefer to live with current solution.

> > Hmmm... I do not know what is wrong with this minimal shuffling. We are
> > playing here with internal stuff which is not visible outside of any
> > given kernel. Additionally, as I saw in a few places arch bits are
> > defined in following way:
> >
> > #define ARCH_1 10
> >
> > #define A_ARCH_CONST ARCH_1
> > #define B_ARCH_CONST (ARCH_1 + 1)
> > #define C_ARCH_CONST (ARCH_1 + 2)
> > ...
> >
> > So I think addition is more natural here than subtraction.
>
> No, because we hit the same problem if we need more non-arch bits after
> bit 9, it moves the problem, it doesn't fix it. Though admittedly, using

10 is just an example. It could be an arbitrary value. However, you
are right. This just moves the problem.

> this level of indirection (going through ARCH_1) instead of using
> constants does reduce the problem.
>
> Yes, these bits are internal, and yes the shuffling is minimal, but we
> can do better.

As always, it is a place for an improvement. However, I am not sure
it is worth fighting with that so hard.

> I'm not suggesting you need to modify your patch. I'm really just
> thinking out loud. I'll take care of fixing this up later.

OK. Thanks.

Daniel
