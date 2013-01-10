From: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 1/6] x86, efi: Fix display detection in EFI boot stub
Date: Thu, 10 Jan 2013 18:04:23 +0000
Message-ID: <1357841068-6582-1-git-send-email-dwmw2@infradead.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When booting under OVMF we have precisely one GOP device, and it
implements the ConOut protocol.

We break out of the loop when we look at it... and then promptly abort
because 'first_gop' never gets set. We should set first_gop *before*
breaking out of the loop. Yes, it doesn't really mean "first" any more,
but that doesn't matter. It's only a flag to indicate that a suitable
GOP was found.

In fact, we'd do just as well to initialise 'width' to zero in this
function, then just check *that* instead of first_gop. But I'll do the
minimal fix for now (and for stable@).

Signed-off-by: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
---
 arch/x86/boot/compressed/eboot.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b1942e2..03d8c9b 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -432,10 +432,9 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 			 * Once we've found a GOP supporting ConOut,
 			 * don't bother looking any further.
 			 */
+			first_gop = gop;
 			if (conout_found)
 				break;
-
-			first_gop = gop;
 		}
 	}
 
-- 
1.8.0.1
