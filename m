From: Thiebaud Weksteen <tweek@google.com>
Subject: Re: Regression from efi: call get_event_log before ExitBootServices
Date: Thu,  8 Mar 2018 11:03:19 +0100
Message-ID: <20180308100319.131536-1-tweek@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeremy Cline <jeremy@jcline.org>
Cc: Javier Martinez Canillas <javierm@redhat.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, hdegoede@redhat.com, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, Thiebaud Weksteen <tweek@google.com>
List-Id: linux-efi@vger.kernel.org

---
 drivers/firmware/efi/libstub/tpm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
index da661bf8cb96..773afcd6a37c 100644
--- a/drivers/firmware/efi/libstub/tpm.c
+++ b/drivers/firmware/efi/libstub/tpm.c
@@ -74,19 +74,23 @@ void efi_retrieve_tpm2_eventlog_1_2(efi_system_table_t *sys_table_arg)
 	efi_bool_t truncated;
 	void *tcg2_protocol;
 
+	efi_printk(sys_table_arg, "Locating the TCG2Protocol\n");
 	status = efi_call_early(locate_protocol, &tcg2_guid, NULL,
 				&tcg2_protocol);
 	if (status != EFI_SUCCESS)
 		return;
 
+	efi_printk(sys_table_arg, "Calling GetEventLog on TCG2Protocol\n");
 	status = efi_call_proto(efi_tcg2_protocol, get_event_log, tcg2_protocol,
 				EFI_TCG2_EVENT_LOG_FORMAT_TCG_1_2,
 				&log_location, &log_last_entry, &truncated);
 	if (status != EFI_SUCCESS)
 		return;
+	efi_printk(sys_table_arg, "Log returned\n");
 
 	if (!log_location)
 		return;
+	efi_printk(sys_table_arg, "log_location is not empty\n");
 	first_entry_addr = (unsigned long) log_location;
 
 	/*
@@ -94,7 +98,9 @@ void efi_retrieve_tpm2_eventlog_1_2(efi_system_table_t *sys_table_arg)
 	 */
 	if (!log_last_entry) {
 		log_size = 0;
+		efi_printk(sys_table_arg, "log_size = 0\n");
 	} else {
+		efi_printk(sys_table_arg, "log_size != 0\n");
 		last_entry_addr = (unsigned long) log_last_entry;
 		/*
 		 * get_event_log only returns the address of the last entry.
@@ -106,26 +112,31 @@ void efi_retrieve_tpm2_eventlog_1_2(efi_system_table_t *sys_table_arg)
 		log_size = log_last_entry - log_location + last_entry_size;
 	}
 
+	efi_printk(sys_table_arg, "Allocating memory for storing the logs\n");
 	/* Allocate space for the logs and copy them. */
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
 				sizeof(*log_tbl) + log_size,
 				(void **) &log_tbl);
 
+	efi_printk(sys_table_arg, "Returned from memory allocation\n");
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table_arg,
 			   "Unable to allocate memory for event log\n");
 		return;
 	}
+	efi_printk(sys_table_arg, "Copying log to new location\n");
 
 	memset(log_tbl, 0, sizeof(*log_tbl) + log_size);
 	log_tbl->size = log_size;
 	log_tbl->version = EFI_TCG2_EVENT_LOG_FORMAT_TCG_1_2;
 	memcpy(log_tbl->log, (void *) first_entry_addr, log_size);
 
+	efi_printk(sys_table_arg, "Installing the log into the configuration table\n");
 	status = efi_call_early(install_configuration_table,
 				&linux_eventlog_guid, log_tbl);
 	if (status != EFI_SUCCESS)
 		goto err_free;
+	efi_printk(sys_table_arg, "Done\n");
 	return;
 
 err_free:
-- 
2.16.2.395.g2e18187dfd-goog
