From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86/mm/pageattr: Avoid truncation when converting
 cpa->numpages to address
Date: Fri, 29 Jan 2016 13:05:21 +0100
Message-ID: <20160129120521.GE10187@pd.tnic>
References: <1454067370-10374-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454067370-10374-1-git-send-email-matt@codeblueprint.co.uk>
Sender: stable-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, stable@vger.kernel.org, =?utf-8?B?VmlvcmVsLUPEg3TEg2xpbiBSxINwacibZWFudQ==?= <rapiteanu.catalin@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Jan 29, 2016 at 11:36:10AM +0000, Matt Fleming wrote:
> There are a couple of nasty truncation bugs lurking in the pageattr
> code that can be triggered when mapping EFI regions, e.g. when we pas=
s
> a cpa->pgd pointer. Because cpa->numpages is a 32-bit value, shifting
> left by PAGE_SHIFT will truncate the resultant address to 32-bits.
>=20
> Viorel-C=C4=83t=C4=83lin managed to trigger this bug on his Dell mach=
ine that
> provides a ~5GB EFI region which requires 1236992 pages to be mapped.

They're going to need all that?! Of course they do!

> When calling populate_pud() the end of the region gets calculated
> incorrectly in the following buggy expression,
>=20
>   end =3D start + (cpa->numpages << PAGE_SHIFT);
>
> And only 188416 pages are mapped. Next, populate_pud() gets invoked
> for a second time because of the loop in __change_page_attr_set_clr()=
,
> only this time no pages get mapped because shifting the remaining
> number of pages (1048576) by PAGE_SHIFT is zero. At which point the
> loop in __change_page_attr_set_clr() spins forever because we fail to
> map progress.
>=20
> Hitting this bug depends very much on the virtual address we pick to
> map the large region at and how many pages we map on the initial run
> through the loop. This explains why this issue was only recently hit
> with the introduction of commit
>=20
>   a5caa209ba9c ("x86/efi: Fix boot crash by mapping EFI memmap entrie=
s bottom-up at runtime, instead of top-down")
>=20
> It's interesting to note that safe uses of cpa->numpages do exist in
> the pageattr code. If instead of shifting ->numpages we multiply by
> PAGE_SIZE, no truncation occurs because PAGE_SIZE is a UL value, and
> so the result is unsigned long.
>=20
> To avoid surprises when users try to convert very large cpa->numpages
> values to addresses, change the data type from 'int' to 'unsigned
> long', thereby making it suitable for shifting by PAGE_SHIFT without
> any type casting.
>=20
> The alternative would be to make liberal use of casting, but that is
> far more likely to cause problems in the future when someone adds mor=
e
> code and fails to cast properly; this bug was difficult enough to
> track down in the first place.
>=20
> Reported-by: Viorel-C=C4=83t=C4=83lin R=C4=83pi=C8=9Beanu <rapiteanu.=
catalin@gmail.com>
> Tested-by: Viorel-C=C4=83t=C4=83lin R=C4=83pi=C8=9Beanu <rapiteanu.ca=
talin@gmail.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D110131
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>

Acked-by: Borislav Petkov <bp@suse.de>

--=20
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
