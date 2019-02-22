From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V4 2/4] tpm: Reserve the TPM final events table
Date: Fri, 22 Feb 2019 12:26:04 -0800
Message-ID: <20190222202606.160816-3-matthewgarrett@google.com>
References: <20190222202606.160816-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222202606.160816-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: peterhuewe@gmx.de, jarkko.sakkinen@linux.intel.com, jgg@ziepe.ca, roberto.sassu@huawei.com, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tweek@google.com, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

From: Matthew Garrett <mjg59@google.com>

UEFI systems provide a boot services protocol for obtaining the TPM
event log, but this is unusable after ExitBootServices() is called.
Unfortunately ExitBootServices() itself triggers additional TPM events
that then can't be obtained using this protocol. The platform provides a
mechanism for the OS to obtain these events by recording them to a
separate UEFI configuration table which the OS can then map.

Unfortunately this table isn't self describing in terms of providing its
length, so we need to parse the events inside it to figure out how long
it is. Since the table isn't mapped at this point, we need to extend the
length calculation function to be able to map the event as it goes
along.

Signed-off-by: Matthew Garrett <mjg59@google.com>
---
 drivers/char/tpm/eventlog/tpm2.c |  2 +-
 drivers/firmware/efi/efi.c       |  2 +
 drivers/firmware/efi/tpm.c       | 51 ++++++++++++++++-
 include/linux/efi.h              |  9 +++
 include/linux/tpm_eventlog.h     | 94 +++++++++++++++++++++++++++++---
 5 files changed, 148 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/eventlog/tpm2.c b/drivers/char/tpm/eventlog/tpm2.c
index dc12e1cbd03a..2cfdf1db4363 100644
--- a/drivers/char/tpm/eventlog/tpm2.c
+++ b/drivers/char/tpm/eventlog/tpm2.c
@@ -40,7 +40,7 @@
 static int calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
 				struct tcg_pcr_event *event_header)
 {
-	return __calc_tpm2_event_size(event, event_header);
+	return __calc_tpm2_event_size(event, event_header, false);
 }
 
 static void *tpm2_bios_measurements_start(struct seq_file *m, loff_t *pos)
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 55b77c576c42..6b11c41e0575 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -53,6 +53,7 @@ struct efi __read_mostly efi = {
 	.mem_attr_table		= EFI_INVALID_TABLE_ADDR,
 	.rng_seed		= EFI_INVALID_TABLE_ADDR,
 	.tpm_log		= EFI_INVALID_TABLE_ADDR,
+	.tpm_final_log		= EFI_INVALID_TABLE_ADDR,
 	.mem_reserve		= EFI_INVALID_TABLE_ADDR,
 };
 EXPORT_SYMBOL(efi);
@@ -485,6 +486,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
 	{EFI_MEMORY_ATTRIBUTES_TABLE_GUID, "MEMATTR", &efi.mem_attr_table},
 	{LINUX_EFI_RANDOM_SEED_TABLE_GUID, "RNG", &efi.rng_seed},
 	{LINUX_EFI_TPM_EVENT_LOG_GUID, "TPMEventLog", &efi.tpm_log},
+	{LINUX_EFI_TPM_FINAL_LOG_GUID, "TPMFinalLog", &efi.tpm_final_log},
 	{LINUX_EFI_MEMRESERVE_TABLE_GUID, "MEMRESERVE", &efi.mem_reserve},
 	{NULL_GUID, NULL, NULL},
 };
diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index 0cbeb3d46b18..2ccaa6661aaf 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -10,24 +10,50 @@
 #include <linux/efi.h>
 #include <linux/init.h>
 #include <linux/memblock.h>
+#include <linux/tpm_eventlog.h>
 
 #include <asm/early_ioremap.h>
 
+int efi_tpm_final_log_size;
+EXPORT_SYMBOL(efi_tpm_final_log_size);
+
+static int tpm2_calc_event_log_size(void *data, int count, void *size_info)
+{
+	struct tcg_pcr_event2_head *header;
+	int event_size, size = 0;
+
+	while (count > 0) {
+		header = data + size;
+		event_size = __calc_tpm2_event_size(header, size_info, true);
+		if (event_size == 0)
+			return -1;
+		size += event_size;
+	}
+
+	return size;
+}
+
 /*
  * Reserve the memory associated with the TPM Event Log configuration table.
  */
 int __init efi_tpm_eventlog_init(void)
 {
 	struct linux_efi_tpm_eventlog *log_tbl;
+	struct efi_tcg2_final_events_table *final_tbl;
 	unsigned int tbl_size;
 
-	if (efi.tpm_log == EFI_INVALID_TABLE_ADDR)
+	if (efi.tpm_log == EFI_INVALID_TABLE_ADDR) {
+		/*
+		 * We can't calculate the size of the final events without the
+		 * first entry in the TPM log, so bail here.
+		 */
 		return 0;
+	}
 
 	log_tbl = early_memremap(efi.tpm_log, sizeof(*log_tbl));
 	if (!log_tbl) {
 		pr_err("Failed to map TPM Event Log table @ 0x%lx\n",
-			efi.tpm_log);
+		       efi.tpm_log);
 		efi.tpm_log = EFI_INVALID_TABLE_ADDR;
 		return -ENOMEM;
 	}
@@ -35,6 +61,27 @@ int __init efi_tpm_eventlog_init(void)
 	tbl_size = sizeof(*log_tbl) + log_tbl->size;
 	memblock_reserve(efi.tpm_log, tbl_size);
 	early_memunmap(log_tbl, sizeof(*log_tbl));
+
+	if (efi.tpm_final_log == EFI_INVALID_TABLE_ADDR)
+		return 0;
+
+	final_tbl = early_memremap(efi.tpm_final_log, sizeof(*final_tbl));
+
+	if (!final_tbl) {
+		pr_err("Failed to map TPM Final Event Log table @ 0x%lx\n",
+		       efi.tpm_final_log);
+		efi.tpm_final_log = EFI_INVALID_TABLE_ADDR;
+		return -ENOMEM;
+	}
+
+	tbl_size = tpm2_calc_event_log_size(final_tbl->events,
+					    final_tbl->nr_events,
+					    (void *)efi.tpm_log);
+	memblock_reserve((unsigned long)final_tbl,
+			 tbl_size + sizeof(*final_tbl));
+	early_memunmap(final_tbl, sizeof(*final_tbl));
+	efi_tpm_final_log_size = tbl_size;
+
 	return 0;
 }
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 28604a8d0aa9..ee8d820a4943 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -676,6 +676,7 @@ void efi_native_runtime_setup(void);
 #define LINUX_EFI_LOADER_ENTRY_GUID		EFI_GUID(0x4a67b082, 0x0a4c, 0x41cf,  0xb6, 0xc7, 0x44, 0x0b, 0x29, 0xbb, 0x8c, 0x4f)
 #define LINUX_EFI_RANDOM_SEED_TABLE_GUID	EFI_GUID(0x1ce1e5bc, 0x7ceb, 0x42f2,  0x81, 0xe5, 0x8a, 0xad, 0xf1, 0x80, 0xf5, 0x7b)
 #define LINUX_EFI_TPM_EVENT_LOG_GUID		EFI_GUID(0xb7799cb0, 0xeca2, 0x4943,  0x96, 0x67, 0x1f, 0xae, 0x07, 0xb7, 0x47, 0xfa)
+#define LINUX_EFI_TPM_FINAL_LOG_GUID		EFI_GUID(0x1e2ed096, 0x30e2, 0x4254,  0xbd, 0x89, 0x86, 0x3b, 0xbe, 0xf8, 0x23, 0x25)
 #define LINUX_EFI_MEMRESERVE_TABLE_GUID		EFI_GUID(0x888eb0c6, 0x8ede, 0x4ff5,  0xa8, 0xf0, 0x9a, 0xee, 0x5c, 0xb9, 0x77, 0xc2)
 
 typedef struct {
@@ -983,6 +984,7 @@ extern struct efi {
 	unsigned long mem_attr_table;	/* memory attributes table */
 	unsigned long rng_seed;		/* UEFI firmware random seed */
 	unsigned long tpm_log;		/* TPM2 Event Log table */
+	unsigned long tpm_final_log;	/* TPM2 Final Events Log table */
 	unsigned long mem_reserve;	/* Linux EFI memreserve table */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
@@ -1693,6 +1695,13 @@ struct linux_efi_tpm_eventlog {
 
 extern int efi_tpm_eventlog_init(void);
 
+struct efi_tcg2_final_events_table {
+	u64 version;
+	u64 nr_events;
+	u8 events[];
+};
+extern int efi_tpm_final_log_size;
+
 /*
  * efi_runtime_service() function identifiers.
  * "NONE" is used by efi_recover_from_page_fault() to check if the page
diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
index 09c19d506b69..dccc97e6135c 100644
--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -117,10 +117,27 @@ struct tcg_pcr_event2_head {
 	struct tpm2_digest digests[];
 } __packed;
 
+struct tcg_algorithm_size {
+	u16 algorithm_id;
+	u16 algorithm_size;
+};
+
+struct tcg_algorithm_info {
+	u8 signature[16];
+	u32 platform_class;
+	u8 spec_version_minor;
+	u8 spec_version_major;
+	u8 spec_errata;
+	u8 uintn_size;
+	u32 number_of_algorithms;
+	struct tcg_algorithm_size digest_sizes[];
+};
+
 /**
  * __calc_tpm2_event_size - calculate the size of a TPM2 event log entry
  * @event:        Pointer to the event whose size should be calculated
  * @event_header: Pointer to the initial event containing the digest lengths
+ * @do_mapping:   Whether or not the event needs to be mapped
  *
  * The TPM2 event log format can contain multiple digests corresponding to
  * separate PCR banks, and also contains a variable length of the data that
@@ -136,10 +153,13 @@ struct tcg_pcr_event2_head {
  */
 
 static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
-					 struct tcg_pcr_event *event_header)
+					 struct tcg_pcr_event *event_header,
+					 bool do_mapping)
 {
 	struct tcg_efi_specid_event_head *efispecid;
 	struct tcg_event_field *event_field;
+	void *mapping = NULL;
+	int mapping_size;
 	void *marker;
 	void *marker_start;
 	u32 halg_size;
@@ -153,36 +173,96 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
 	marker = marker + sizeof(event->pcr_idx) + sizeof(event->event_type)
 		+ sizeof(event->count);
 
+	/* Map the event header */
+	if (do_mapping) {
+		mapping_size = marker - marker_start;
+		mapping = early_memremap((unsigned long)marker_start,
+					 mapping_size);
+		if (!mapping) {
+			size = 0;
+			goto out;
+		}
+	}
+
 	efispecid = (struct tcg_efi_specid_event_head *)event_header->event;
 
 	/* Check if event is malformed. */
-	if (event->count > efispecid->num_algs)
-		return 0;
+	if (event->count > efispecid->num_algs) {
+		size = 0;
+		goto out;
+	}
 
 	for (i = 0; i < event->count; i++) {
 		halg_size = sizeof(event->digests[i].alg_id);
+
+		/* Map the digest's algorithm identifier */
+		if (do_mapping) {
+			early_memunmap(mapping, mapping_size);
+			mapping_size = marker - marker_start + halg_size;
+			mapping = early_memremap((unsigned long)marker_start,
+						 mapping_size);
+			if (!mapping) {
+				size = 0;
+				goto out;
+			}
+		}
+
 		memcpy(&halg, marker, halg_size);
 		marker = marker + halg_size;
+
 		for (j = 0; j < efispecid->num_algs; j++) {
 			if (halg == efispecid->digest_sizes[j].alg_id) {
 				marker +=
 					efispecid->digest_sizes[j].digest_size;
+
+				/* Map the digest content itself */
+				if (do_mapping) {
+					early_memunmap(mapping, mapping_size);
+					mapping_size = marker - marker_start;
+					mapping = early_memremap((unsigned long)marker_start,
+						      mapping_size);
+					if (!mapping) {
+						size = 0;
+						goto out;
+					}
+				}
 				break;
 			}
 		}
 		/* Algorithm without known length. Such event is unparseable. */
-		if (j == efispecid->num_algs)
-			return 0;
+		if (j == efispecid->num_algs) {
+			size = 0;
+			goto out;
+		}
 	}
 
 	event_field = (struct tcg_event_field *)marker;
+
+	/*
+	 * Map the event size - we don't read from the event itself, so
+	 * we don't need to map it
+	 */
+	if (do_mapping) {
+		early_memunmap(marker_start, mapping_size);
+		mapping_size += sizeof(event_field->event_size);
+		mapping = early_memremap((unsigned long)marker_start,
+					 mapping_size);
+		if (!mapping) {
+			size = 0;
+			goto out;
+		}
+	}
+
 	marker = marker + sizeof(event_field->event_size)
 		+ event_field->event_size;
 	size = marker - marker_start;
 
 	if ((event->event_type == 0) && (event_field->event_size == 0))
-		return 0;
-
+		size = 0;
+out:
+	if (do_mapping)
+		early_memunmap(mapping, mapping_size);
 	return size;
 }
+
 #endif
-- 
2.21.0.rc0.258.g878e2cd30e-goog
