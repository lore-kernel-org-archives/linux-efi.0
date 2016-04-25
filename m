From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 18/40] x86/efi: efifb: Move DMI based quirks handling out of generic code
Date: Mon, 25 Apr 2016 21:06:50 +0100
Message-ID: <1461614832-17633-19-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, David Herrmann <dh.herrmann@gmail.com>, Mark Rutland <mark.rutland@arm.com>, Peter Jones <pjones@redhat.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

The efifb quirks handling based on DMI identification of the platform is
specific to x86, so move it to x86 arch code.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: David Herrmann <dh.herrmann@gmail.com>
Acked-by: Peter Jones <pjones@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/include/asm/efi.h  |  2 ++
 arch/x86/kernel/sysfb_efi.c | 15 +++++++++++++++
 drivers/video/fbdev/efifb.c | 15 ++++-----------
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 10e440770371..8747abe8872f 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -180,6 +180,8 @@ static inline bool efi_runtime_supported(void)
 extern struct console early_efi_console;
 extern void parse_efi_setup(u64 phys_addr, u32 data_len);
 
+extern void efifb_setup_from_dmi(struct screen_info *si, const char *opt);
+
 #ifdef CONFIG_EFI_MIXED
 extern void efi_thunk_runtime_setup(void);
 extern efi_status_t efi_thunk_set_virtual_address_map(
diff --git a/arch/x86/kernel/sysfb_efi.c b/arch/x86/kernel/sysfb_efi.c
index b285d4e8c68e..e21a8a7ddcff 100644
--- a/arch/x86/kernel/sysfb_efi.c
+++ b/arch/x86/kernel/sysfb_efi.c
@@ -68,6 +68,21 @@ struct efifb_dmi_info efifb_dmi_list[] = {
 	[M_UNKNOWN] = { NULL, 0, 0, 0, 0, OVERRIDE_NONE }
 };
 
+void efifb_setup_from_dmi(struct screen_info *si, const char *opt)
+{
+	int i;
+
+	for (i = 0; i < M_UNKNOWN; i++) {
+		if (efifb_dmi_list[i].base != 0 &&
+		    !strcmp(opt, efifb_dmi_list[i].optname)) {
+			si->lfb_base = efifb_dmi_list[i].base;
+			si->lfb_linelength = efifb_dmi_list[i].stride;
+			si->lfb_width = efifb_dmi_list[i].width;
+			si->lfb_height = efifb_dmi_list[i].height;
+		}
+	}
+}
+
 #define choose_value(dmivalue, fwvalue, field, flags) ({	\
 		typeof(fwvalue) _ret_ = fwvalue;		\
 		if ((flags) & (field))				\
diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 95d293b7445a..dd594369b8a6 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/efi.h>
 #include <linux/errno.h>
 #include <linux/fb.h>
 #include <linux/platform_device.h>
@@ -15,7 +16,7 @@
 #include <linux/dmi.h>
 #include <linux/pci.h>
 #include <video/vga.h>
-#include <asm/sysfb.h>
+#include <asm/efi.h>
 
 static bool request_mem_succeeded = false;
 
@@ -85,21 +86,13 @@ static struct fb_ops efifb_ops = {
 static int efifb_setup(char *options)
 {
 	char *this_opt;
-	int i;
 
 	if (options && *options) {
 		while ((this_opt = strsep(&options, ",")) != NULL) {
 			if (!*this_opt) continue;
 
-			for (i = 0; i < M_UNKNOWN; i++) {
-				if (efifb_dmi_list[i].base != 0 &&
-				    !strcmp(this_opt, efifb_dmi_list[i].optname)) {
-					screen_info.lfb_base = efifb_dmi_list[i].base;
-					screen_info.lfb_linelength = efifb_dmi_list[i].stride;
-					screen_info.lfb_width = efifb_dmi_list[i].width;
-					screen_info.lfb_height = efifb_dmi_list[i].height;
-				}
-			}
+			efifb_setup_from_dmi(&screen_info, this_opt);
+
 			if (!strncmp(this_opt, "base:", 5))
 				screen_info.lfb_base = simple_strtoul(this_opt+5, NULL, 0);
 			else if (!strncmp(this_opt, "stride:", 7))
-- 
2.7.3
