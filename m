From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi/arm64: efistub: remove local copy of linux_banner
Date: Fri, 13 Jun 2014 13:11:51 +0200
Message-ID: <1402657911-7779-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The shared efistub code for ARM and arm64 contains a local copy of linux_banner,
allowing it to be referenced from separate executables such as the ARM
decompressor. However, this introduces a dependency on generated header files,
causing unnecessary rebuilds of the stub itself and, in case of arm64, vmlinux
which contains it.

On arm64, the copy is not actually needed since we can reference the original
symbol directly, and as it turns out, there may be better ways to deal with this
for ARM as well, so let's remove it from the shared code. If it still needs to
be reintroduced for ARM later, it should live under arch/arm anyway and not in
shared code.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi-stub.c |  2 --
 drivers/firmware/efi/fdt.c   | 10 ----------
 2 files changed, 12 deletions(-)

diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index 60e98a639ac5..e786e6cdc400 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -12,8 +12,6 @@
 #include <linux/efi.h>
 #include <linux/libfdt.h>
 #include <asm/sections.h>
-#include <generated/compile.h>
-#include <generated/utsrelease.h>
 
 /*
  * AArch64 requires the DTB to be 8-byte aligned in the first 512MiB from
diff --git a/drivers/firmware/efi/fdt.c b/drivers/firmware/efi/fdt.c
index 5c6a8e8a9580..3aec36d7aae9 100644
--- a/drivers/firmware/efi/fdt.c
+++ b/drivers/firmware/efi/fdt.c
@@ -23,16 +23,6 @@ static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	u32 fdt_val32;
 	u64 fdt_val64;
 
-	/*
-	 * Copy definition of linux_banner here.  Since this code is
-	 * built as part of the decompressor for ARM v7, pulling
-	 * in version.c where linux_banner is defined for the
-	 * kernel brings other kernel dependencies with it.
-	 */
-	const char linux_banner[] =
-	    "Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
-	    LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION "\n";
-
 	/* Do some checks on provided FDT, if it exists*/
 	if (orig_fdt) {
 		if (fdt_check_header(orig_fdt)) {
-- 
1.8.3.2
