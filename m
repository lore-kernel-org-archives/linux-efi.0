From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] efi: prune invalid memory map entries
Date: Mon, 12 Dec 2016 18:42:28 -0500
Message-ID: <20161212234231.27256-1-pjones@redhat.com>
References: <20161212234030.3mu4bv5bjm5ysz2d@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161212234030.3mu4bv5bjm5ysz2d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Some machines, such as the Lenovo ThinkPad W541 with firmware GNET80WW
(2.28), include memory map entries with phys_addr=0x0 and num_pages=0.

Currently the log output for this case (with efi=debug) looks like:

[    0.000000] efi: mem45: [Reserved           |   |  |  |  |  |  |  |  |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)

This is clearly wrong, and also not as informative as it could be.  This
patch changes it so that if we find obviously invalid memory map
entries, we print an error and those entries.  It also detects the
display of the address range calculation overflow, so the new output is:

[    0.000000] efi: [Firmware Bug]: Invalid EFI memory map entries:
[    0.000000] efi: mem45: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0x0000000000000000] (invalid)

It also detects memory map sizes that would overflow the physical
address, for example phys_addr=0xfffffffffffff000 and
num_pages=0x0200000000000001, and prints:

[    0.000000] efi: [Firmware Bug]: Invalid EFI memory map entries:
[    0.000000] efi: mem45: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[phys_addr=0xfffffffffffff000-0x20ffffffffffffffff] (invalid)

It then removes these entries from the memory map.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 81 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h         |  1 +
 2 files changed, 82 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index bf99aa7..039b5cf 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -210,6 +210,85 @@ int __init efi_memblock_x86_reserve_range(void)
 	return 0;
 }
 
+#define OVERFLOW_ADDR_SHIFT (64-PAGE_SHIFT)
+#define OVERFLOW_ADDR_MASK (U64_MAX << OVERFLOW_ADDR_SHIFT)
+#define U64_HIGH_BIT (~(U64_MAX >> 1))
+
+void __init efi_clean_memmap(void)
+{
+	int i = 0, n_removal = 0;
+	int extra = 0;
+	void *to = efi.memmap.map;
+	void *from = efi.memmap.map + efi.memmap.desc_size;
+	bool once = true;
+
+	while (to < efi.memmap.map_end - extra) {
+		efi_memory_desc_t *md = (efi_memory_desc_t *)to;
+		char buf[64];
+		bool valid = true;
+
+		u64 end = (md->num_pages << EFI_PAGE_SHIFT);
+		u64 end_hi = 0;
+
+		end += md->phys_addr - 1;
+
+		if (md->num_pages == 0) {
+			end = 0;
+			valid = false;
+		} else if (md->num_pages > EFI_PAGES_MAX ||
+		    EFI_PAGES_MAX - md->num_pages <
+		    (md->phys_addr >> EFI_PAGE_SHIFT)) {
+			end_hi = (md->num_pages & OVERFLOW_ADDR_MASK)
+				>> OVERFLOW_ADDR_SHIFT;
+			valid = false;
+
+			if ((md->phys_addr & U64_HIGH_BIT) &&
+			    !(end & U64_HIGH_BIT))
+				end_hi += 1;
+		}
+
+		if (valid) {
+			to += efi.memmap.desc_size;
+			from += efi.memmap.desc_size;
+		} else {
+			if (once) {
+				pr_info(FW_BUG "Invalid EFI memory map entries:\n");
+				once = false;
+			}
+			n_removal++;
+
+			if (end_hi)
+				pr_info("mem%02u: %s range=[0x%016llx-0x%llx%016llx] (invalid)\n",
+					i, efi_md_typeattr_format(buf,
+								  sizeof(buf),
+								  md),
+					md->phys_addr, end_hi, end);
+			else
+				pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (invalid)\n",
+					i, efi_md_typeattr_format(buf,
+								  sizeof(buf),
+								  md),
+					md->phys_addr, end);
+
+			if ((u64)from < (u64)efi.memmap.map_end - extra)
+				memcpy(to, from,
+				       (u64)efi.memmap.map_end - (u64)from -
+				       extra);
+
+			extra += efi.memmap.desc_size;
+		}
+		i++;
+	}
+	if (extra) {
+		u64 size = ((u64)efi.memmap.map_end -
+			    (u64)efi.memmap.map - extra) /
+			   efi.memmap.desc_size;
+
+		pr_info("Removing %d invalid memory map entries.\n", n_removal);
+		efi_memmap_install(efi.memmap.phys_map, size);
+	}
+}
+
 void __init efi_print_memmap(void)
 {
 	efi_memory_desc_t *md;
@@ -472,6 +551,8 @@ void __init efi_init(void)
 		}
 	}
 
+	efi_clean_memmap();
+
 	if (efi_enabled(EFI_DBG))
 		efi_print_memmap();
 }
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 4c1b3ea..712a3aa 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -103,6 +103,7 @@ typedef	struct {
 
 #define EFI_PAGE_SHIFT		12
 #define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
+#define EFI_PAGES_MAX		(U64_MAX >> EFI_PAGE_SHIFT)
 
 typedef struct {
 	u32 type;
-- 
2.9.3
