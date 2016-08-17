From: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2] x86/efi: defer efi_esrt_init until after memblock_x86_fill
Date: Tue, 16 Aug 2016 17:32:31 -0700
Message-ID: <1471393951-28804-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Scott Lawson <scott.lawson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Commit 7b02d53e7852 ("efi: Allow drivers to reserve boot services forever")
introduced a new efi_mem_reserve to reserve the boot services memory
regions forever. This reservation involves allocating a new EFI memory
range descriptor. However, allocation can only succeed if there is memory
available for the allocation. Otherwise, error such as the following may
occur:

esrt: Reserving ESRT space from 0x000000003dd6a000 to 0x000000003dd6a010.
Kernel panic - not syncing: ERROR: Failed to allocate 0x9f0 bytes below \
 0x0.
CPU: 0 PID: 0 Comm: swapper Not tainted 4.7.0-rc5+ #503
 0000000000000000 ffffffff81e03ce0 ffffffff8131dae8 ffffffff81bb6c50
 ffffffff81e03d70 ffffffff81e03d60 ffffffff8111f4df 0000000000000018
 ffffffff81e03d70 ffffffff81e03d08 00000000000009f0 00000000000009f0
Call Trace:
 [<ffffffff8131dae8>] dump_stack+0x4d/0x65
 [<ffffffff8111f4df>] panic+0xc5/0x206
 [<ffffffff81f7c6d3>] memblock_alloc_base+0x29/0x2e
 [<ffffffff81f7c6e3>] memblock_alloc+0xb/0xd
 [<ffffffff81f6c86d>] efi_arch_mem_reserve+0xbc/0x134
 [<ffffffff81fa3280>] efi_mem_reserve+0x2c/0x31
 [<ffffffff81fa3280>] ? efi_mem_reserve+0x2c/0x31
 [<ffffffff81fa40d3>] efi_esrt_init+0x19e/0x1b4
 [<ffffffff81f6d2dd>] efi_init+0x398/0x44a
 [<ffffffff81f5c782>] setup_arch+0x415/0xc30
 [<ffffffff81f55af1>] start_kernel+0x5b/0x3ef
 [<ffffffff81f55434>] x86_64_start_reservations+0x2f/0x31
 [<ffffffff81f55520>] x86_64_start_kernel+0xea/0xed
---[ end Kernel panic - not syncing: ERROR: Failed to allocate 0x9f0
     bytes below 0x0.

An inspection of the memblock configuration reveals that there is no memory
available for the allocation:

MEMBLOCK configuration:
 memory size = 0x0 reserved size = 0x4f339c0
 memory.cnt  = 0x1
 memory[0x0]    [0x00000000000000-0xffffffffffffffff], 0x0 bytes on node 0\
                 flags: 0x0
 reserved.cnt  = 0x4
 reserved[0x0]  [0x0000000008c000-0x0000000008c9bf], 0x9c0 bytes flags: 0x0
 reserved[0x1]  [0x0000000009f000-0x000000000fffff], 0x61000 bytes\
                 flags: 0x0
 reserved[0x2]  [0x00000002800000-0x0000000394bfff], 0x114c000 bytes\
                 flags: 0x0
 reserved[0x3]  [0x000000304e4000-0x00000034269fff], 0x3d86000 bytes\
                 flags: 0x0

This situation can be avoided if we call efi_esrt_init after memblock has
memory regions for the allocation.

Also, the EFI ESRT driver makes use of early_memremap'pings. Therfore, we
do not want to defer efi_esrt_init for too long. We must call such function
while calls to early_memremap are still valid.

A good place to meet the two aforementioned conditions is right after
memblock_x86_fill, grouped with other EFI-related functions.

Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Scott Lawson <scott.lawson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
Changes since v1:
*Call efi_esrt_init earlier than efi_late_init, while early_memremap
is still valid.
---
 arch/x86/kernel/setup.c     | 1 +
 arch/x86/platform/efi/efi.c | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1867fa8f..b07dc1b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1099,6 +1099,7 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled(EFI_MEMMAP)) {
 		efi_fake_memmap();
 		efi_find_mirror();
+		efi_esrt_init();
 
 		/*
 		 * The EFI specification says that boot service code won't be
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ef9b6ab..fc0055e 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -475,8 +475,6 @@ void __init efi_init(void)
 
 	if (efi_enabled(EFI_DBG))
 		efi_print_memmap();
-
-	efi_esrt_init();
 }
 
 void __init efi_late_init(void)
-- 
2.9.2
