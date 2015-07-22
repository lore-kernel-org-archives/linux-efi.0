From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Don't print an error on unsupported BGRT version.
Date: Wed, 22 Jul 2015 13:13:27 -0400
Message-ID: <1437585207-32516-1-git-send-email-pjones@redhat.com>
References: <20150722165357.GC1203@jtriplet-mobl1>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150722165357.GC1203@jtriplet-mobl1>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

BGRT can legitimately be a different version from what we support, and
that's a problem with the driver not supporting something, not an error
that needs to be surfaced to the user.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi-bgrt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index d7f997f..e369162 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -46,7 +46,7 @@ void __init efi_bgrt_init(void)
 		return;
 	}
 	if (bgrt_tab->version != 1) {
-		pr_err("Ignoring BGRT: invalid version %u (expected 1)\n",
+		pr_notice("Ignoring BGRT: invalid version %u (expected 1)\n",
 		       bgrt_tab->version);
 		return;
 	}
-- 
2.4.3
