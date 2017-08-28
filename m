From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V2 1/3] efi: Use efi_mm in x86 as well as ARM
Date: Mon, 28 Aug 2017 16:37:10 -0700
Message-ID: <1503963432-32055-2-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1503963432-32055-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503963432-32055-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org
Cc: jlee@suse.com, bp@alien8.de, tony.luck@intel.com, luto@kernel.org, mst@redhat.com, ricardo.neri@intel.com, ravi.v.shankar@intel.com, Sai Praneeth <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Presently, only ARM uses mm_struct to manage efi page tables and efi
runtime region mappings. As this is the preferred approach, let's make
this data structure common across architectures. Specially, for
x86, using this data structure improves code maintainability and
readability.

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
---
 drivers/firmware/efi/arm-runtime.c | 9 ---------
 drivers/firmware/efi/efi.c         | 9 +++++++++
 include/linux/efi.h                | 2 ++
 3 files changed, 11 insertions(+), 9 deletions(-)

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
index b372aad3b449..3abbb25602bc 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -55,6 +55,15 @@ struct efi __read_mostly efi = {
 };
 EXPORT_SYMBOL(efi);
 
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
index 8269bcb8ccf7..d1f261d2ce69 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -927,6 +927,8 @@ extern struct efi {
 	unsigned long flags;
 } efi;
 
+extern struct mm_struct efi_mm;
+
 static inline int
 efi_guidcmp (efi_guid_t left, efi_guid_t right)
 {
-- 
2.1.4
