From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 33/40] arm/efi: Move to generic {__,}efi_call_virt
Date: Mon, 25 Apr 2016 21:07:05 +0100
Message-ID: <1461614832-17633-34-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Colin Ian King <colin.king@canonical.com>, Leif Lindholm <leif.lindholm@linaro.org>, Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

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
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/arm/include/asm/efi.h | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index b45fe39bf35b..5f273b43d704 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -24,26 +24,14 @@ void efi_init(void);
 int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 
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
2.7.3
