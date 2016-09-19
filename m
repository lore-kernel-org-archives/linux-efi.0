From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [tip regression]  efi: Allow drivers to reserve boot services
 forever == toxic
Date: Mon, 19 Sep 2016 12:15:31 +0100
Message-ID: <20160919111531.GC2892@codeblueprint.co.uk>
References: <1474005912.3930.10.camel@gmail.com>
 <20160916093149.GC16797@codeblueprint.co.uk>
 <1474020059.3881.3.camel@gmail.com>
 <20160916143007.GF16797@codeblueprint.co.uk>
 <1474043695.3854.3.camel@gmail.com>
 <20160917195853.GG16797@codeblueprint.co.uk>
 <1474178972.3817.2.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474178972.3817.2.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 18 Sep, at 08:09:32AM, Mike Galbraith wrote:
> 
> +MATT changes + XXX changes (boots/works without #if 0)
> [    0.000000] MIKE md.phys_addr:0xded81000  md.virt_addr:0x0  md.num_pages:520
> [    0.000000] MIKE mr.range.start:0xdef87000  mr.range.end:0xdef87fff
> [    0.000000] MIKE efi_memmap_install(0x9d640, 51);

Brilliant. This is what I've got queued up. Thanks everyone.

----8<----

>From 7e750e3289a44fe3ad693bde45aea1ad8577dd2a Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Date: Fri, 16 Sep 2016 15:12:47 +0100
Subject: [PATCH] x86/efi: Round EFI memmap reservations to EFI_PAGE_SIZE

Mike Galbraith reported that his machine started rebooting during boot
after,

  commit 8e80632fb23f ("efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()")

The ESRT table on his machine is 56 bytes and at no point in the
efi_arch_mem_reserve() call path is that size rounded up to
EFI_PAGE_SIZE, nor is the start address on an EFI_PAGE_SIZE boundary.

Since the EFI memory map only deals with whole pages, inserting an EFI
memory region with 56 bytes results in a new entry covering zero
pages, and completely screws up the calculations for the old regions
that were trimmed.

Round all sizes upwards, and start addresses downwards, to the nearest
EFI_PAGE_SIZE boundary.

Additionally, efi_memmap_insert() expects the mem::range::end value to
be one less than the end address for the region.

Reported-by: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Mike Krinkin <krinkin.m.u-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/platform/efi/quirks.c |  6 +++++-
 drivers/firmware/efi/memmap.c  | 11 +++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index f14b7a9da24b..10aca63a50d7 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -201,8 +201,12 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 		return;
 	}
 
+	size += addr % EFI_PAGE_SIZE;
+	size = round_up(size, EFI_PAGE_SIZE);
+	addr = round_down(addr, EFI_PAGE_SIZE);
+
 	mr.range.start = addr;
-	mr.range.end = addr + size;
+	mr.range.end = addr + size - 1;
 	mr.attribute = md.attribute | EFI_MEMORY_RUNTIME;
 
 	num_entries = efi_memmap_split_count(&md, &mr.range);
diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
index cd96086fd851..f03ddecd232b 100644
--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -225,6 +225,17 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
 	m_end = mem->range.end;
 	m_attr = mem->attribute;
 
+	/*
+	 * The EFI memory map deals with regions in EFI_PAGE_SIZE
+	 * units. Ensure that the region described by 'mem' is aligned
+	 * correctly.
+	 */
+	if (!IS_ALIGNED(m_start, EFI_PAGE_SIZE) ||
+	    !IS_ALIGNED(m_end + 1, EFI_PAGE_SIZE)) {
+		WARN_ON(1);
+		return;
+	}
+
 	for (old = old_memmap->map, new = buf;
 	     old < old_memmap->map_end;
 	     old += old_memmap->desc_size, new += old_memmap->desc_size) {
-- 
2.9.3
