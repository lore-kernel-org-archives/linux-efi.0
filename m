From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFT PATCH] efi/x86: move x86 back to libstub
Date: Mon,  6 Oct 2014 13:06:43 +0200
Message-ID: <1412593603-6945-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This reverts commit 84be880560fb, which itself reverted my original
attempt to move x86 from #include'ing .c files from across the tree
to using the EFI stub built as a static library.

The issue that affected the original approach was that splitting
the implementation into several .o files resulted in the variable
'efi_early' becoming a global with external linkage, which under
-fPIC implies that references to it must go through the GOT. However,
dealing with this additional GOT entry turned out to be troublesome
on some EFI implementations. (GCC's visibility=hidden attribute is
supposed to lift this requirement, but it turned out not to work on
the 32-bit build.)

Instead, use a pure getter function to get a reference to efi_early.
This approach results in no additional GOT entries being generated,
so there is no need for any changes in the early GOT handling.

Cc: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---

Gents,

This is a request for testing: I would like to find out if this patch
fixes Maarten's issue without breaking anything like it did for Josh
and Linus the first time around.


 arch/x86/boot/compressed/Makefile |  3 ++-
 arch/x86/boot/compressed/eboot.c  |  8 ++++----
 arch/x86/boot/compressed/eboot.h  | 16 ----------------
 arch/x86/include/asm/efi.h        | 24 ++++++++++++++++++++++++
 drivers/firmware/efi/Makefile     |  2 +-
 5 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 0fcd9133790c..7a801a310e37 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -33,7 +33,8 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
 ifeq ($(CONFIG_EFI_STUB), y)
-	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
+	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o \
+				$(objtree)/drivers/firmware/efi/libstub/lib.a
 endif
 
 $(obj)/vmlinux: $(VMLINUX_OBJS) FORCE
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index de8eebd6f67c..58ea406f5d60 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -21,8 +21,10 @@ static efi_system_table_t *sys_table;
 
 static struct efi_config *efi_early;
 
-#define efi_call_early(f, ...)						\
-	efi_early->call(efi_early->f, __VA_ARGS__);
+__pure const struct efi_config *__efi_early(void)
+{
+	return efi_early;
+}
 
 #define BOOT_SERVICES(bits)						\
 static void setup_boot_services##bits(struct efi_config *c)		\
@@ -285,8 +287,6 @@ void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 	}
 }
 
-#include "../../../../drivers/firmware/efi/libstub/efi-stub-helper.c"
-
 static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 {
 	u8 first, len;
diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index c88c31ecad12..d487e727f1ec 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -103,20 +103,4 @@ struct efi_uga_draw_protocol {
 	void *blt;
 };
 
-struct efi_config {
-	u64 image_handle;
-	u64 table;
-	u64 allocate_pool;
-	u64 allocate_pages;
-	u64 get_memory_map;
-	u64 free_pool;
-	u64 free_pages;
-	u64 locate_handle;
-	u64 handle_protocol;
-	u64 exit_boot_services;
-	u64 text_output;
-	efi_status_t (*call)(unsigned long, ...);
-	bool is64;
-} __packed;
-
 #endif /* BOOT_COMPRESSED_EBOOT_H */
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 0ec241ede5a2..b2c854a0f5ca 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -159,6 +159,30 @@ static inline efi_status_t efi_thunk_set_virtual_address_map(
 }
 #endif /* CONFIG_EFI_MIXED */
 
+
+/* arch specific definitions used by the stub code */
+
+struct efi_config {
+	u64 image_handle;
+	u64 table;
+	u64 allocate_pool;
+	u64 allocate_pages;
+	u64 get_memory_map;
+	u64 free_pool;
+	u64 free_pages;
+	u64 locate_handle;
+	u64 handle_protocol;
+	u64 exit_boot_services;
+	u64 text_output;
+	efi_status_t (*call)(unsigned long, ...);
+	bool is64;
+} __packed;
+
+__pure const struct efi_config *__efi_early(void);
+
+#define efi_call_early(f, ...)						\
+	__efi_early()->call(__efi_early()->f, __VA_ARGS__);
+
 extern bool efi_reboot_required(void);
 
 #else
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index aef6a95adef5..d8be608a9f3b 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
 obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
 obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
-obj-$(CONFIG_EFI_ARM_STUB)		+= libstub/
+obj-$(CONFIG_EFI_STUB)			+= libstub/
-- 
1.9.1
