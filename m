From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 7/8] arm64: apei: implement arch_apei_get_mem_attributes()
Date: Fri, 7 Aug 2015 10:50:09 +0100
Message-ID: <20150807095009.GC2625@codeblueprint.co.uk>
References: <20150806203232.GH4332@codeblueprint.co.uk>
 <1438936621-5215-7-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438936621-5215-7-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 07 Aug, at 09:37:00AM, Matt Fleming wrote:
> From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> 
> Table 8 of UEFI 2.5 section 2.3.6.1 defines mappings from EFI
> memory types to MAIR attribute encodings for arm64.
> 
> If the physical address has memory attributes defined by EFI
> memmap as EFI_MEMORY_[UC|WC|WT], return approprate page protection
> type according to the UEFI spec. Otherwise, return PAGE_KERNEL.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> Acked-by: Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/arm64/include/asm/acpi.h | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 

Ard Biesheuvel has brought up a concern with this patch and it's
currently under discussion here,

  https://lkml.kernel.org/r/CAKv+Gu8+g3dTaNzXjSD=5GxproaHM+Eu1hLmRWp7cVrQimzbHQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org

-- 
Matt Fleming, Intel Open Source Technology Center
