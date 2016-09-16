From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [tip regression]  efi: Allow drivers to reserve boot services
 forever == toxic
Date: Fri, 16 Sep 2016 15:30:07 +0100
Message-ID: <20160916143007.GF16797@codeblueprint.co.uk>
References: <1474005912.3930.10.camel@gmail.com>
 <20160916093149.GC16797@codeblueprint.co.uk>
 <1474020059.3881.3.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474020059.3881.3.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 16 Sep, at 12:00:59PM, Mike Galbraith wrote:
> 
> Ok, here's the whole thing just in case.  Hope it's not too big.
 
[...]

> [    0.000000] esrt: Reserving ESRT space from 0x00000000def87998 to 0x00000000def879d0.

OK, that's 56 bytes and yet I realise that at no point in the
efi_mem_reserve() call path do we round up to the nearest page size
even though the EFI memory map only deals with EFI_PAGE_SIZE regions.

Could you try this patch?

-------->8--------

>From a24b38999965808355c461f8490670266162eabf Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Date: Fri, 16 Sep 2016 15:12:47 +0100
Subject: [PATCH] x86/efi: Round EFI memmap reservations to EFI_PAGE_SIZE

Mike reported that his machine started rebooting during boot after,

  commit 8e80632fb23f ("efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()")

The ESRT table on his machine is 56 bytes and at no point in the
efi_arch_mem_reserve() call path is that size rounded up to
EFI_PAGE_SIZE.

Since the EFI memory map only deals with whole pages, inserting an EFI
memory region with 56 bytes results in a new entry covering zero
pages, and completely screws up the calculations for the old regions
that were trimmed.

Round all sizes upwards to the nearest EFI_PAGE_SIZE boundary.

Additionally, efi_memmap_insert() expects the mem::range::end value to
be one less than the end address for the region.

Reported-by: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/platform/efi/quirks.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index f14b7a9da24b..e881b4b2ffd6 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -201,8 +201,10 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 		return;
 	}
 
+	size = round_up(size, EFI_PAGE_SIZE);
+
 	mr.range.start = addr;
-	mr.range.end = addr + size;
+	mr.range.end = addr + size - 1;
 	mr.attribute = md.attribute | EFI_MEMORY_RUNTIME;
 
 	num_entries = efi_memmap_split_count(&md, &mr.range);
-- 
2.9.3
