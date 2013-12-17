From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 3/3] efi: Make efi virtual runtime map passing more robust
Date: Tue, 17 Dec 2013 14:40:06 +0100
Message-ID: <20131217134006.GC30592@pd.tnic>
References: <1387236997-26975-1-git-send-email-bp@alien8.de>
 <1387236997-26975-4-git-send-email-bp@alien8.de>
 <20131217121024.GB3145@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131217121024.GB3145@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Linux EFI <linux-efi@vger.kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vivek Goyal <vgoyal@redhat.com>, Toshi Kani <toshi.kani@hp.com>, Arjan van de Ven <arjan@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 17, 2013 at 12:10:24PM +0000, Matt Fleming wrote:
> You sunk my i386 battleship,
>=20
> /home/build/git/efi/arch/x86/platform/efi/efi.c:824:24: error: =E2=80=
=98struct real_mode_header=E2=80=99 has no member named =E2=80=98trampo=
line_pgd=E2=80=99
> make[4]: *** [arch/x86/platform/efi/efi.o] Error 1
> make[3]: *** [arch/x86/platform/efi] Error 2

Right, this is a recurring issue with the trampoline_pgd. What do you
prefer: an #ifdef CONFIG_X86_64 or a separate function in efi_$(BITS).c=
?

--=20
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
