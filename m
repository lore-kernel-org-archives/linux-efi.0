From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv2 2/5] arm64/efi: move to generic {__,}efi_call_virt
Date: Thu, 21 Apr 2016 12:35:26 +0100
Message-ID: <1461238529-12810-3-git-send-email-mark.rutland@arm.com>
References: <1461238529-12810-1-git-send-email-mark.rutland@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461238529-12810-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, hpa@zytor.com, leif.lindholm@linaro.org, linux@arm.linux.org.uk, mark.rutland@arm.com, matt@codeblueprint.co.uk, mingo@redhat.com, tglx@linutronix.de, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Now there's a common template for {__,}efi_call_virt, remove the
duplicate logic from the arm64 efi code.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm64/include/asm/efi.h | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 8e88a69..f4f71224 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -14,28 +14,21 @@ extern void efi_init(void);
 
 int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 
-#define efi_call_virt(f, ...)						\
+#define arch_efi_call_virt_setup()					\
 ({									\
-	efi_##f##_t *__f;						\
-	efi_status_t __s;						\
-									\
 	kernel_neon_begin();						\
 	efi_virtmap_load();						\
-	__f = efi.systab->runtime->f;					\
-	__s = __f(__VA_ARGS__);						\
-	efi_virtmap_unload();						\
-	kernel_neon_end();						\
-	__s;								\
 })
 
-#define __efi_call_virt(f, ...)						\
+#define arch_efi_call_virt(f, args...)					\
 ({									\
 	efi_##f##_t *__f;						\
-									\
-	kernel_neon_begin();						\
-	efi_virtmap_load();						\
 	__f = efi.systab->runtime->f;					\
-	__f(__VA_ARGS__);						\
+	__f(args);							\
+})
+
+#define arch_efi_call_virt_teardown()					\
+({									\
 	efi_virtmap_unload();						\
 	kernel_neon_end();						\
 })
-- 
1.9.1
