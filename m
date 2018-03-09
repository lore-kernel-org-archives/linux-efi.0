From: Thiebaud Weksteen <tweek@google.com>
Subject: Re: Regression from efi: call get_event_log before ExitBootServices
Date: Fri,  9 Mar 2018 11:50:15 +0100
Message-ID: <20180309105015.97429-1-tweek@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeremy Cline <jeremy@jcline.org>
Cc: Javier Martinez Canillas <javierm@redhat.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, hdegoede@redhat.com, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, Thiebaud Weksteen <tweek@google.com>
List-Id: linux-efi@vger.kernel.org

---
 drivers/firmware/efi/libstub/tpm.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
index 773afcd6a37c..ee3fac109078 100644
--- a/drivers/firmware/efi/libstub/tpm.c
+++ b/drivers/firmware/efi/libstub/tpm.c
@@ -112,6 +112,22 @@ void efi_retrieve_tpm2_eventlog_1_2(efi_system_table_t *sys_table_arg)
 		log_size = log_last_entry - log_location + last_entry_size;
 	}
 
+	if (log_size == 0) {
+		efi_printk(sys_table_arg, "log_size == 0\n");
+	}
+	else if (log_size < 1 * 1024 * 1024) {
+		efi_printk(sys_table_arg, "log_size < 1M\n");
+	}
+	else if (log_size < 500 * 1024 * 1024) {
+		efi_printk(sys_table_arg, "log_size < 500M\n");
+	}
+	else if (log_size < 1000 * 1024 * 1024) {
+		efi_printk(sys_table_arg, "log_size < 1G\n");
+	}
+	else {
+		efi_printk(sys_table_arg, "log_size > 1G\n");
+	}
+
 	efi_printk(sys_table_arg, "Allocating memory for storing the logs\n");
 	/* Allocate space for the logs and copy them. */
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
@@ -124,6 +140,11 @@ void efi_retrieve_tpm2_eventlog_1_2(efi_system_table_t *sys_table_arg)
 			   "Unable to allocate memory for event log\n");
 		return;
 	}
+	if (!log_tbl) {
+		efi_printk(sys_table_arg, "Pointer returned from allocation is NULL!\n");
+		return;
+	}
+
 	efi_printk(sys_table_arg, "Copying log to new location\n");
 
 	memset(log_tbl, 0, sizeof(*log_tbl) + log_size);
-- 
2.16.2.395.g2e18187dfd-goog
