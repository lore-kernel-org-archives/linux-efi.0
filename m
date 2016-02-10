From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] efi: minor fixup in efivar_validate() declaration
Date: Wed, 10 Feb 2016 09:51:02 -0500
Message-ID: <1455115862-2490-1-git-send-email-pjones@redhat.com>
References: <20160210132225.GA2949@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160210132225.GA2949-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

When I switched the function to data_size as the parameter name, I
forgot to fix the header.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/efi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 1869d5c..47be3ad 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1200,7 +1200,7 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
 				       struct list_head *head, bool remove);
 
 bool efivar_validate(efi_guid_t vendor, efi_char16_t *var_name, u8 *data,
-		     unsigned long len);
+		     unsigned long data_size);
 bool efivar_variable_is_removable(efi_guid_t vendor, const char *name,
 				  size_t len);
 
-- 
2.5.0
