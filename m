From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 1/5] x86/mm/pageattr: Ensure cpa->pfn only contains
 page frame numbers
Date: Mon, 16 Nov 2015 22:20:42 +0100
Message-ID: <20151116212042.GE20435@pd.tnic>
References: <1447538451-5793-1-git-send-email-matt@codeblueprint.co.uk>
 <1447538451-5793-2-git-send-email-matt@codeblueprint.co.uk>
 <alpine.DEB.2.11.1511162010120.3761@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1511162010120.3761@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ingo Molnar <mingo@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Dave Hansen <dave.hansen@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 16, 2015 at 09:19:01PM +0100, Thomas Gleixner wrote:
> On Sat, 14 Nov 2015, Matt Fleming wrote:
> > The x86 pageattr code is confused about the data that is stored
> > cpa->pfn, sometimes it's treated as a page frame number, sometimes
> > it's treated as an unshifted physical address, and in one place it'=
s
> > treated as a pte.
>=20
> Yuck.

This paragraph should read like this instead:

"Boris used cpa->pfn as a scratch variable to contain the physical
address. He realizes now that he should've added a separate
cpa_data.phys_addr then, instead of confusing everybody."

> > The result of this is that the mapping functions do not map the
> > intended physical address.
> >=20
> > This isn't a problem in practice because most of the addresses we'r=
e
> > mapping in the EFI code paths are already mapped in 'trampoline_pgd=
'
> > and so the pageattr mappings functions don't actually do anything i=
n
> > this case. But when we move to using a separate page table for the =
EFI
> > runtime this will be an issue.
>=20
> Are you sure that this does not affect existing kernel versions?

Shouldn't because with this new patchset we're copying all the PGDs fro=
m
the kernel page table before doing an EFI call, see
efi_sync_low_kernel_mappings() in patch 5.

> >  	while (num_pages-- && start < end) {
> > -
> > -		/* deal with the NX bit */
> > -		if (!(pgprot_val(pgprot) & _PAGE_NX))
> > -			cpa->pfn &=3D ~_PAGE_NX;
>=20
> That should be a seperate patch because this is just bogus code and
> has nothing to do with the pfn confusion.

Why bogus?

--=20
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Nort=
on, HRB 21284 (AG N=C3=BCrnberg)
--=20
