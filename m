From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 20/40] arm64/efi: libstub: Make screen_info accessible to the UEFI stub
Date: Mon, 25 Apr 2016 21:06:52 +0100
Message-ID: <1461614832-17633-21-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, David Herrmann <dh.herrmann@gmail.com>, Mark Rutland <mark.rutland@arm.com>, Peter Jones <pjones@redhat.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Unlike on 32-bit ARM, where we need to pass the stub's version of struct
screen_info to the kernel proper via a configuration table, on 64-bit ARM
it simply involves making the core kernel's copy of struct screen_info
visible to the stub by exposing an __efistub_ alias for it.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/arm64/include/asm/efi.h | 3 +++
 arch/arm64/kernel/efi.c      | 3 +++
 arch/arm64/kernel/image.h    | 1 +
 3 files changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index af40baa5d53f..fa09886f72e6 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -56,6 +56,9 @@ int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
 #define efi_is_64bit()			(true)
 
+#define alloc_screen_info(x...)		&screen_info
+#define free_screen_info(x...)
+
 #define EFI_ALLOC_ALIGN		SZ_64K
 
 /*
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 33a6da160a50..78f52488f9ff 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -56,6 +56,9 @@ static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
 	return pgprot_val(PAGE_KERNEL_EXEC);
 }
 
+/* we will fill this structure from the stub, so don't put it in .bss */
+struct screen_info screen_info __section(.data);
+
 int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 {
 	pteval_t prot_val = create_mapping_protection(md);
diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
index 5e360ce88f10..1428849aece8 100644
--- a/arch/arm64/kernel/image.h
+++ b/arch/arm64/kernel/image.h
@@ -112,6 +112,7 @@ __efistub___memset		= KALLSYMS_HIDE(__pi_memset);
 __efistub__text			= KALLSYMS_HIDE(_text);
 __efistub__end			= KALLSYMS_HIDE(_end);
 __efistub__edata		= KALLSYMS_HIDE(_edata);
+__efistub_screen_info		= KALLSYMS_HIDE(screen_info);
 
 #endif
 
-- 
2.7.3
