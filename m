From: Bojan Prtvar <prtvar.b-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] efivars: Mark local function as static
Date: Tue,  3 Sep 2013 08:56:20 +0200
Message-ID: <1378191380-6048-1-git-send-email-prtvar.b@gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bojan Prtvar <prtvar.b-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This fixes the following sparse warning
drivers/firmware/efi/efivars.c:567:6: warning: symbol 'efivars_sysfs_exit' was not declared. Should it be static?

Signed-off-by: Bojan Prtvar <prtvar.b-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/efivars.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 8a7432a..933eb02 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -564,7 +564,7 @@ static int efivar_sysfs_destroy(struct efivar_entry *entry, void *data)
 	return 0;
 }
 
-void efivars_sysfs_exit(void)
+static void efivars_sysfs_exit(void)
 {
 	/* Remove all entries and destroy */
 	__efivar_entry_iter(efivar_sysfs_destroy, &efivar_sysfs_list, NULL, NULL);
-- 
1.7.1
