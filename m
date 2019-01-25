From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] efi: x86: move EFI earlyprintk code to shared location
Date: Fri, 25 Jan 2019 17:18:05 +0100
Message-ID: <20190125161806.13472-2-ard.biesheuvel@linaro.org>
References: <20190125161806.13472-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190125161806.13472-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, graeme.gregory@linaro.org, linux-doc@vger.kernel.org, pjones@redhat.com, corbet@lwn.net, agraf@suse.de, leif.lindholm@linaro.org, mingo@redhat.com, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Move the x86 EFI earlyprintk to a shared location under drivers/firmware
and tweak it slightly so we can easily reuse it for other architectures
going forward.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/Kconfig.debug                                                  |  2 +-
 arch/x86/include/asm/efi.h                                              |  6 +++++
 arch/x86/platform/efi/Makefile                                          |  1 -
 drivers/firmware/efi/Kconfig                                            |  4 +++
 drivers/firmware/efi/Makefile                                           |  1 +
 arch/x86/platform/efi/early_printk.c => drivers/firmware/efi/earlycon.c | 26 ++++++++++----------
 6 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 0723dff17e6c..078c633771e6 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -43,7 +43,7 @@ config EARLY_PRINTK_DBGP
 config EARLY_PRINTK_EFI
 	bool "Early printk via the EFI framebuffer"
 	depends on EFI && EARLY_PRINTK
-	select FONT_SUPPORT
+	select UEFI_EARLYCON
 	---help---
 	  Write kernel log output directly into the EFI framebuffer.
 
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 107283b1eb1e..79e9b5b10cb5 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -8,6 +8,7 @@
 #include <asm/tlb.h>
 #include <asm/nospec-branch.h>
 #include <asm/mmu_context.h>
+#include <asm/setup.h>
 
 /*
  * We map the EFI regions needed for runtime services non-contiguously,
@@ -244,6 +245,11 @@ static inline bool efi_is_64bit(void)
 
 extern bool efi_reboot_required(void);
 
+static inline struct screen_info *efi_get_screen_info(void)
+{
+	return &boot_params.screen_info;
+}
+
 #else
 static inline void parse_efi_setup(u64 phys_addr, u32 data_len) {}
 static inline bool efi_reboot_required(void)
diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
index e4dc3862d423..fe29f3f5d384 100644
--- a/arch/x86/platform/efi/Makefile
+++ b/arch/x86/platform/efi/Makefile
@@ -3,5 +3,4 @@ OBJECT_FILES_NON_STANDARD_efi_thunk_$(BITS).o := y
 OBJECT_FILES_NON_STANDARD_efi_stub_$(BITS).o := y
 
 obj-$(CONFIG_EFI) 		+= quirks.o efi.o efi_$(BITS).o efi_stub_$(BITS).o
-obj-$(CONFIG_EARLY_PRINTK_EFI)	+= early_printk.o
 obj-$(CONFIG_EFI_MIXED)		+= efi_thunk_$(BITS).o
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 89110dfc7127..70335c7f0fe4 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -198,3 +198,7 @@ config EFI_DEV_PATH_PARSER
 	bool
 	depends on ACPI
 	default n
+
+config UEFI_EARLYCON
+	bool
+	select FONT_SUPPORT
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 5f9f5039de50..d18cfd83155c 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -32,3 +32,4 @@ obj-$(CONFIG_ARM64)			+= $(arm-obj-y)
 obj-$(CONFIG_EFI_CAPSULE_LOADER)	+= capsule-loader.o
 obj-$(CONFIG_UEFI_CPER_ARM)		+= cper-arm.o
 obj-$(CONFIG_UEFI_CPER_X86)		+= cper-x86.o
+obj-$(CONFIG_UEFI_EARLYCON)		+= earlycon.o
diff --git a/arch/x86/platform/efi/early_printk.c b/drivers/firmware/efi/earlycon.c
similarity index 87%
rename from arch/x86/platform/efi/early_printk.c
rename to drivers/firmware/efi/earlycon.c
index 7138bc7a265c..c065c482d12b 100644
--- a/arch/x86/platform/efi/early_printk.c
+++ b/drivers/firmware/efi/earlycon.c
@@ -10,7 +10,7 @@
 #include <linux/font.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
-#include <asm/setup.h>
+#include <asm/efi.h>
 
 static const struct font_desc *font;
 static u32 efi_x, efi_y;
@@ -31,10 +31,10 @@ static __init int early_efi_map_fb(void)
 	if (!early_efi_keep)
 		return 0;
 
-	base = boot_params.screen_info.lfb_base;
-	if (boot_params.screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
-		base |= (u64)boot_params.screen_info.ext_lfb_base << 32;
-	size = boot_params.screen_info.lfb_size;
+	base = efi_get_screen_info()->lfb_base;
+	if (efi_get_screen_info()->capabilities & VIDEO_CAPABILITY_64BIT_BASE)
+		base |= (u64)efi_get_screen_info()->ext_lfb_base << 32;
+	size = efi_get_screen_info()->lfb_size;
 	efi_fb = ioremap(base, size);
 
 	return efi_fb ? 0 : -ENOMEM;
@@ -50,9 +50,9 @@ static __ref void *early_efi_map(unsigned long start, unsigned long len)
 {
 	u64 base;
 
-	base = boot_params.screen_info.lfb_base;
-	if (boot_params.screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
-		base |= (u64)boot_params.screen_info.ext_lfb_base << 32;
+	base = efi_get_screen_info()->lfb_base;
+	if (efi_get_screen_info()->capabilities & VIDEO_CAPABILITY_64BIT_BASE)
+		base |= (u64)efi_get_screen_info()->ext_lfb_base << 32;
 
 	if (efi_fb)
 		return (efi_fb + start);
@@ -71,7 +71,7 @@ static void early_efi_clear_scanline(unsigned int y)
 	unsigned long *dst;
 	u16 len;
 
-	len = boot_params.screen_info.lfb_linelength;
+	len = efi_get_screen_info()->lfb_linelength;
 	dst = early_efi_map(y*len, len);
 	if (!dst)
 		return;
@@ -86,8 +86,8 @@ static void early_efi_scroll_up(void)
 	u16 len;
 	u32 i, height;
 
-	len = boot_params.screen_info.lfb_linelength;
-	height = boot_params.screen_info.lfb_height;
+	len = efi_get_screen_info()->lfb_linelength;
+	height = efi_get_screen_info()->lfb_height;
 
 	for (i = 0; i < height - font->height; i++) {
 		dst = early_efi_map(i*len, len);
@@ -135,7 +135,7 @@ early_efi_write(struct console *con, const char *str, unsigned int num)
 	const char *s;
 	void *dst;
 
-	si = &boot_params.screen_info;
+	si = efi_get_screen_info();
 	len = si->lfb_linelength;
 
 	while (num) {
@@ -206,7 +206,7 @@ static __init int early_efi_setup(struct console *con, char *options)
 	u16 xres, yres;
 	u32 i;
 
-	si = &boot_params.screen_info;
+	si = efi_get_screen_info();
 	xres = si->lfb_width;
 	yres = si->lfb_height;
 
-- 
2.20.1
