From: Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 1/3] firmware loader: Introduce new API - request_firmware_abort()
Date: Fri, 24 Oct 2014 14:18:20 +0800
Message-ID: <1414131502-13886-2-git-send-email-hock.leong.kweh@intel.com>
References: <1414131502-13886-1-git-send-email-hock.leong.kweh@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414131502-13886-1-git-send-email-hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Besides aborting through user helper interface, a new API
request_firmware_abort() allows kernel driver module to abort the
request_firmware() / request_firmware_nowait() when they are no
longer needed. It is useful for cancelling an outstanding firmware
load if initiated from inside a module where that module is in the
process of being unloaded, since the unload function may not have
a handle to the struct firmware_buf.

Note for people who use request_firmware_nowait():
You are required to do your own synchronization after you call
request_firmware_abort() in order to continue unloading the
module. The example synchronization code shows below:

while (THIS_MODULE && module_refcount(THIS_MODULE))
	msleep(20);

Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kweh, Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/base/firmware_class.c |   30 ++++++++++++++++++++++++++++++
 include/linux/firmware.h      |    4 ++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d276e33..b2fe40b 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1291,6 +1291,36 @@ request_firmware_nowait(
 }
 EXPORT_SYMBOL(request_firmware_nowait);
 
+/**
+ * request_firmware_abort - abort the waiting of firmware request
+ * @fw_name: name of firmware file
+ *
+ *	@fw_name is the same name string while calling to request_firmware()
+ *		or request_firmware_nowait().
+ **/
+int request_firmware_abort(const char *fw_name)
+{
+	struct firmware_buf *buf;
+	struct firmware_buf *entry;
+
+	spin_lock(&fw_cache.lock);
+	buf = __fw_lookup_buf(fw_name);
+	spin_unlock(&fw_cache.lock);
+	if (!buf)
+		return -ENOENT;
+
+	mutex_lock(&fw_lock);
+	list_for_each_entry(entry, &pending_fw_head, pending_list) {
+		if (entry == buf) {
+			__fw_load_abort(buf);
+			break;
+		}
+	}
+	mutex_unlock(&fw_lock);
+	return 0;
+}
+EXPORT_SYMBOL(request_firmware_abort);
+
 #ifdef CONFIG_PM_SLEEP
 static ASYNC_DOMAIN_EXCLUSIVE(fw_cache_domain);
 
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 5952933..ed90c8b 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -47,6 +47,7 @@ int request_firmware_nowait(
 	void (*cont)(const struct firmware *fw, void *context));
 
 void release_firmware(const struct firmware *fw);
+int request_firmware_abort(const char *fw_name);
 #else
 static inline int request_firmware(const struct firmware **fw,
 				   const char *name,
@@ -66,6 +67,9 @@ static inline void release_firmware(const struct firmware *fw)
 {
 }
 
+static inline int request_firmware_abort(const char *fw_name)
+{
+}
 #endif
 
 #ifdef CONFIG_FW_LOADER_USER_HELPER
-- 
1.7.9.5
