From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH V3 05/11] asus-wmi: Restrict debugfs interface when module loading is restricted
Date: Tue,  3 Sep 2013 19:50:12 -0400
Message-ID: <1378252218-18798-6-git-send-email-matthew.garrett@nebula.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, keescook@chromium.org, hpa@zytor.com, Matthew Garrett <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

We have no way of validating what all of the Asus WMI methods do on a
given machine, and there's a risk that some will allow hardware state to
be manipulated in such a way that arbitrary code can be executed in the
kernel, circumventing module loading restrictions. Prevent that if any of
these features are enabled.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/platform/x86/asus-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 19c313b..db18ef66 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1618,6 +1618,9 @@ static int show_dsts(struct seq_file *m, void *data)
 	int err;
 	u32 retval = -1;
 
+	if (secure_modules())
+		return -EPERM;
+
 	err = asus_wmi_get_devstate(asus, asus->debug.dev_id, &retval);
 
 	if (err < 0)
@@ -1634,6 +1637,9 @@ static int show_devs(struct seq_file *m, void *data)
 	int err;
 	u32 retval = -1;
 
+	if (secure_modules())
+		return -EPERM;
+
 	err = asus_wmi_set_devstate(asus->debug.dev_id, asus->debug.ctrl_param,
 				    &retval);
 
@@ -1658,6 +1664,9 @@ static int show_call(struct seq_file *m, void *data)
 	union acpi_object *obj;
 	acpi_status status;
 
+	if (secure_modules())
+		return -EPERM;
+
 	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
 				     1, asus->debug.method_id,
 				     &input, &output);
-- 
1.8.3.1
