From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH 1/3] efi: Introduce *_continue efi_memory_desc iterators
Date: Tue, 31 May 2016 16:14:30 +0100
Message-ID: <1464707672-21882-2-git-send-email-catalin.marinas@arm.com>
References: <1464707672-21882-1-git-send-email-catalin.marinas@arm.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464707672-21882-1-git-send-email-catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The for_each_efi_memory_desc_continue() macro and corresponding
"_in_map" allow iterating over an efi_memory_map from a given position.
For code reuse between the existing iterator and the _continue variant,
this patch also introduces efi_memory_desc_next_entry_map().

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
---
 include/linux/efi.h | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index c2db3ca22217..4b0d880f1cd7 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1002,11 +1002,16 @@ extern int efi_memattr_init(void);
 extern int efi_memattr_apply_permissions(struct mm_struct *mm,
 					 efi_memattr_perm_setter fn);
 
+/* Find next entry in an efi_memory_map or NULL if md is last */
+#define efi_memory_desc_next_entry_map(m, md)				   \
+	((md) == (efi_memory_desc_t *)((m)->map_end - (m)->desc_size)	   \
+	 ? NULL : (void *)(md) + (m)->desc_size)
+
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc_in_map(m, md)				   \
 	for ((md) = (m)->map;						   \
-	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
-	     (md) = (void *)(md) + (m)->desc_size)
+	     (md);							   \
+	     (md) = efi_memory_desc_next_entry_map(m, md))
 
 /**
  * for_each_efi_memory_desc - iterate over descriptors in efi.memmap
@@ -1017,6 +1022,16 @@ extern int efi_memattr_apply_permissions(struct mm_struct *mm,
 #define for_each_efi_memory_desc(md) \
 	for_each_efi_memory_desc_in_map(&efi.memmap, md)
 
+/* Continue iterating through an efi_memory_map */
+#define for_each_efi_memory_desc_in_map_continue(m, md)			   \
+	for ((md) = efi_memory_desc_next_entry_map(m, md);		   \
+	     (md);							   \
+	     (md) = efi_memory_desc_next_entry_map(m, md))
+
+/* Continue iterating through efi.memmap */
+#define for_each_efi_memory_desc_continue(md) \
+	for_each_efi_memory_desc_in_map_continue(&efi.memmap, md)
+
 /*
  * Format an EFI memory descriptor's type and attributes to a user-provided
  * character buffer, as per snprintf(), and return the buffer.
