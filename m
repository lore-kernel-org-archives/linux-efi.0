From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH resend] fix boot hang with earlyprintk=efi,keep
Date: Sat, 9 Dec 2017 12:16:10 +0800
Message-ID: <20171209041610.GA3249@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, bp-l3A5Bk7waGM@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

earlyprintk=efi,keep does not work any more with a warning
in mm/early_ioremap.c: WARN_ON(system_state != SYSTEM_BOOTING):
Boot just hangs because of the earlyprintk within earlyprintk
implementation code.

This is caused by a new introduced middle state in below commit:
commit 69a78ff226fe ("init: Introduce SYSTEM_SCHEDULING state")
early_ioremap is fine in both SYSTEM_BOOTING and SYSTEM_SCHEDULING
states, original condition should be updated accordingly.

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
v1->v2: update patch log correct some typos
 mm/early_ioremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-x86.orig/mm/early_ioremap.c
+++ linux-x86/mm/early_ioremap.c
@@ -111,7 +111,7 @@ __early_ioremap(resource_size_t phys_add
 	enum fixed_addresses idx;
 	int i, slot;
 
-	WARN_ON(system_state != SYSTEM_BOOTING);
+	WARN_ON(system_state >= SYSTEM_RUNNING);
 
 	slot = -1;
 	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
