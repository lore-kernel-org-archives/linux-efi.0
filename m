From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 7/8] arm64: apei: implement arch_apei_get_mem_attributes()
Date: Sat, 8 Aug 2015 10:39:22 +0200
Message-ID: <20150808083922.GB13912@gmail.com>
References: <20150806203232.GH4332@codeblueprint.co.uk>
 <1438936621-5215-7-git-send-email-matt@codeblueprint.co.uk>
 <20150807095009.GC2625@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150807095009.GC2625@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> On Fri, 07 Aug, at 09:37:00AM, Matt Fleming wrote:
> > From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
> > 
> > Table 8 of UEFI 2.5 section 2.3.6.1 defines mappings from EFI
> > memory types to MAIR attribute encodings for arm64.
> > 
> > If the physical address has memory attributes defined by EFI
> > memmap as EFI_MEMORY_[UC|WC|WT], return approprate page protection
> > type according to the UEFI spec. Otherwise, return PAGE_KERNEL.
> > 
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > Acked-by: Hanjun Guo <hanjun.guo@linaro.org>
> > Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> > Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> > ---
> >  arch/arm64/include/asm/acpi.h | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> > 
> 
> Ard Biesheuvel has brought up a concern with this patch and it's
> currently under discussion here,
> 
>   https://lkml.kernel.org/r/CAKv+Gu8+g3dTaNzXjSD=5GxproaHM+Eu1hLmRWp7cVrQimzbHQ@mail.gmail.com

Ok, I applied the patches up to this point, to tip:core/efi, to get the ball 
rolling - and will push them out after testing:

 8d446c8647c9 arm64/mm: Add PROT_DEVICE_nGnRnE and PROT_NORMAL_WT
 b40227fbfb1f acpi, x86: Implement arch_apei_get_mem_attributes()
 7bf793115dd9 efi, x86: Rearrange efi_mem_attributes()
 fa5c35011a8d Revert "x86/efi: Request desired alignment via the PE/COFF headers"
 248fbcd5aee0 x86/efi-bgrt: Switch pr_err() to pr_debug() for invalid BGRT
 87db73aebf55 efi: Add support for EFI_MEMORY_RO attribute introduced by UEFIv2.5

Let me know when the concerns are resolved or there are other patches to add.

Thanks,

	Ingo
