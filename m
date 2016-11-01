From: Eugene Korenevsky <ekorenevsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] EFI loader: remove dead code
Date: Tue, 1 Nov 2016 20:38:08 +0300
Message-ID: <20161101173808.GA2682@vnote>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Linn Crosetto <linn-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

*e820ext is always NULL in 'alloc_e820ext()' (see the code of 'exit_boot()').
Therefore the 'if' condition is always false and the entire 'if' statement is
pointless. Remove it.

---
 arch/x86/boot/compressed/eboot.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index cc69e37..edfd4d6 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -956,12 +956,6 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
 	size = sizeof(struct setup_data) +
 		sizeof(struct e820entry) * nr_desc;
 
-	if (*e820ext) {
-		efi_call_early(free_pool, *e820ext);
-		*e820ext = NULL;
-		*e820ext_size = 0;
-	}
-
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
 				size, (void **)e820ext);
 	if (status == EFI_SUCCESS)
-- 
2.10.2
