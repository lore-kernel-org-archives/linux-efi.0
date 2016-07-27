From: Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 1/7] pstore: Split pstore fragile flags
Date: Thu, 28 Jul 2016 00:08:25 +0900
Message-ID: <1469632111-23260-2-git-send-email-namhyung@kernel.org>
References: <1469632111-23260-1-git-send-email-namhyung@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1469632111-23260-1-git-send-email-namhyung@kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: kvm@vger.kernel.org, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org
Cc: Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>, Matt Fleming <matt@codeblueprint.co.uk>, Anton Vorontsov <anton@enomsg.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, Colin Cross <ccross@android.com>, Len Brown <lenb@kernel.org>
List-Id: linux-efi@vger.kernel.org

This patch adds new PSTORE_FLAGS for each pstore type so that they can
be enabled separately.  This is a preparation for ongoing virtio-pstore
work to support those types flexibly.

The PSTORE_FLAGS_FRAGILE is changed to PSTORE_FLAGS_DMESG to preserve the
original behavior.

Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-acpi@vger.kernel.org
Cc: linux-efi@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 drivers/acpi/apei/erst.c          |  2 +-
 drivers/firmware/efi/efi-pstore.c |  2 +-
 fs/pstore/platform.c              | 17 ++++++++++-------
 fs/pstore/ram.c                   |  2 ++
 include/linux/pstore.h            |  7 ++++++-
 5 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index f096ab3cb54d..ec4f507b524f 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -938,7 +938,7 @@ static int erst_clearer(enum pstore_type_id type, u64 id, int count,
 static struct pstore_info erst_info = {
 	.owner		= THIS_MODULE,
 	.name		= "erst",
-	.flags		= PSTORE_FLAGS_FRAGILE,
+	.flags		= PSTORE_FLAGS_DMESG,
 	.open		= erst_open_pstore,
 	.close		= erst_close_pstore,
 	.read		= erst_reader,
diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 30a24d09ea6c..4daa5acd9117 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -362,7 +362,7 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 static struct pstore_info efi_pstore_info = {
 	.owner		= THIS_MODULE,
 	.name		= "efi",
-	.flags		= PSTORE_FLAGS_FRAGILE,
+	.flags		= PSTORE_FLAGS_DMESG,
 	.open		= efi_pstore_open,
 	.close		= efi_pstore_close,
 	.read		= efi_pstore_read,
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 16ecca5b72d8..76dd604a0f2c 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -659,13 +659,14 @@ int pstore_register(struct pstore_info *psi)
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
@@ -689,12 +690,14 @@ EXPORT_SYMBOL_GPL(pstore_register);
 
 void pstore_unregister(struct pstore_info *psi)
 {
-	if ((psi->flags & PSTORE_FLAGS_FRAGILE) == 0) {
+	if (psi->flags & PSTORE_FLAGS_PMSG)
 		pstore_unregister_pmsg();
+	if (psi->flags & PSTORE_FLAGS_FTRACE)
 		pstore_unregister_ftrace();
+	if (psi->flags & PSTORE_FLAGS_CONSOLE)
 		pstore_unregister_console();
-	}
-	pstore_unregister_kmsg();
+	if (psi->flags & PSTORE_FLAGS_DMESG)
+		pstore_unregister_kmsg();
 
 	free_buf_for_compression();
 
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 47516a794011..ba19a74e95bc 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -624,6 +624,8 @@ static int ramoops_probe(struct platform_device *pdev)
 		goto fail_clear;
 	}
 
+	cxt->pstore.flags = PSTORE_FLAGS_ALL;
+
 	err = pstore_register(&cxt->pstore);
 	if (err) {
 		pr_err("registering with pstore failed\n");
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 899e95e84400..069b96faf478 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -74,7 +74,12 @@ struct pstore_info {
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
