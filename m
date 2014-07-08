From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH] efi: Update stale locking comment for struct efivars
Date: Tue,  8 Jul 2014 12:44:17 +0100
Message-ID: <1404819857-895-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The comment describing how struct efivars->lock is used hasn't been
updated in sync with the code. Fix it.

Reported-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/linux/efi.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 59c8acfebca7..efc681fd5895 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1040,12 +1040,8 @@ struct efivar_operations {
 struct efivars {
 	/*
 	 * ->lock protects two things:
-	 * 1) ->list - adds, removals, reads, writes
-	 * 2) ops.[gs]et_variable() calls.
-	 * It must not be held when creating sysfs entries or calling kmalloc.
-	 * ops.get_next_variable() is only called from register_efivars()
-	 * or efivar_update_sysfs_entries(),
-	 * which is protected by the BKL, so that path is safe.
+	 * 1) efivarfs_list and efivars_sysfs_list
+	 * 2) ->ops calls
 	 */
 	spinlock_t lock;
 	struct kset *kset;
-- 
1.9.0
