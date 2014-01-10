From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH V6 3/8] Add helper function to get and convert EFI command line
Date: Fri, 10 Jan 2014 08:30:12 -0800
Message-ID: <1389371417-379-4-git-send-email-roy.franz@linaro.org>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389371417-379-1-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dave.martin-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Add an EFI stub helper function to retrieve the EFI command line using
the LOADED_IMAGE_PROTOCOL, and convert it to ASCII.  This function will
be shared by the various EFI stub implementations.

Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index eb5d2eb..f657456 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -637,3 +637,33 @@ static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
 	*cmd_line_len = options_size;
 	return (char *)cmdline_addr;
 }
+
+/*
+ * get the command line from EFI, using the LOADED_IMAGE
+ * protocol, and convert to ASCII.
+ *
+ */
+static void efi_get_cmdline(efi_system_table_t *sys_table,
+			      efi_loaded_image_t **image,
+			      void *handle, char **cmdline_ptr)
+{
+	efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
+	efi_status_t status;
+	int cmdline_size;
+
+	status = efi_call_phys3(sys_table->boottime->handle_protocol,
+				handle, &proto, (void *)image);
+	if (status != EFI_SUCCESS) {
+		pr_efi_err(sys_table, "Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
+		*cmdline_ptr = NULL;
+		return;
+	}
+
+	/*
+	 * We are going to copy this into device tree, so we don't care where
+	 * in memory it is.
+	 */
+	*cmdline_ptr = efi_convert_cmdline_to_ascii(sys_table, *image,
+						    &cmdline_size);
+
+}
-- 
1.7.10.4
