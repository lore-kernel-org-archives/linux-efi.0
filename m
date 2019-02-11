From: bsz@semihalf.com
Subject: [PATCH 4/5] efi/libstub/tpm: Retrieve TPM event log in 2.0 format
Date: Mon, 11 Feb 2019 15:30:51 +0100
Message-ID: <20190211143052.3128-5-bsz@semihalf.com>
References: <20190211143052.3128-1-bsz@semihalf.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190211143052.3128-1-bsz@semihalf.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, peterhuewe@gmx.de, jarkko.sakkinen@linux.intel.com, ard.biesheuvel@linaro.org
Cc: tweek@google.com, mingo@kernel.org, hdegoede@redhat.com, leif.lindholm@linaro.org, mw@semihalf.com, Bartosz Szczepanek <bsz@semihalf.com>
List-Id: linux-efi@vger.kernel.org

From: Bartosz Szczepanek <bsz@semihalf.com>

Currently, the only way to get TPM 2.0 event log from firmware is to use
device tree. Introduce efi_retrieve_tpm2_eventlog_2 function to enable
retrieving it from EFI structures.

Include lib/tpm.c into EFI stub to calculate event sizes using helper
function.

Signed-off-by: Bartosz Szczepanek <bsz@semihalf.com>
---
 drivers/firmware/efi/libstub/Makefile |   3 +-
 drivers/firmware/efi/libstub/tpm.c    | 107 +++++++++++++++++++++++++++++++++-
 2 files changed, 107 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index d9845099635e..0d7d66ad916d 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -38,7 +38,8 @@ OBJECT_FILES_NON_STANDARD	:= y
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
 KCOV_INSTRUMENT			:= n
 
-lib-y				:= efi-stub-helper.o gop.o secureboot.o tpm.o
+lib-y				:= efi-stub-helper.o gop.o secureboot.o tpm.o \
+				   lib-tpm.o
 
 # include the stub's generic dependencies from lib/ when building for ARM/arm64
 arm-deps-y := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c
diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
index a90b0b8fc69a..c8c2531be413 100644
--- a/drivers/firmware/efi/libstub/tpm.c
+++ b/drivers/firmware/efi/libstub/tpm.c
@@ -129,8 +129,111 @@ static void efi_retrieve_tpm2_eventlog_1_2(efi_system_table_t *sys_table_arg)
 	efi_call_early(free_pool, log_tbl);
 }
 
+static efi_status_t
+efi_calc_tpm2_eventlog_2_size(efi_system_table_t *sys_table_arg,
+	void *log, void *last_entry, ssize_t *log_size)
+{
+	struct tcg_pcr_event2 *event = last_entry;
+	struct tcg_efi_specid_event *efispecid;
+	struct tcg_pcr_event *log_header = log;
+	ssize_t last_entry_size;
+
+	efispecid = (struct tcg_efi_specid_event *) log_header->event;
+
+	if (last_entry == NULL || log_size == NULL)
+		return EFI_INVALID_PARAMETER;
+
+	if (log == last_entry) {
+		/*
+		 * Only one entry (header) in the log.
+		 */
+		*log_size = log_header->event_size +
+			    sizeof(struct tcg_pcr_event);
+		return EFI_SUCCESS;
+	}
+
+	if (event->count > efispecid->num_algs) {
+		efi_printk(sys_table_arg,
+			   "TCG2 event uses more algorithms than defined\n");
+		return EFI_INVALID_PARAMETER;
+	}
+
+	last_entry_size = calc_tpm2_event_size(last_entry, efispecid);
+	if (last_entry_size < 0) {
+		efi_printk(sys_table_arg,
+			"TCG2 log has invalid last entry size\n");
+		return EFI_INVALID_PARAMETER;
+	}
+
+	*log_size = last_entry + last_entry_size - log;
+	return EFI_SUCCESS;
+}
+
+static efi_status_t efi_retrieve_tpm2_eventlog_2(efi_system_table_t *sys_table_arg)
+{
+	efi_guid_t linux_eventlog_guid = LINUX_EFI_TPM_EVENT_LOG_GUID;
+	efi_physical_addr_t log_location = 0, log_last_entry = 0;
+	efi_guid_t tcg2_guid = EFI_TCG2_PROTOCOL_GUID;
+	efi_bool_t truncated;
+	efi_status_t status;
+	struct linux_efi_tpm_eventlog *log_tbl = NULL;
+	void *tcg2_protocol = NULL;
+	ssize_t log_size;
+
+	status = efi_call_early(locate_protocol, &tcg2_guid, NULL,
+				&tcg2_protocol);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	status = efi_call_proto(efi_tcg2_protocol, get_event_log, tcg2_protocol,
+				EFI_TCG2_EVENT_LOG_FORMAT_TCG_2,
+				&log_location, &log_last_entry, &truncated);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	if (!log_location)
+		return EFI_NOT_FOUND;
+
+	status = efi_calc_tpm2_eventlog_2_size(sys_table_arg,
+					       (void *)log_location,
+					       (void *) log_last_entry,
+					       &log_size);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	/* Allocate space for the logs and copy them. */
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				sizeof(*log_tbl) + log_size,
+				(void **) &log_tbl);
+
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table_arg,
+			   "Unable to allocate memory for event log\n");
+		return status;
+	}
+
+	memset(log_tbl, 0, sizeof(*log_tbl) + log_size);
+	log_tbl->size = log_size;
+	log_tbl->version = EFI_TCG2_EVENT_LOG_FORMAT_TCG_2;
+	memcpy(log_tbl->log, (void *) log_location, log_size);
+
+	status = efi_call_early(install_configuration_table,
+				&linux_eventlog_guid, log_tbl);
+	if (status != EFI_SUCCESS)
+		goto err_free;
+
+	return EFI_SUCCESS;
+
+err_free:
+	efi_call_early(free_pool, log_tbl);
+	return status;
+}
+
 void efi_retrieve_tpm2_eventlog(efi_system_table_t *sys_table_arg)
 {
-	/* Only try to retrieve the logs in 1.2 format. */
-	efi_retrieve_tpm2_eventlog_1_2(sys_table_arg);
+	efi_status_t status;
+
+	status = efi_retrieve_tpm2_eventlog_2(sys_table_arg);
+	if (status != EFI_SUCCESS)
+		efi_retrieve_tpm2_eventlog_1_2(sys_table_arg);
 }
-- 
2.14.4
