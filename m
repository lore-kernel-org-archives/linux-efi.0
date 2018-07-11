From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 5/8] efi: Remove the declaration of efi_late_init() as the function is unused
Date: Wed, 11 Jul 2018 11:40:37 +0200
Message-ID: <20180711094040.12506-6-ard.biesheuvel@linaro.org>
References: <20180711094040.12506-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711094040.12506-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Commit 7b0a911478c74 (efi/x86: Move the EFI BGRT init code to early
init code), removed the implementation and all the references to
efi_late_init() but the function is still declared at
include/linux/efi.h. Hence, remove the unnecessary declaration.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/linux/efi.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 8ba0cdd244b2..e190652f5ef9 100644
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
2.17.1
