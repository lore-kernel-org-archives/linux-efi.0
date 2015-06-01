From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V2 2/3] efi: add efi_remap()
Date: Mon,  1 Jun 2015 12:12:19 -0700
Message-ID: <1433185940-24770-3-git-send-email-zjzhang@codeaurora.org>
References: <1433185940-24770-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433185940-24770-1-git-send-email-zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, al.stone-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, vgandhi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

If it is a EFI system, if EFI memmap is enabled and if
a memory region has attribute of EFI_MEMORY_UC, map it as uncached.

On x86, EFI memmap is unmapped in efi_free_boot_services(),
before kernel finishes booting. So when efi_remap() is called
during runtime on x86, it maps the region as cached.

Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 9 +++++++++
 include/linux/efi.h        | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 86da85368778..5b42bb6d1fde 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -535,3 +535,12 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	}
 	return 0;
 }
+
+void __iomem *efi_remap(phys_addr_t phys_addr, size_t size)
+{
+	if (efi_enabled(EFI_MEMMAP) &&
+	    (efi_mem_attributes(phys_addr) & EFI_MEMORY_UC))
+		return ioremap(phys_addr, size);
+	else
+		return ioremap_cache(phys_addr, size);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index af5be0368dec..0a0aa25d44d7 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -888,6 +888,7 @@ extern void efi_get_time(struct timespec *now);
 extern void efi_reserve_boot_services(void);
 extern int efi_get_fdt_params(struct efi_fdt_params *params, int verbose);
 extern struct efi_memory_map memmap;
+extern void __iomem *efi_remap(phys_addr_t phys_addr, size_t size);
 
 extern int efi_reboot_quirk_mode;
 extern bool efi_poweroff_required(void);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
