From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V4 1/3] efi: Use efi_mm in x86 as well as ARM
Date: Thu, 18 Jan 2018 13:01:19 -0800
Message-ID: <1516309279-23977-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, "Lee, Chun-Yi" <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Andy Lutomirski <luto@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ravi Shankar <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Presently, only ARM uses mm_struct to manage efi page tables and efi
runtime region mappings. As this is the preferred approach, let's make
this data structure common across architectures. Specially, for x86,
using this data structure improves code maintainability and readability.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Lee, Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
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
index 2dd15e967c3f..c9f8e6924df7 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -232,6 +232,9 @@ int __init efi_alloc_page_tables(void)
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
index 29fdf8029cf6..d79f1cc4c8bb 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -930,6 +930,8 @@ extern struct efi {
 	unsigned long flags;
 } efi;
 
+extern struct mm_struct efi_mm;
+
 static inline int
 efi_guidcmp (efi_guid_t left, efi_guid_t right)
 {
-- 
2.1.4
