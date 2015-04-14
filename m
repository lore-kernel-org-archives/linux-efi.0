From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 1/2] firmware_loader: introduce new API - request_firmware_direct_full_path()
Date: Tue, 14 Apr 2015 17:44:55 +0800
Message-ID: <1429004697-28320-2-git-send-email-hock.leong.kweh@intel.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429004697-28320-1-git-send-email-hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Introduce this new API for loading firmware from a specific location
instead of /lib/firmware/ by providing a full path to the firmware
file.

Cc: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kweh, Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/base/firmware_class.c |   46 ++++++++++++++++++++++++++++++++++++-----
 include/linux/firmware.h      |    9 ++++++++
 2 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 171841a..3ab7bb9 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -111,6 +111,7 @@ static inline long firmware_loading_timeout(void)
 #define FW_OPT_FALLBACK		0
 #endif
 #define FW_OPT_NO_WARN	(1U << 3)
+#define FW_OPT_FULL_PATH	(1U << 4)
 
 struct firmware_cache {
 	/* firmware_buf instance will be added into the below list */
@@ -318,20 +319,29 @@ fail:
 }
 
 static int fw_get_filesystem_firmware(struct device *device,
-				       struct firmware_buf *buf)
+				      struct firmware_buf *buf,
+				      unsigned int opt_flags)
 {
 	int i;
 	int rc = -ENOENT;
 	char *path = __getname();
+	int path_array_size = 1;
+	static const char * const root_path[] = {"/"};
+	char **temp_path = (char **)root_path;
 
-	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
+	if (!(opt_flags & FW_OPT_FULL_PATH)) {
+		temp_path = (char **)fw_path;
+		path_array_size = ARRAY_SIZE(fw_path);
+	}
+
+	for (i = 0; i < path_array_size; i++) {
 		struct file *file;
 
 		/* skip the unset customized path */
-		if (!fw_path[i][0])
+		if (!temp_path[i][0])
 			continue;
 
-		snprintf(path, PATH_MAX, "%s/%s", fw_path[i], buf->fw_id);
+		snprintf(path, PATH_MAX, "%s/%s", temp_path[i], buf->fw_id);
 
 		file = filp_open(path, O_RDONLY, 0);
 		if (IS_ERR(file))
@@ -1122,7 +1132,7 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		}
 	}
 
-	ret = fw_get_filesystem_firmware(device, fw->priv);
+	ret = fw_get_filesystem_firmware(device, fw->priv, opt_flags);
 	if (ret) {
 		if (!(opt_flags & FW_OPT_NO_WARN))
 			dev_warn(device,
@@ -1210,6 +1220,32 @@ int request_firmware_direct(const struct firmware **firmware_p,
 EXPORT_SYMBOL_GPL(request_firmware_direct);
 
 /**
+ * request_firmware_direct_full_path: - load firmware directly from exact
+ *                                      full path
+ * @firmware_p: pointer to firmware image
+ * @name: full path to the firmware file with file name
+ * @device: device for which firmware is being loaded
+ *
+ * This function works like request_firmware_direct(), but this doesn't
+ * search the /lib/firmware/ for the firmware file. It support exact full
+ * path to the firmware file for loading.
+ **/
+int request_firmware_direct_full_path(const struct firmware **firmware_p,
+				      const char *name, struct device *device)
+{
+	int ret;
+
+	__module_get(THIS_MODULE);
+	ret = _request_firmware(firmware_p, name, device,
+				FW_OPT_UEVENT | FW_OPT_NO_WARN |
+				FW_OPT_FULL_PATH);
+	module_put(THIS_MODULE);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(request_firmware_direct_full_path);
+
+/**
  * release_firmware: - release the resource associated with a firmware image
  * @fw: firmware resource to release
  **/
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 5c41c5e..b7c6435 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -47,6 +47,8 @@ int request_firmware_nowait(
 	void (*cont)(const struct firmware *fw, void *context));
 int request_firmware_direct(const struct firmware **fw, const char *name,
 			    struct device *device);
+int request_firmware_direct_full_path(const struct firmware **fw,
+				      const char *name, struct device *device);
 
 void release_firmware(const struct firmware *fw);
 #else
@@ -75,5 +77,12 @@ static inline int request_firmware_direct(const struct firmware **fw,
 	return -EINVAL;
 }
 
+static inline int request_firmware_direct_full_path(const struct firmware **fw,
+						    const char *name,
+						    struct device *device)
+{
+	return -EINVAL;
+}
+
 #endif
 #endif
-- 
1.7.9.5
