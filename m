From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] x86/efi: Clean up a minor mistake in code comment
Date: Fri, 24 Mar 2017 17:17:20 +0800
Message-ID: <1490347040-28720-1-git-send-email-bhe@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

EFI allocate runtime services regions from EFI_VA_START, -4G, down
to -68G, EFI_VA_END, 64G altogether. The mechanism was introduced in
commit d2f7cbe7b26a7 ("x86/efi: Runtime services virtual mapping").

Clean it up to avoid confusion.

Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
v1->v2:
  Update patch log to corret a description mistake Ard pointed out.

 arch/x86/platform/efi/efi_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index a4695da..6cbf9e0 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -47,7 +47,7 @@
 #include <asm/pgalloc.h>
 
 /*
- * We allocate runtime services regions bottom-up, starting from -4G, i.e.
+ * We allocate runtime services regions top-down, starting from -4G, i.e.
  * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
  */
 static u64 efi_va = EFI_VA_START;
-- 
2.5.5
