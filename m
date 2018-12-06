From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RESEND PATCH] efi: let kmemleak ignore false positives
Date: Thu, 6 Dec 2018 17:59:58 +0000
Message-ID: <20181206175958.GS54495@arrakis.emea.arm.com>
References: <1543517152-23969-1-git-send-email-cai@gmx.us>
 <20181206161633.36292-1-cai@gmx.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181206161633.36292-1-cai@gmx.us>
Sender: linux-kernel-owner@vger.kernel.org
To: Qian Cai <cai@gmx.us>
Cc: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, marc.zyngier@arm.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, Dec 06, 2018 at 11:16:33AM -0500, Qian Cai wrote:
> unreferenced object 0xffff8096c1acf580 (size 128):
>   comm "swapper/63", pid 0, jiffies 4294937418 (age 1201.230s)
>   hex dump (first 32 bytes):
>     80 87 b5 c1 96 00 00 00 00 00 cc c2 16 00 00 00  ................
>     00 00 01 00 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b  ........kkkkkkkk
>   backtrace:
>     [<000000001d2549ba>] kmem_cache_alloc_trace+0x430/0x500
>     [<0000000093a6dfab>] efi_mem_reserve_persistent+0x50/0xf8
>     [<000000000a730828>] its_cpu_init_lpis+0x394/0x4b8
>     [<00000000edf04e07>] its_cpu_init+0x104/0x150
>     [<000000004d0342c5>] gic_starting_cpu+0x34/0x40
>     [<000000005d9da772>] cpuhp_invoke_callback+0x228/0x1d68
>     [<0000000061eace9b>] notify_cpu_starting+0xc0/0x118
>     [<0000000048bc2dc5>] secondary_start_kernel+0x23c/0x3b0
>     [<0000000015137d6a>] 0xffffffffffffffff
> 
> efi_mem_reserve_persistent+0x50/0xf8:
> kmalloc at include/linux/slab.h:546
> (inlined by) efi_mem_reserve_persistent at drivers/firmware/efi/efi.c:979
> 
> This line,
> 
> rsv = kmalloc(sizeof(*rsv), GFP_ATOMIC);
> 
> Kmemleak has a known limitation that can only track pointers in the kernel
> virtual space. Hence, it will report false positives due to "rsv" will only
> reference to other physical addresses,
> 
> rsv->next = efi_memreserve_root->next;
> efi_memreserve_root->next = __pa(rsv);
> 
> Signed-off-by: Qian Cai <cai@gmx.us>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
