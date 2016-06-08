From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [RFC PATCH v1 10/18] x86/efi: Access EFI related tables in the
 clear
Date: Wed, 8 Jun 2016 11:07:13 +0100
Message-ID: <20160608100713.GU2658@codeblueprint.co.uk>
References: <20160426225553.13567.19459.stgit@tlendack-t1.amdoffice.net>
 <20160426225740.13567.85438.stgit@tlendack-t1.amdoffice.net>
 <20160510134358.GR2839@codeblueprint.co.uk>
 <20160510135758.GA16783@pd.tnic>
 <5734C97D.8060803@amd.com>
 <57446B27.20406@amd.com>
 <20160525193011.GC2984@codeblueprint.co.uk>
 <5746FE16.9070408@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5746FE16.9070408@amd.com>
Sender: linux-doc-owner@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Salter <msalter@redhat.com>, Daniel Kiper <daniel.kiper@oracle.com>, linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.>
List-Id: linux-efi@vger.kernel.org

(Sorry for the delay)

On Thu, 26 May, at 08:45:58AM, Tom Lendacky wrote:
> 
> The patch in question is patch 6/18 where PAGE_KERNEL is changed to
> include the _PAGE_ENC attribute (the encryption mask). This now
> makes FIXMAP_PAGE_NORMAL contain the encryption mask while
> FIXMAP_PAGE_IO does not. In this way, anything mapped using the
> early_ioremap call won't be mapped encrypted.

There are semantics attached to early_ioremap() that do not apply in
this case; that you're mapping an MMIO region but for EFI we just care
about noting where the firmware (not the kernel) populated the region
with data. Similar problems exist for other early boot code such as
the devicetree stuff.

early_ioremap() is not the answer.

What you really want is just some way to distinguish kernel-owned
regions from those owned by "somebody else".

I have no problem updating early_memremap() to take a @flags argument
to make that distinction, provided that the naming is generic and not
tied to AMD's SME technology via an "sme" prefix/suffix.

And making it generic should allow it to be easily sprinkled into the
shared architecture code in drivers/firmware/efi/ without issue.

I'm going to follow up with some additional comments/questions on
PATCH 10.
