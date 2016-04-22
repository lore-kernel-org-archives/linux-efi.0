From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv2 3/6] arm/efi: move to generic {__,}efi_call_virt
Date: Fri, 22 Apr 2016 14:51:20 +0100
Message-ID: <1461333083-15529-4-git-send-email-mark.rutland@arm.com>
References: <1461333083-15529-1-git-send-email-mark.rutland@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461333083-15529-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, hpa@zytor.com, leif.lindholm@linaro.org, linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, mark.rutland@arm.com, matt@codeblueprint.co.uk, mingo@redhat.com, tglx@linutronix.de, will.deacon@arm.com
List-Id: linux-efi@vger.kernel.org

Now there's a common template for {__,}efi_call_virt, remove the
duplicate logic from the arm efi code.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/include/asm/efi.h | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index e0eea72..e1461fc 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -23,26 +23,14 @@ void efi_init(void);
 
 int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 
-#define efi_call_virt(f, ...)						\
-({									\
-	efi_##f##_t *__f;						\
-	efi_status_t __s;						\
-									\
-	efi_virtmap_load();						\
-	__f = efi.systab->runtime->f;					\
-	__s = __f(__VA_ARGS__);						\
-	efi_virtmap_unload();						\
-	__s;								\
-})
+#define arch_efi_call_virt_setup()	efi_virtmap_load()
+#define arch_efi_call_virt_teardown()	efi_virtmap_unload()
 
-#define __efi_call_virt(f, ...)						\
+#define arch_efi_call_virt(f, args...)					\
 ({									\
 	efi_##f##_t *__f;						\
-									\
-	efi_virtmap_load();						\
 	__f = efi.systab->runtime->f;					\
-	__f(__VA_ARGS__);						\
-	efi_virtmap_unload();						\
+	__f(args);							\
 })
 
 static inline void efi_set_pgd(struct mm_struct *mm)
-- 
1.9.1
