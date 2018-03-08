From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 07/12] efi: Use efi_mm in x86 as well as ARM
Date: Thu,  8 Mar 2018 08:00:15 +0000
Message-ID: <20180308080020.22828-8-ard.biesheuvel@linaro.org>
References: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Andy Lutomirski <luto@kernel.org>, "Michael S . Tsirkin" <mst@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Presently, only ARM uses mm_struct to manage efi page tables and efi
runtime region mappings. As this is the preferred approach, let's make
this data structure common across architectures. Specially, for x86,
using this data structure improves code maintainability and readability.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: "Lee, Chun-Yi" <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
index c310a8284358..0045efe9947b 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -231,6 +231,9 @@ int __init efi_alloc_page_tables(void)
 		return -ENOMEM;
 	}
 
+	mm_init_cpumask(&efi_mm);
+	init_new_context(NULL, &efi_mm);
+
 	return 0;
 }
 
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 13561aeb7396..5889cbea60b8 100644
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
index cd42f66a7c85..c0dda400d22a 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -75,6 +75,15 @@ static unsigned long *efi_tables[] = {
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
index f5083aa72eae..f1b7d68ac460 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -966,6 +966,8 @@ extern struct efi {
 	unsigned long flags;
 } efi;
 
+extern struct mm_struct efi_mm;
+
 static inline int
 efi_guidcmp (efi_guid_t left, efi_guid_t right)
 {
-- 
2.15.1
