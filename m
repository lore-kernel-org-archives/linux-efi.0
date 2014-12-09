From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Update the URLs for efibootmgr.
Date: Tue,  9 Dec 2014 16:14:11 -0500
Message-ID: <1418159651-20465-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Matt Domsch changed the dell page to point to the new upstream quite
some time ago; kernel should reflect that here as well.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index f712d47..8de4da5 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -12,11 +12,11 @@ config EFI_VARS
 
 	  Note that using this driver in concert with efibootmgr requires
 	  at least test release version 0.5.0-test3 or later, which is
-	  available from Matt Domsch's website located at:
+	  available from:
 	  <http://linux.dell.com/efibootmgr/testing/efibootmgr-0.5.0-test3.tar.gz>
 
 	  Subsequent efibootmgr releases may be found at:
-	  <http://linux.dell.com/efibootmgr>
+	  <http://github.com/vathpela/efibootmgr>
 
 config EFI_VARS_PSTORE
 	tristate "Register efivars backend for pstore"
-- 
2.1.0
