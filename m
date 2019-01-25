From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] efi: arm64: Enable earlycon for the GOP framebuffer
Date: Fri, 25 Jan 2019 17:18:06 +0100
Message-ID: <20190125161806.13472-3-ard.biesheuvel@linaro.org>
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

This repurposes the existing EFI earlyprintk support and exposes it
as an earlycon implementation, which can be enabled by passing the
kernel parameter 'earlycon=efi' on the command line.

Note that the early console is initialized before we have discovered
anything about the memory map, and so we cannot determine automatically
whether the framebuffer is backed by system memory that must be mapped
with cacheable attributes. So instead, a 'ram' earlycon option is
implemented to force this manually.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  9 ++++-
 arch/arm64/include/asm/efi.h                    |  6 +++
 drivers/firmware/efi/Kconfig                    |  1 +
 drivers/firmware/efi/earlycon.c                 | 42 +++++++++++++++-----
 4 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b799bcf67d7b..be6b4972cc3c 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1073,9 +1073,16 @@
 			specified address. The serial port must already be
 			setup and configured. Options are not yet supported.
 
+		efi[,options]                       # arm64 or x86
+			Start an early, unaccelerated console on the EFI
+			framebuffer. On DMA coherent arm64 systems that use
+			system memory for the framebuffer, pass the 'ram'
+			option so that it is mapped with the correct
+			attributes.
+
 	earlyprintk=	[X86,SH,ARM,M68k,S390]
 			earlyprintk=vga
-			earlyprintk=efi
+			earlyprintk=efi             # x86 only
 			earlyprintk=sclp
 			earlyprintk=xen
 			earlyprintk=serial[,ttySn[,baudrate]]
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 7ed320895d1f..7f555f1c8d48 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -11,6 +11,7 @@
 #include <asm/neon.h>
 #include <asm/ptrace.h>
 #include <asm/tlbflush.h>
+#include <linux/screen_info.h>
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
@@ -149,4 +150,9 @@ static inline void efi_set_pgd(struct mm_struct *mm)
 void efi_virtmap_load(void);
 void efi_virtmap_unload(void);
 
+static inline struct screen_info *efi_get_screen_info(void)
+{
+	return &screen_info;
+}
+
 #endif /* _ASM_EFI_H */
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 70335c7f0fe4..9d67aab94cbf 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -201,4 +201,5 @@ config EFI_DEV_PATH_PARSER
 
 config UEFI_EARLYCON
 	bool
+	default y if ARM64
 	select FONT_SUPPORT
diff --git a/drivers/firmware/efi/earlycon.c b/drivers/firmware/efi/earlycon.c
index c065c482d12b..4e8dba21673e 100644
--- a/drivers/firmware/efi/earlycon.c
+++ b/drivers/firmware/efi/earlycon.c
@@ -10,13 +10,17 @@
 #include <linux/font.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/serial_core.h>
 #include <asm/efi.h>
 
 static const struct font_desc *font;
 static u32 efi_x, efi_y;
 static void *efi_fb;
 static bool early_efi_keep;
+static bool fb_is_ram;
+static u64 fb_base;
 
+#ifdef CONFIG_EARLY_PRINTK_EFI
 /*
  * efi earlyprintk need use early_ioremap to map the framebuffer.
  * But early_ioremap is not usable for earlyprintk=efi,keep, ioremap should
@@ -40,6 +44,7 @@ static __init int early_efi_map_fb(void)
 	return efi_fb ? 0 : -ENOMEM;
 }
 early_initcall(early_efi_map_fb);
+#endif
 
 /*
  * early_efi_map maps efi framebuffer region [start, start + len -1]
@@ -48,21 +53,21 @@ early_initcall(early_efi_map_fb);
  */
 static __ref void *early_efi_map(unsigned long start, unsigned long len)
 {
-	u64 base;
-
-	base = efi_get_screen_info()->lfb_base;
-	if (efi_get_screen_info()->capabilities & VIDEO_CAPABILITY_64BIT_BASE)
-		base |= (u64)efi_get_screen_info()->ext_lfb_base << 32;
-
 	if (efi_fb)
 		return (efi_fb + start);
+	else if (fb_is_ram)
+		return early_memremap(fb_base + start, len);
 	else
-		return early_ioremap(base + start, len);
+		return early_ioremap(fb_base + start, len);
 }
 
 static __ref void early_efi_unmap(void *addr, unsigned long len)
 {
-	if (!efi_fb)
+	if (efi_fb)
+		return;
+	if (fb_is_ram)
+		early_memunmap(addr, len);
+	else
 		early_iounmap(addr, len);
 }
 
@@ -210,6 +215,10 @@ static __init int early_efi_setup(struct console *con, char *options)
 	xres = si->lfb_width;
 	yres = si->lfb_height;
 
+	fb_base = efi_get_screen_info()->lfb_base;
+	if (efi_get_screen_info()->capabilities & VIDEO_CAPABILITY_64BIT_BASE)
+		fb_base |= (u64)efi_get_screen_info()->ext_lfb_base << 32;
+
 	/*
 	 * early_efi_write_char() implicitly assumes a framebuffer with
 	 * 32-bits per pixel.
@@ -226,11 +235,12 @@ static __init int early_efi_setup(struct console *con, char *options)
 		early_efi_scroll_up();
 
 	/* early_console_register will unset CON_BOOT in case ,keep */
-	if (!(con->flags & CON_BOOT))
+	if (con && !(con->flags & CON_BOOT))
 		early_efi_keep = true;
 	return 0;
 }
 
+#ifdef CONFIG_EARLY_PRINTK_EFI
 struct console early_efi_console = {
 	.name =		"earlyefi",
 	.write =	early_efi_write,
@@ -238,3 +248,17 @@ struct console early_efi_console = {
 	.flags =	CON_PRINTBUFFER,
 	.index =	-1,
 };
+#endif
+
+static int __init efi_earlycon_setup(struct earlycon_device *device,
+				     const char *opt)
+{
+	if (efi_get_screen_info()->orig_video_isVGA != VIDEO_TYPE_EFI)
+		return -ENODEV;
+
+	device->con->write = early_efi_write;
+	early_efi_setup(NULL, NULL);
+	fb_is_ram = !strcmp(opt, "ram");
+	return 0;
+}
+EARLYCON_DECLARE(efi, efi_earlycon_setup);
-- 
2.20.1
