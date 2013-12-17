From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH 3/3] efi: Make efi virtual runtime map passing more robust
Date: Tue, 17 Dec 2013 13:51:56 +0000
Message-ID: <20131217135156.GC3145@console-pimps.org>
References: <1387236997-26975-1-git-send-email-bp@alien8.de>
 <1387236997-26975-4-git-send-email-bp@alien8.de>
 <20131217121024.GB3145@console-pimps.org>
 <20131217134006.GC30592@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131217134006.GC30592@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vivek Goyal <vgoyal@redhat.com>, Toshi Kani <toshi.kani@hp.com>, Arjan van de Ven <arjan@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

On Tue, 17 Dec, at 02:40:06PM, Borislav Petkov wrote:
> On Tue, Dec 17, 2013 at 12:10:24PM +0000, Matt Fleming wrote:
> > You sunk my i386 battleship,
> >=20
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:824:24: error: =E2=80=
=98struct real_mode_header=E2=80=99 has no member named =E2=80=98trampo=
line_pgd=E2=80=99
> > make[4]: *** [arch/x86/platform/efi/efi.o] Error 1
> > make[3]: *** [arch/x86/platform/efi] Error 2
>=20
> Right, this is a recurring issue with the trampoline_pgd. What do you
> prefer: an #ifdef CONFIG_X86_64 or a separate function in efi_$(BITS)=
=2Ec?

Couldn't we do the mapping in efi_setup_page_tables() if we pass
__pa(new_memmap) and 1 << new_memmap_shift as arguments?

--=20
Matt Fleming, Intel Open Source Technology Center
