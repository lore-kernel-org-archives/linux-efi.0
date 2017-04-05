From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/24] asus-wmi: Restrict debugfs interface when the kernel
 is locked down
Date: Wed, 05 Apr 2017 18:12:12 +0100
Message-ID: <149141233199.31282.4267532443918292855.stgit@warthog.procyon.org.uk>
References: <149141219387.31282.6648284836568938717.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <149141219387.31282.6648284836568938717.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: matthew.garrett@nebula.com, linux-efi@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Matthew Garrett <matthew.garrett@nebula.com>

We have no way of validating what all of the Asus WMI methods do on a given
machine - and there's a risk that some will allow hardware state to be
manipulated in such a way that arbitrary code can be executed in the
kernel, circumventing module loading restrictions.  Prevent that if the
kernel is locked down.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/platform/x86/asus-wmi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 8fe5890bf539..feef25076813 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1900,6 +1900,9 @@ static int show_dsts(struct seq_file *m, void *data)
 	int err;
 	u32 retval = -1;
 
+	if (kernel_is_locked_down())
+		return -EPERM;
+
 	err = asus_wmi_get_devstate(asus, asus->debug.dev_id, &retval);
 
 	if (err < 0)
@@ -1916,6 +1919,9 @@ static int show_devs(struct seq_file *m, void *data)
 	int err;
 	u32 retval = -1;
 
+	if (kernel_is_locked_down())
+		return -EPERM;
+
 	err = asus_wmi_set_devstate(asus->debug.dev_id, asus->debug.ctrl_param,
 				    &retval);
 
@@ -1940,6 +1946,9 @@ static int show_call(struct seq_file *m, void *data)
 	union acpi_object *obj;
 	acpi_status status;
 
+	if (kernel_is_locked_down())
+		return -EPERM;
+
 	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
 				     1, asus->debug.method_id,
 				     &input, &output);

