From: Qian Cai <cai@gmx.us>
Subject: [PATCH] efi: let kmemleak ignore false positives
Date: Thu, 29 Nov 2018 13:45:52 -0500
Message-ID: <1543517152-23969-1-git-send-email-cai@gmx.us>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ard.biesheuvel@linaro.org
Cc: marc.zyngier@arm.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Qian Cai <cai@gmx.us>
List-Id: linux-efi@vger.kernel.org

unreferenced object 0xffff8096c1acf580 (size 128):
  comm "swapper/63", pid 0, jiffies 4294937418 (age 1201.230s)
  hex dump (first 32 bytes):
    80 87 b5 c1 96 00 00 00 00 00 cc c2 16 00 00 00  ................
    00 00 01 00 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b  ........kkkkkkkk
  backtrace:
    [<000000001d2549ba>] kmem_cache_alloc_trace+0x430/0x500
    [<0000000093a6dfab>] efi_mem_reserve_persistent+0x50/0xf8
    [<000000000a730828>] its_cpu_init_lpis+0x394/0x4b8
    [<00000000edf04e07>] its_cpu_init+0x104/0x150
    [<000000004d0342c5>] gic_starting_cpu+0x34/0x40
    [<000000005d9da772>] cpuhp_invoke_callback+0x228/0x1d68
    [<0000000061eace9b>] notify_cpu_starting+0xc0/0x118
    [<0000000048bc2dc5>] secondary_start_kernel+0x23c/0x3b0
    [<0000000015137d6a>] 0xffffffffffffffff

efi_mem_reserve_persistent+0x50/0xf8:
kmalloc at include/linux/slab.h:546
(inlined by) efi_mem_reserve_persistent at drivers/firmware/efi/efi.c:979

This line,

rsv = kmalloc(sizeof(*rsv), GFP_ATOMIC);

Kmemleak has a known limitation that can only track pointers in the kernel
virtual space. Hence, it will report false positives due to "rsv" will only
reference to other physical addresses,

rsv->next = efi_memreserve_root->next;
efi_memreserve_root->next = __pa(rsv);

Signed-off-by: Qian Cai <cai@gmx.us>
---
 drivers/firmware/efi/efi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index fad7c62..0b69bb6 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -31,6 +31,7 @@
 #include <linux/acpi.h>
 #include <linux/ucs2_string.h>
 #include <linux/memblock.h>
+#include <linux/kmemleak.h>
 
 #include <asm/early_ioremap.h>
 
@@ -980,6 +981,8 @@ int efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 	if (!rsv)
 		return -ENOMEM;
 
+	kmemleak_ignore(rsv);
+
 	rsv->base = addr;
 	rsv->size = size;
 
-- 
1.8.3.1
