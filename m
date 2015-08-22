From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] acpi, apei: use appropriate pgprot_t to map GHES
 memory
Date: Sat, 22 Aug 2015 11:24:29 +0200
Message-ID: <20150822092429.GB18233@gmail.com>
References: <1439591850-29002-1-git-send-email-zjzhang@codeaurora.org>
 <1439591850-29002-2-git-send-email-zjzhang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1439591850-29002-2-git-send-email-zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel @ vger . kernel . org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi @ vger . kernel . org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:

> From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> 
> With ACPI APEI firmware first handling, generic hardware error
> record is updated by firmware in GHES memory region. On an arm64
> platform, firmware updates GHES memory region with uncached
> access attribute, and then Linux reads stale data from cache.

This paragraph *still* doesn't parse for me. It's not any English
I can recognize: what is a 'With ACPI APEI firmware first handling'?

> With current code, GHES memory region is mapped with PAGE_KERNEL
> based on the assumption that cache coherency of GHES memory region
> is maintained by firmware on all platforms. This assumption is
> not true for above mentioned arm64 platform.
> 
> Instead GHES memory region should be mapped with page protection type
> according to what is returned from arch_apei_get_mem_attribute().

... plus what this changelog still doesn't mention is the most important part of 
any bug fix description: how does the user notice this in practice and why does he 
care?

Thanks,

	Ingo
