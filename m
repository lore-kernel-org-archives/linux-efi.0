From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Wed, 16 Sep 2015 12:08:20 +0200
Message-ID: <20150916100820.GA7077@nazgul.tnic>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
 <20150907040752.GW13182@linux-rxt1.site>
 <20150908204147.GC2854@codeblueprint.co.uk>
 <20150909003307.GJ2266@linux-rxt1.site>
 <20150909112123.GB4973@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150909112123.GB4973@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: joeyli <jlee@suse.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Matt Fleming <matt.fleming@intel.com>, LeifLindholm@linux-rxt1.site, leif.lindholm@linaro.org, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@Odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>, stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Sep 09, 2015 at 12:21:23PM +0100, Matt Fleming wrote:
> On Wed, 09 Sep, at 08:33:07AM, joeyli wrote:
> >=20
> > Yes, the machine on my hand has EFI_PROPERTIES_TABLE enabled, and i=
t doesn't
> > boot without your patch.
>=20
> Awesome. Could you test the following patch instead?
>=20
> ---
>=20
> From 24d324b781a3b688dcc265995949a9cf4e8af687 Mon Sep 17 00:00:00 200=
1
> From: Matt Fleming <matt.fleming@intel.com>
> Date: Thu, 3 Sep 2015 15:56:25 +0100
> Subject: [PATCH v2] x86/efi: Map EFI memmap entries in-order at runti=
me
>=20
> Beginning with UEFI v2.5 EFI_PROPERTIES_TABLE was introduced that
> signals that the firmware PE/COFF loader supports splitting code and
> data sections of PE/COFF images into separate EFI memory map entries.
> This allows the kernel to map those regions with strict memory
> protections, e.g. EFI_MEMORY_RO for code, EFI_MEMORY_XP for data, etc=
=2E
>=20
> Unfortunately, an unwritten requirement of this new feature is that
> the regions need to be mapped with the same offsets relative to each
> other as observed in the EFI memory map. If this is not done crashes

Let me get this straight: this looks like the next EFI screwup which
practically requires specific mapping placement in VA space just
because it uses relative addresses? And since you say "unwritten" this
practically a requirement is not even in the spec?

Can we state explicitly in the spec NOT to rely on mapping VA placement=
?
I mean, this "unwritten" requirement is seriously screwed on soo many
levels...

What else are we to expect? Spelled out virtual addresses which are
going to be the EFI-allowed ones only??!

--=20
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Nort=
on, HRB 21284 (AG N=C3=BCrnberg)
--
