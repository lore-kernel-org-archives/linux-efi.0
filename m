From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] efi: Use efi_mm in x86 as well as ARM
Date: Sat, 16 Dec 2017 16:06:12 -0800
Message-ID: <1513469172-5682-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Presently, only ARM uses mm_struct to manage efi page tables and efi
runtime region mappings. As this is the preferred approach, let's make
this data structure common across architectures. Specially, for x86,
using this data structure improves code maintainability and readability.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Tested-by: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/include/asm/efi.h         | 4 ++++
 arch/x86/platform/efi/efi_64.c     | 3 +++
 drivers/firmware/efi/arm-runtime.c | 9 ---------
 drivers/firmware/efi/efi.c         | 9 +++++++++
 include/linux/efi.h                | 2 ++
 5 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 85f6ccb80b91..00f977ddd718 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -2,10 +2,14 @@
 #ifndef _ASM_X86_EFI_H
 #define _ASM_X86_EFI_H
 
+#include <linux/sched/mm.h>
+#include <linux/sched/task.h>
+
 #include <asm/fpu/api.h>
 #include <asm/pgtable.h>
 #include <asm/processor-flags.h>
 #include <asm/tlb.h>
+#include <asm/mmu_context.h>
 
 /*
  * We map the EFI regions needed for runtime services non-contiguously,
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 6a151ce70e86..ccf5239923e8 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -227,6 +227,9 @@ int __init efi_alloc_page_tables(void)
 		return -ENOMEM;
 	}
 
+	mm_init_cpumask(&efi_mm);
+	init_new_context(NULL, &efi_mm);
+
 	return 0;
 }
 
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 1cc41c3d6315..d6b26534812b 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -31,15 +31,6 @@
 
 extern u64 efi_system_table;
 
-static struct mm_struct efi_mm = {
-	.mm_rb			= RB_ROOT,
-	.mm_users		= ATOMIC_INIT(2),
-	.mm_count		= ATOMIC_INIT(1),
-	.mmap_sem		= __RWSEM_INITIALIZER(efi_mm.mmap_sem),
-	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
-	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
-};
-
 #ifdef CONFIG_ARM64_PTDUMP_DEBUGFS
 #include <asm/ptdump.h>
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 557a47829d03..760260b933b6 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -74,6 +74,15 @@ static unsigned long *efi_tables[] = {
 	&efi.mem_attr_table,
 };
 
+struct mm_struct efi_mm = {
+	.mm_rb			= RB_ROOT,
+	.mm_users		= ATOMIC_INIT(2),
+	.mm_count		= ATOMIC_INIT(1),
+	.mmap_sem		= __RWSEM_INITIALIZER(efi_mm.mmap_sem),
+	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
+	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
+};
+
 static bool disable_runtime;
 static int __init setup_noefi(char *arg)
 {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index d813f7b04da7..6745f4dbbcc1 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -928,6 +928,8 @@ extern struct efi {
 	unsigned long flags;
 } efi;
 
+extern struct mm_struct efi_mm;
+
 static inline int
 efi_guidcmp (efi_guid_t left, efi_guid_t right)
 {
-- 
2.1.4
