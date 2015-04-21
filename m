From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] efi: fix error handling in add_sysfs_runtime_map_entry()
Date: Tue, 21 Apr 2015 16:46:28 +0300
Message-ID: <20150421134628.GA9653@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Guangyu Sun <guangyu.sun-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

I spotted two (difficult to hit) bugs while reviewing this.

1)  There is a double free bug because we unregister "map_kset" in
    add_sysfs_runtime_map_entry() and also efi_runtime_map_init().
2)  If we fail to allocate "entry" then we should return
    ERR_PTR(-ENOMEM) instead of NULL.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
index 87b8e3b..5c55227 100644
--- a/drivers/firmware/efi/runtime-map.c
+++ b/drivers/firmware/efi/runtime-map.c
@@ -120,7 +120,8 @@ add_sysfs_runtime_map_entry(struct kobject *kobj, int nr)
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry) {
 		kset_unregister(map_kset);
-		return entry;
+		map_kset = NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	memcpy(&entry->md, efi_runtime_map + nr * efi_memdesc_size,
@@ -132,6 +133,7 @@ add_sysfs_runtime_map_entry(struct kobject *kobj, int nr)
 	if (ret) {
 		kobject_put(&entry->kobj);
 		kset_unregister(map_kset);
+		map_kset = NULL;
 		return ERR_PTR(ret);
 	}
 
@@ -195,8 +197,6 @@ out_add_entry:
 		entry = *(map_entries + j);
 		kobject_put(&entry->kobj);
 	}
-	if (map_kset)
-		kset_unregister(map_kset);
 out:
 	return ret;
 }
