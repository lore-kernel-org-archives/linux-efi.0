From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V3 1/3] x86/mm/pageattr: Introduce helper function to
 unmap EFI boot services
Date: Sun, 4 Nov 2018 20:17:20 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485EAD5A@ORSMSX114.amr.corp.intel.com>
References: <20181104201019.26142-1-sai.praneeth.prakhya@intel.com>
 <20181104201019.26142-2-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181104201019.26142-2-sai.praneeth.prakhya@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

> Ideally, after kernel assumes control of the platform, firmware shouldn't access
> EFI boot services code/data regions. But, it's noticed that this is not so true in
> many x86 platforms. Hence, during boot, kernel reserves EFI boot services
> code/data regions [1] and maps [2] them to efi_pgd so that call to
> set_virtual_address_map() doesn't fail.
> After returning from set_virtual_address_map(), kernel frees the reserved
> regions [3] but they still remain mapped. Hence, introduce
> kernel_unmap_pages_in_pgd() which will later be used to unmap EFI boot
> services code/data regions.
> 
> While at it modify kernel_map_pages_in_pgd() by 1. Adding __init modifier
> because it's always used *only* during boot.
> 2. Add a warning if it's used after SMP is initialized because it uses
>    __flush_tlb_all() which flushes mappings only on current CPU.
> 
> Unmapping EFI boot services code/data regions will result in clearing
> PAGE_PRESENT bit and it shouldn't bother L1TF cases because it's already
> handled by protnone_mask() at arch/x86/include/asm/pgtable-invert.h.
> 
> [1] efi_reserve_boot_services()
> [2] efi_map_region() -> __map_region() -> kernel_map_pages_in_pgd() [3]
> efi_free_boot_services()
> 
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Bhupesh Sharma <bhsharma@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Wasn't sure (and hence didn't) if I should add Acked-by Ingo because this patch changed from V2.

Regards,
Sai
