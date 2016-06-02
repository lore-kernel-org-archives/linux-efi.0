From: Joseph Thelen <jthelen@sgi.com>
Subject: [PATCH] x86/efi: Auto enable EFI memmap on SGI UV systems
Date: Thu,  2 Jun 2016 15:50:35 -0500
Message-ID: <1464900635-11957-2-git-send-email-jthelen@sgi.com>
References: <1464900635-11957-1-git-send-email-jthelen@sgi.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464900635-11957-1-git-send-email-jthelen@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Joseph Thelen <jthelen@sgi.com>, Alex Thorlton <athorlton@sgi.com>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Currently, the EFI memory map entries are disabled by default and must
be enabled by passing the kernel boot option:

add_efi_memmap

The EFI memory map entries should be enabled on systems with more
than 128 E820 entries, which includes many UV systems. Check if
we're on a UV system by chekcing the uv system table.
Enable the EFI memory map entries if we're on a UV system.

This change is backward compatible because the EFI memory map entries are
still disabled by default on non-UV systems, and it maintains the previous
behavior of the kernel boot option. In addition, it allows the EFI memory
map entries to be explicitly disabled (will not be automatically enabled)
by setting the add_efi_memmap boot option to anything that kstringtobool
will determine to be false.

Signed-off-by: Joseph Thelen <jthelen@sgi.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-efi@vger.kernel.org
---
 arch/x86/platform/efi/efi.c | 43 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f93545e..26e3ff5 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -66,10 +66,32 @@ static efi_config_table_type_t arch_tables[] __initdata = {
 
 u64 efi_setup;		/* efi setup_data physical address */
 
-static int add_efi_memmap __initdata;
+static __initdata enum {
+	EFI_MEMMAP_DEFAULT,
+	EFI_MEMMAP_ENABLED,
+	EFI_MEMMAP_DISABLED
+} add_efi_memmap;
+
 static int __init setup_add_efi_memmap(char *arg)
 {
-	add_efi_memmap = 1;
+	static bool arg_as_bool;
+	int ret = strtobool(arg, &arg_as_bool);
+
+	/* check for a non-existent arg, to maintain backward compatibility */
+	if (!arg) {
+		add_efi_memmap = EFI_MEMMAP_ENABLED;
+	} else {
+		if (ret) {
+			/* a bad argument was passed... */
+			return ret;
+		} else {
+			if (arg_as_bool)
+				add_efi_memmap = EFI_MEMMAP_ENABLED;
+			else
+				add_efi_memmap = EFI_MEMMAP_DISABLED;
+		}
+	}
+
 	return 0;
 }
 early_param("add_efi_memmap", setup_add_efi_memmap);
@@ -433,6 +455,7 @@ static int __init efi_runtime_init(void)
 static int __init efi_memmap_init(void)
 {
 	unsigned long addr, size;
+	bool is_uv_sys;
 
 	if (efi_enabled(EFI_PARAVIRT))
 		return 0;
@@ -449,8 +472,20 @@ static int __init efi_memmap_init(void)
 
 	efi.memmap.map_end = efi.memmap.map + size;
 
-	if (add_efi_memmap)
-		do_add_efi_memmap();
+	is_uv_sys = !((efi.uv_systab == EFI_INVALID_TABLE_ADDR)
+			|| !efi.uv_systab);
+
+	if (add_efi_memmap != EFI_MEMMAP_DISABLED) {
+		if (add_efi_memmap == EFI_MEMMAP_ENABLED) {
+			do_add_efi_memmap();
+			pr_info("EFI memmap enabled: Explicitly\n");
+		} else if (is_uv_sys) {
+			do_add_efi_memmap();
+			pr_info("EFI memmap enabled: this is a UV system\n");
+		}
+	} else {
+		pr_info("EFI memmap disabled: Explicitly\n");
+	}
 
 	set_bit(EFI_MEMMAP, &efi.flags);
 
-- 
1.8.5.6
