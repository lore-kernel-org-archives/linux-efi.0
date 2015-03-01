From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 4/8] x86, of: let add_dtb reserve by itself
Date: Sat, 28 Feb 2015 18:17:35 -0800
Message-ID: <1425176259-30087-5-git-send-email-yinghai@kernel.org>
References: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>, Rob Herring <robh@kernel.org>, David Vrabel <david.vrabel@citrix.com>
List-Id: linux-efi@vger.kernel.org

We will not reserve setup_data in general code. Every handler
need to reserve and copy.

Current dtd handling already have code copying, just add reserve code ...

also simplify code a bit with storing real dtb size.

Cc: Rob Herring <robh@kernel.org>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/prom.h  |  9 ++++++---
 arch/x86/kernel/devicetree.c | 39 +++++++++++++++++++++------------------
 2 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index 1d081ac..fb716eddc 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -24,17 +24,20 @@
 
 #ifdef CONFIG_OF
 extern int of_ioapic;
-extern u64 initial_dtb;
-extern void add_dtb(u64 data);
 void x86_of_pci_init(void);
 void x86_dtb_init(void);
 #else
-static inline void add_dtb(u64 data) { }
 static inline void x86_of_pci_init(void) { }
 static inline void x86_dtb_init(void) { }
 #define of_ioapic 0
 #endif
 
+#ifdef CONFIG_OF_FLATTREE
+extern void add_dtb(u64 data);
+#else
+static inline void add_dtb(u64 data) { }
+#endif
+
 extern char cmd_line[COMMAND_LINE_SIZE];
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 3d35033..cc2fb61 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -2,6 +2,7 @@
  * Architecture specific OF callbacks.
  */
 #include <linux/bootmem.h>
+#include <linux/memblock.h>
 #include <linux/export.h>
 #include <linux/io.h>
 #include <linux/irqdomain.h>
@@ -23,7 +24,6 @@
 #include <asm/setup.h>
 #include <asm/i8259.h>
 
-__initdata u64 initial_dtb;
 char __initdata cmd_line[COMMAND_LINE_SIZE];
 
 int __initdata of_ioapic;
@@ -43,11 +43,23 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 	return __alloc_bootmem(size, align, __pa(MAX_DMA_ADDRESS));
 }
 
+#ifdef CONFIG_OF_FLATTREE
+static u64 initial_dtb __initdata;
+static u32 initial_dtb_size __initdata;
 void __init add_dtb(u64 data)
 {
+	u32 map_len;
+
 	initial_dtb = data + offsetof(struct setup_data, data);
-}
 
+	map_len = max(PAGE_SIZE - (initial_dtb & ~PAGE_MASK), (u64)128);
+	initial_boot_params = early_memremap(initial_dtb, map_len);
+	initial_dtb_size = of_get_flat_dt_size();
+	early_memunmap(initial_boot_params, map_len);
+	initial_boot_params = NULL;
+	memblock_reserve(initial_dtb, initial_dtb_size);
+}
+#endif
 /*
  * CE4100 ids. Will be moved to machine_device_initcall() once we have it.
  */
@@ -272,31 +284,22 @@ static void __init dtb_apic_setup(void)
 	dtb_ioapic_setup();
 }
 
-#ifdef CONFIG_OF_FLATTREE
 static void __init x86_flattree_get_config(void)
 {
-	u32 size, map_len;
+#ifdef CONFIG_OF_FLATTREE
 	void *dt;
 
 	if (!initial_dtb)
 		return;
 
-	map_len = max(PAGE_SIZE - (initial_dtb & ~PAGE_MASK), (u64)128);
-
-	initial_boot_params = dt = early_memremap(initial_dtb, map_len);
-	size = of_get_flat_dt_size();
-	if (map_len < size) {
-		early_iounmap(dt, map_len);
-		initial_boot_params = dt = early_memremap(initial_dtb, size);
-		map_len = size;
-	}
-
+	initial_boot_params = dt = early_memremap(initial_dtb,
+						  initial_dtb_size);
 	unflatten_and_copy_device_tree();
-	early_iounmap(dt, map_len);
-}
-#else
-static inline void x86_flattree_get_config(void) { }
+	early_memunmap(dt, initial_dtb_size);
+
+	memblock_free(initial_dtb, initial_dtb_size);
 #endif
+}
 
 void __init x86_dtb_init(void)
 {
-- 
1.8.4.5
