From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH] efi: Remove the declaration of efi_late_init() as the function is unused
Date: Sun, 24 Jun 2018 18:47:51 -0700
Message-ID: <1529891271-24319-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Dave Young <dyoung@redhat.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Commit 7b0a911478c74 (efi/x86: Move the EFI BGRT init code to early
init code), removed the implementation and all the references to
efi_late_init() but the function is still declared at
include/linux/efi.h. Hence, remove the unnecessary declaration.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Lee Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Young <dyoung@redhat.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/linux/efi.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 56add823f190..ae47be636b98 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -988,14 +988,12 @@ extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec64 *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
 #ifdef CONFIG_X86
-extern void efi_late_init(void);
 extern void efi_free_boot_services(void);
 extern efi_status_t efi_query_variable_store(u32 attributes,
 					     unsigned long size,
 					     bool nonblocking);
 extern void efi_find_mirror(void);
 #else
-static inline void efi_late_init(void) {}
 static inline void efi_free_boot_services(void) {}
 
 static inline efi_status_t efi_query_variable_store(u32 attributes,
-- 
2.7.4
