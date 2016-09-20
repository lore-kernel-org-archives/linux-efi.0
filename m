From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH] x86/efi: Round EFI memmap reservations to EFI_PAGE_SIZE
Date: Tue, 20 Sep 2016 15:46:50 +0100
Message-ID: <20160920144650.30615-2-matt@codeblueprint.co.uk>
References: <20160920144650.30615-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920144650.30615-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Mike Krinkin <krinkin.m.u@gmail.com>, Peter Jones <pjones@redhat.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>
List-Id: linux-efi@vger.kernel.org

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

Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Reported-by: Mike Krinkin <krinkin.m.u@gmail.com>
Tested-by: Mike Krinkin <krinkin.m.u@gmail.com>
Cc: Peter Jones <pjones@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
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
