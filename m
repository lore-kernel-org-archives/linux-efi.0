From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 04/12] x86/efi-bgrt: Move efi-bgrt handling out of arch/x86
Date: Tue,  4 Apr 2017 17:02:40 +0100
Message-ID: <20170404160245.27812-7-ard.biesheuvel@linaro.org>
References: <20170404160245.27812-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170404160245.27812-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Now with open-source boot firmware (EDK2) supporting ACPI BGRT table
addition even for architectures like AARCH64, it makes sense to move
out the 'efi-bgrt.c' file and supporting infrastructure from 'arch/x86'
directory and house it inside 'drivers/firmware/efi', so that this common
code can be used across architectures.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/platform/efi/Makefile                         | 1 -
 drivers/firmware/efi/Makefile                          | 1 +
 {arch/x86/platform => drivers/firmware}/efi/efi-bgrt.c | 0
 3 files changed, 1 insertion(+), 1 deletion(-)
 rename {arch/x86/platform => drivers/firmware}/efi/efi-bgrt.c (100%)

diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
index 066619b0700c..f1d83b34c329 100644
--- a/arch/x86/platform/efi/Makefile
+++ b/arch/x86/platform/efi/Makefile
@@ -1,6 +1,5 @@
 OBJECT_FILES_NON_STANDARD_efi_thunk_$(BITS).o := y
 
 obj-$(CONFIG_EFI) 		+= quirks.o efi.o efi_$(BITS).o efi_stub_$(BITS).o
-obj-$(CONFIG_ACPI_BGRT) += efi-bgrt.o
 obj-$(CONFIG_EARLY_PRINTK_EFI)	+= early_printk.o
 obj-$(CONFIG_EFI_MIXED)		+= efi_thunk_$(BITS).o
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index ad67342313ed..0329d319d89a 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -9,6 +9,7 @@
 #
 KASAN_SANITIZE_runtime-wrappers.o	:= n
 
+obj-$(CONFIG_ACPI_BGRT) 		+= efi-bgrt.o
 obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o memattr.o
 obj-$(CONFIG_EFI)			+= capsule.o memmap.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
diff --git a/arch/x86/platform/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
similarity index 100%
rename from arch/x86/platform/efi/efi-bgrt.c
rename to drivers/firmware/efi/efi-bgrt.c
-- 
2.9.3
