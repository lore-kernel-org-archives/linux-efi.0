From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] efi: ESRT: fix some compile warnings.
Date: Thu, 30 Apr 2015 10:49:20 -0400
Message-ID: <1430405360-30990-1-git-send-email-pjones@redhat.com>
References: <201504301907.1MmWLeON%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201504301907.1MmWLeON%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Apparently I missed some compiler warnings on 32-bit platforms, where
phys_addr_t isn't the same size as void * and I casted it to make print=
k
work.  Obviously I should have thought "I'm printing some random type,
instead of typecasting I should check Documentation/printk-formats.txt
and see how to do it." o/~ The More You Know =E2=98=86=E5=BD=A1 o/~

This patch also fixes one other warning about an uninitialized variable
some compiler versions seem to see.  You can't actually hit the code
path where it would be uninitialized, because there's a prior test that
would error out, but gcc hasn't figured that out.  Anyway, it now has a
test and returns the error at both places.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/esrt.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
index 20c0cbd..a5b95d6 100644
--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -167,7 +167,6 @@ static struct kset *esrt_kset;
=20
 static int esre_create_sysfs_entry(void *esre, int entry_num)
 {
-	int rc =3D 0;
 	struct esre_entry *entry;
 	char name[20];
=20
@@ -180,13 +179,15 @@ static int esre_create_sysfs_entry(void *esre, in=
t entry_num)
 	entry->kobj.kset =3D esrt_kset;
=20
 	if (esrt->fw_resource_version =3D=3D 1) {
+		int rc =3D 0;
+
 		entry->esre.esre1 =3D esre;
 		rc =3D kobject_init_and_add(&entry->kobj, &esre1_ktype, NULL,
 					  "%s", name);
-	}
-	if (rc) {
-		kfree(entry);
-		return rc;
+		if (rc) {
+			kfree(entry);
+			return rc;
+		}
 	}
=20
 	list_add_tail(&entry->list, &entry_list);
@@ -248,6 +249,7 @@ void __init efi_esrt_init(void)
 	size_t size, max, entry_size, entries_size;
 	efi_memory_desc_t md;
 	int rc;
+	phys_addr_t end;
=20
 	pr_debug("esrt-init: loading.\n");
 	if (!esrt_table_exists())
@@ -335,8 +337,8 @@ void __init efi_esrt_init(void)
 	esrt_data =3D (phys_addr_t)efi.esrt;
 	esrt_data_size =3D size;
=20
-	pr_info("Reserving ESRT space from %p to %p.\n", (void *)esrt_data,
-		(char *)esrt_data + size);
+	end =3D esrt_data + size;
+	pr_info("Reserving ESRT space from %pa to %pa.\n", &esrt_data, &end);
 	memblock_reserve(esrt_data, esrt_data_size);
=20
 	pr_debug("esrt-init: loaded.\n");
@@ -353,11 +355,16 @@ static int __init register_entries(void)
 		return 0;
=20
 	for (i =3D 0; i < le32_to_cpu(esrt->fw_resource_count); i++) {
-		void *entry;
+		void *esre =3D NULL;
 		if (esrt->fw_resource_version =3D=3D 1) {
-			entry =3D &v1_entries[i];
+			esre =3D &v1_entries[i];
+		} else {
+			pr_err("Unsupported ESRT version %lld.\n",
+			       esrt->fw_resource_version);
+			return -EINVAL;
 		}
-		rc =3D esre_create_sysfs_entry(entry, i);
+
+		rc =3D esre_create_sysfs_entry(esre, i);
 		if (rc < 0) {
 			pr_err("ESRT entry creation failed with error %d.\n",
 			       rc);
@@ -387,7 +394,7 @@ static int __init esrt_sysfs_init(void)
=20
 	ioesrt =3D ioremap(esrt_data, esrt_data_size);
 	if (!ioesrt) {
-		pr_err("ioremap(%p, %zu) failed.\n", (void *)esrt_data,
+		pr_err("ioremap(%pa, %zu) failed.\n", &esrt_data,
 		       esrt_data_size);
 		return -ENOMEM;
 	}
--=20
2.3.6
