From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5] efi: introduce efi_md_typeattr_format()
Date: Mon,  1 Sep 2014 02:53:37 +0200
Message-ID: <1409532820-5027-3-git-send-email-lersek@redhat.com>
References: <1409532820-5027-1-git-send-email-lersek@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409532820-5027-1-git-send-email-lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

At the moment, there are three architectures debug-printing the EFI memory
map at initialization: x86, ia64, and arm64. They all use different format
strings, plus the EFI memory type and the EFI memory attributes are
similarly hard to decode for a human reader.

Introduce a helper __init function that formats the memory type and the
memory attributes in a unified way, to a user-provided character buffer.

The array "memory_type_name" is copied from the arm64 code, temporarily
duplicating it. The (otherwise optional) braces around each string literal
in the initializer list are dropped in order to match the kernel coding
style more closely. The element size is tightened from 32 to 20 bytes
(maximum actual string length + 1) so that we can derive the field width
from the element size.

Signed-off-by: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/efi.h        |  7 ++++++
 drivers/firmware/efi/efi.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index b4b1d8d..d04d618 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -887,6 +887,13 @@ extern bool efi_poweroff_required(void);
 	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
 	     (md) = (void *)(md) + (m)->desc_size)
 
+/*
+ * Format an EFI memory descriptor's type and attributes to a user-provided
+ * character buffer, as per snprintf(), and return the buffer.
+ */
+char * __init efi_md_typeattr_format(char *buf, size_t size,
+				     const efi_memory_desc_t *md);
+
 /**
  * efi_range_is_wc - check the WC bit on an address range
  * @start: starting kvirt address
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 64ecbb5..43d9d25 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -423,3 +423,60 @@ int __init efi_get_fdt_params(struct efi_fdt_params *params, int verbose)
 	return ret;
 }
 #endif /* CONFIG_EFI_PARAMS_FROM_FDT */
+
+static __initdata char memory_type_name[][20] = {
+	"Reserved",
+	"Loader Code",
+	"Loader Data",
+	"Boot Code",
+	"Boot Data",
+	"Runtime Code",
+	"Runtime Data",
+	"Conventional Memory",
+	"Unusable Memory",
+	"ACPI Reclaim Memory",
+	"ACPI Memory NVS",
+	"Memory Mapped I/O",
+	"MMIO Port Space",
+	"PAL Code"
+};
+
+char * __init efi_md_typeattr_format(char *buf, size_t size,
+				     const efi_memory_desc_t *md)
+{
+	char *pos;
+	int type_len;
+	register u64 attr;
+
+	pos = buf;
+	if (md->type >= ARRAY_SIZE(memory_type_name))
+		type_len = snprintf(pos, size, "[type=%u", md->type);
+	else
+		type_len = snprintf(pos, size, "[%-*s",
+				    (int)(sizeof(memory_type_name[0]) - 1),
+				    memory_type_name[md->type]);
+	if (type_len >= size)
+		return buf;
+
+	pos += type_len;
+	size -= type_len;
+
+	attr = md->attribute;
+	if (attr & ~(EFI_MEMORY_UC | EFI_MEMORY_WC | EFI_MEMORY_WT |
+		     EFI_MEMORY_WB | EFI_MEMORY_UCE | EFI_MEMORY_WP |
+		     EFI_MEMORY_RP | EFI_MEMORY_XP | EFI_MEMORY_RUNTIME))
+		snprintf(pos, size, "|attr=0x%016llx]",
+			 (unsigned long long)attr);
+	else
+		snprintf(pos, size, "|%3s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
+			 attr & EFI_MEMORY_RUNTIME ? "RUN" : "",
+			 attr & EFI_MEMORY_XP      ? "XP"  : "",
+			 attr & EFI_MEMORY_RP      ? "RP"  : "",
+			 attr & EFI_MEMORY_WP      ? "WP"  : "",
+			 attr & EFI_MEMORY_UCE     ? "UCE" : "",
+			 attr & EFI_MEMORY_WB      ? "WB"  : "",
+			 attr & EFI_MEMORY_WT      ? "WT"  : "",
+			 attr & EFI_MEMORY_WC      ? "WC"  : "",
+			 attr & EFI_MEMORY_UC      ? "UC"  : "");
+	return buf;
+}
-- 
1.8.3.1
