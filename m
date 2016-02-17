From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] efi: Document #define FOO_PROTOCOL_GUID layout
Date: Wed, 17 Feb 2016 09:09:51 -0500
Message-ID: <1455718191-31244-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Add a comment documenting why EFI GUIDs are laid out like they are.
Ideally I'd like to change all the ", " to "," too, but right now the
format is such that checkpatch won't complain with new ones, and staring
at checkpatch didn't get me anywhere towards making that work.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/efi.h | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 99b88c5..3c27c88 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -533,7 +533,22 @@ typedef efi_status_t efi_query_variable_store_t(u32 attributes,
 void efi_native_runtime_setup(void);
 
 /*
- *  EFI Configuration Table and GUID definitions
+ * EFI Configuration Table and GUID definitions
+ *
+ * These should be formatted roughly like the ones in the UEFI SPEC has
+ * them.  It makes them easier to grep for, and they look the same when
+ * you're staring at them.  Here's the guide:
+ *
+ * GUID: 12345678-1234-1234-1234-123456789012
+ * Spec:
+ *      #define EFI_SOME_PROTOCOL_GUID \
+ *        {0x12345678,0x1234,0x1234,\
+ *          {0x12,0x34,0x12,0x34,0x56,0x78,0x90,0x12}}
+ * Here:
+ *	#define SOME_PROTOCOL_GUID \
+ *		EFI_GUID(0x12345678, 0x1234,  0x1234, \
+ *			 0x12, 0x34, 0x12, 0x34, 0x56, 0x78, 0x90, 0x12)
+ *      ^ tab   ^tab    ^ space
  */
 #define NULL_GUID \
 	EFI_GUID(0x00000000, 0x0000, 0x0000, \
-- 
2.5.0
