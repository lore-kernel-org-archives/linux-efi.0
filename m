From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 1/2] pstore: Split pstore fragile flags
Date: Thu, 21 Jul 2016 09:59:17 +0900
Message-ID: <1469062758-1190-1-git-send-email-namhyung@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

This patch adds new PSTORE_FLAGS for each pstore type so that they can
be enabled separately.  This is a preparation for ongoing virtio-pstore
work to support those types flexibly.

The PSTORE_FLAGS_FRAGILE is changed to PSTORE_FLAGS_DMESG to preserve the
original behavior.

Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Cc: Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/acpi/apei/erst.c          |  2 +-
 drivers/firmware/efi/efi-pstore.c |  2 +-
 fs/pstore/platform.c              | 21 +++++++++++++--------
 fs/pstore/ram.c                   |  2 ++
 include/linux/pstore.h            |  7 ++++++-
 5 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 006c3894c6ea..f0cb7b0fbac8 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -937,7 +937,7 @@ static int erst_clearer(enum pstore_type_id type, u64 id, int count,
 static struct pstore_info erst_info = {
 	.owner		= THIS_MODULE,
 	.name		= "erst",
-	.flags		= PSTORE_FLAGS_FRAGILE,
+	.flags		= PSTORE_FLAGS_DMESG,
 	.open		= erst_open_pstore,
 	.close		= erst_close_pstore,
 	.read		= erst_reader,
diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index eac76a79a880..dcb61a6f7ea7 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -356,7 +356,7 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 static struct pstore_info efi_pstore_info = {
 	.owner		= THIS_MODULE,
 	.name		= "efi",
-	.flags		= PSTORE_FLAGS_FRAGILE,
+	.flags		= PSTORE_FLAGS_DMESG,
 	.open		= efi_pstore_open,
 	.close		= efi_pstore_close,
 	.read		= efi_pstore_read,
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 588461bb2dd4..6e86b7ea095d 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -467,13 +467,14 @@ int pstore_register(struct pstore_info *psi)
 	if (pstore_is_mounted())
 		pstore_get_records(0);
 
-	pstore_register_kmsg();
-
-	if ((psi->flags & PSTORE_FLAGS_FRAGILE) == 0) {
+	if (psi->flags & PSTORE_FLAGS_DMESG)
+		pstore_register_kmsg();
+	if (psi->flags & PSTORE_FLAGS_CONSOLE)
 		pstore_register_console();
+	if (psi->flags & PSTORE_FLAGS_FTRACE)
 		pstore_register_ftrace();
+	if (psi->flags & PSTORE_FLAGS_PMSG)
 		pstore_register_pmsg();
-	}
 
 	if (pstore_update_ms >= 0) {
 		pstore_timer.expires = jiffies +
@@ -497,10 +498,14 @@ EXPORT_SYMBOL_GPL(pstore_register);
 
 void pstore_unregister(struct pstore_info *psi)
 {
-	pstore_unregister_pmsg();
-	pstore_unregister_ftrace();
-	pstore_unregister_console();
-	pstore_unregister_kmsg();
+	if (psi->flags & PSTORE_FLAGS_PMSG)
+		pstore_unregister_pmsg();
+	if (psi->flags & PSTORE_FLAGS_FTRACE)
+		pstore_unregister_ftrace();
+	if (psi->flags & PSTORE_FLAGS_CONSOLE)
+		pstore_unregister_console();
+	if (psi->flags & PSTORE_FLAGS_DMESG)
+		pstore_unregister_kmsg();
 
 	free_buf_for_compression();
 
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index bd9812e83461..d08bfd611b11 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -539,6 +539,8 @@ static int ramoops_probe(struct platform_device *pdev)
 		goto fail_clear;
 	}
 
+	cxt->pstore.flags = PSTORE_FLAGS_ALL;
+
 	err = pstore_register(&cxt->pstore);
 	if (err) {
 		pr_err("registering with pstore failed\n");
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 831479f8df8f..3ba0c1af40e5 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -73,7 +73,12 @@ struct pstore_info {
 	void		*data;
 };
 
-#define	PSTORE_FLAGS_FRAGILE	1
+#define PSTORE_FLAGS_DMESG	(1 << 0)
+#define PSTORE_FLAGS_CONSOLE	(1 << 1)
+#define PSTORE_FLAGS_FTRACE	(1 << 2)
+#define PSTORE_FLAGS_PMSG	(1 << 3)
+
+#define PSTORE_FLAGS_ALL	((1 << 4) - 1)
 
 extern int pstore_register(struct pstore_info *);
 extern void pstore_unregister(struct pstore_info *);
-- 
2.8.0
