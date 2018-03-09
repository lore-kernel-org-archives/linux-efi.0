From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 07/12] efi: Use efi_mm in x86 as well as ARM
Date: Fri, 9 Mar 2018 08:40:34 +0100
Message-ID: <20180309074034.put3ko6zxmaoizzr@gmail.com>
References: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
 <20180308080020.22828-8-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180308080020.22828-8-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Sai Praneeth <sai.praneeth.prakhya@intel.com>, linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Andy Lutomirski <luto@kernel.org>, "Michael S . Tsirkin" <mst@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
> 
> Presently, only ARM uses mm_struct to manage efi page tables and efi
> runtime region mappings. As this is the preferred approach, let's make
> this data structure common across architectures. Specially, for x86,
> using this data structure improves code maintainability and readability.

> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 85f6ccb80b91..00f977ddd718 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -2,10 +2,14 @@
>  #ifndef _ASM_X86_EFI_H
>  #define _ASM_X86_EFI_H
>  
> +#include <linux/sched/mm.h>
> +#include <linux/sched/task.h>
> +
>  #include <asm/fpu/api.h>
>  #include <asm/pgtable.h>
>  #include <asm/processor-flags.h>
>  #include <asm/tlb.h>
> +#include <asm/mmu_context.h>
>  
>  /*
>   * We map the EFI regions needed for runtime services non-contiguously,

> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index f5083aa72eae..f1b7d68ac460 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -966,6 +966,8 @@ extern struct efi {
>  	unsigned long flags;
>  } efi;
>  
> +extern struct mm_struct efi_mm;
> +
>  static inline int
>  efi_guidcmp (efi_guid_t left, efi_guid_t right)
>  {

Ugh, I can see three problems with this patch:

1)

Why is the low level asm/efi.h header polluted with two of the biggest header 
files in existence, to add a type to _another_ header (efi.h)?

2)

Why is <linux/sched/task.h> included if what is being relied on is mm_struct?

3)

But even <linux/sched/mm.h> looks unnecessary in efi.h, a simple forward 
declaration of mm_struct would do ...

The high level MM and sched headers should be added to the actual .c files that 
make use of them.

Thanks,

	Ingo
