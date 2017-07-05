From: Joe Perches <joe@perches.com>
Subject: [PATCH 11/18] x86/efi: Move asmlinkage before return type
Date: Wed,  5 Jul 2017 13:02:20 -0700
Message-ID: <1cd3d401626e51ea0e2333a860e76e80bc560a4c.1499284835.git.joe@perches.com>
References: <cover.1499284835.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1499284835.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Make the code like the rest of the kernel.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/include/asm/efi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index d2ff779f347e..796ff6c1aa53 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -33,7 +33,7 @@
 
 #ifdef CONFIG_X86_32
 
-extern unsigned long asmlinkage efi_call_phys(void *, ...);
+extern asmlinkage unsigned long efi_call_phys(void *, ...);
 
 #define arch_efi_call_virt_setup()	kernel_fpu_begin()
 #define arch_efi_call_virt_teardown()	kernel_fpu_end()
@@ -52,7 +52,7 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 #define EFI_LOADER_SIGNATURE	"EL64"
 
-extern u64 asmlinkage efi_call(void *fp, ...);
+extern asmlinkage u64 efi_call(void *fp, ...);
 
 #define efi_call_phys(f, args...)		efi_call((f), args)
 
-- 
2.10.0.rc2.1.g053435c
