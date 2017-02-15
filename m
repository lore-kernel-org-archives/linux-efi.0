From: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] x86/efi-bgrt: Move efi-bgrt handling out of arch/x86
Date: Wed, 15 Feb 2017 18:34:51 +0530
Message-ID: <1487163892-27701-2-git-send-email-bhsharma@redhat.com>
References: <1487163892-27701-1-git-send-email-bhsharma@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487163892-27701-1-git-send-email-bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Now with open-source boot firmware (EDK2) supporting ACPI BGRT table addition
even for architecures like AARCH64, it makes sense to move out the 'efi-bgrt.c'
file and supporting infrastructure from 'arch/x86' directory and house it
inside 'drivers/firmware/efi', so that this common code can be used accross
architecures.

This patch (1) of a series having (2) patches, prepares the background
so that handling of ACPI BGRT tables and BGRT image can be added
in other architectures.

Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Signed-off-by: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/Makefile                         | 1 -
 drivers/firmware/efi/Makefile                          | 1 +
 {arch/x86/platform => drivers/firmware}/efi/efi-bgrt.c | 0
 3 files changed, 1 insertion(+), 1 deletion(-)
 rename {arch/x86/platform => drivers/firmware}/efi/efi-bgrt.c (100%)

diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
index 066619b..f1d83b3 100644
--- a/arch/x86/platform/efi/Makefile
+++ b/arch/x86/platform/efi/Makefile
@@ -1,6 +1,5 @@
 OBJECT_FILES_NON_STANDARD_efi_thunk_$(BITS).o := y
 
 obj-$(CONFIG_EFI) 		+= quirks.o efi.o efi_$(BITS).o efi_stub_$(BITS).o
-obj-$(CONFIG_ACPI_BGRT) += efi-bgrt.o
 obj-$(CONFIG_EARLY_PRINTK_EFI)	+= early_printk.o
 obj-$(CONFIG_EFI_MIXED)		+= efi_thunk_$(BITS).o
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index ad67342..0329d31 100644
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
2.7.4
