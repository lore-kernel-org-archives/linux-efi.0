From: Matteo Croce <mcroce@redhat.com>
Subject: [PATCH] x86: remove unused argument from set_real_mode_mem()
Date: Thu, 28 Mar 2019 12:42:33 +0100
Message-ID: <20190328114233.27835-1-mcroce@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, linux-efi@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Following commit b929a500d684 ("x86/realmode: Don't leak the trampoline
kernel address"), set_real_mode_mem() is a trivial function with a
unused argument.
Remove the unused argument and move it into an header file, so it can be
inlined.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 arch/x86/include/asm/realmode.h | 6 +++++-
 arch/x86/platform/efi/quirks.c  | 2 +-
 arch/x86/realmode/init.c        | 9 +--------
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index 63b3393bd98e..c53682303c9c 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -77,7 +77,11 @@ static inline size_t real_mode_size_needed(void)
 	return ALIGN(real_mode_blob_end - real_mode_blob, PAGE_SIZE);
 }
 
-void set_real_mode_mem(phys_addr_t mem, size_t size);
+static inline void set_real_mode_mem(phys_addr_t mem)
+{
+	real_mode_header = (struct real_mode_header *) __va(mem);
+}
+
 void reserve_real_mode(void);
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 458a0e2bcc57..a25a9fd987a9 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -449,7 +449,7 @@ void __init efi_free_boot_services(void)
 		 */
 		rm_size = real_mode_size_needed();
 		if (rm_size && (start + rm_size) < (1<<20) && size >= rm_size) {
-			set_real_mode_mem(start, rm_size);
+			set_real_mode_mem(start);
 			start += rm_size;
 			size -= rm_size;
 		}
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 47d097946872..7dce39c8c034 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -15,13 +15,6 @@ u32 *trampoline_cr4_features;
 /* Hold the pgd entry used on booting additional CPUs */
 pgd_t trampoline_pgd_entry;
 
-void __init set_real_mode_mem(phys_addr_t mem, size_t size)
-{
-	void *base = __va(mem);
-
-	real_mode_header = (struct real_mode_header *) base;
-}
-
 void __init reserve_real_mode(void)
 {
 	phys_addr_t mem;
@@ -40,7 +33,7 @@ void __init reserve_real_mode(void)
 	}
 
 	memblock_reserve(mem, size);
-	set_real_mode_mem(mem, size);
+	set_real_mode_mem(mem);
 }
 
 static void __init setup_real_mode(void)
-- 
2.20.1
