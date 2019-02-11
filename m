From: bsz@semihalf.com
Subject: [PATCH 3/5] tpm: Use library version of calc_tpm2_event_size in sysfs code
Date: Mon, 11 Feb 2019 15:30:50 +0100
Message-ID: <20190211143052.3128-4-bsz@semihalf.com>
References: <20190211143052.3128-1-bsz@semihalf.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190211143052.3128-1-bsz@semihalf.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, peterhuewe@gmx.de, jarkko.sakkinen@linux.intel.com, ard.biesheuvel@linaro.org
Cc: tweek@google.com, mingo@kernel.org, hdegoede@redhat.com, leif.lindholm@linaro.org, mw@semihalf.com, Bartosz Szczepanek <bsz@semihalf.com>
List-Id: linux-efi@vger.kernel.org

From: Bartosz Szczepanek <bsz@semihalf.com>

Expect negative values from calc_tpm2_event_size as error codes.
Pass efispecid instead of event header to calc_tpm2_event_size.

Also, include tpm library in the build.

Signed-off-by: Bartosz Szczepanek <bsz@semihalf.com>
---
 drivers/char/tpm/eventlog/tpm2.c | 89 ++++++++--------------------------------
 include/linux/tpm_eventlog.h     |  3 ++
 lib/Makefile                     |  2 +
 3 files changed, 22 insertions(+), 72 deletions(-)

diff --git a/drivers/char/tpm/eventlog/tpm2.c b/drivers/char/tpm/eventlog/tpm2.c
index 1b8fa9de2cac..5230821d5b1c 100644
--- a/drivers/char/tpm/eventlog/tpm2.c
+++ b/drivers/char/tpm/eventlog/tpm2.c
@@ -26,80 +26,20 @@
 #include "../tpm.h"
 #include "common.h"
 
-/*
- * calc_tpm2_event_size() - calculate the event size, where event
- * is an entry in the TPM 2.0 event log. The event is of type Crypto
- * Agile Log Entry Format as defined in TCG EFI Protocol Specification
- * Family "2.0".
-
- * @event: event whose size is to be calculated.
- * @event_header: the first event in the event log.
- *
- * Returns size of the event. If it is an invalid event, returns 0.
- */
-static int calc_tpm2_event_size(struct tcg_pcr_event2 *event,
-				struct tcg_pcr_event *event_header)
-{
-	struct tcg_efi_specid_event *efispecid;
-	struct tcg_event_field *event_field;
-	void *marker;
-	void *marker_start;
-	u32 halg_size;
-	size_t size;
-	u16 halg;
-	int i;
-	int j;
-
-	marker = event;
-	marker_start = marker;
-	marker = marker + sizeof(event->pcr_idx) + sizeof(event->event_type)
-		+ sizeof(event->count);
-
-	efispecid = (struct tcg_efi_specid_event *)event_header->event;
-
-	/* Check if event is malformed. */
-	if (event->count > efispecid->num_algs)
-		return 0;
-
-	for (i = 0; i < event->count; i++) {
-		halg_size = sizeof(event->digests[i].alg_id);
-		memcpy(&halg, marker, halg_size);
-		marker = marker + halg_size;
-		for (j = 0; j < efispecid->num_algs; j++) {
-			if (halg == efispecid->digest_sizes[j].alg_id) {
-				marker +=
-					efispecid->digest_sizes[j].digest_size;
-				break;
-			}
-		}
-		/* Algorithm without known length. Such event is unparseable. */
-		if (j == efispecid->num_algs)
-			return 0;
-	}
-
-	event_field = (struct tcg_event_field *)marker;
-	marker = marker + sizeof(event_field->event_size)
-		+ event_field->event_size;
-	size = marker - marker_start;
-
-	if ((event->event_type == 0) && (event_field->event_size == 0))
-		return 0;
-
-	return size;
-}
-
 static void *tpm2_bios_measurements_start(struct seq_file *m, loff_t *pos)
 {
 	struct tpm_chip *chip = m->private;
 	struct tpm_bios_log *log = &chip->log;
 	void *addr = log->bios_event_log;
 	void *limit = log->bios_event_log_end;
+	struct tcg_efi_specid_event *efispecid;
 	struct tcg_pcr_event *event_header;
 	struct tcg_pcr_event2 *event;
-	size_t size;
+	ssize_t size;
 	int i;
 
 	event_header = addr;
+	efispecid = (struct tcg_efi_specid_event *) event_header->event;
 	size = sizeof(struct tcg_pcr_event) - sizeof(event_header->event)
 		+ event_header->event_size;
 
@@ -115,16 +55,16 @@ static void *tpm2_bios_measurements_start(struct seq_file *m, loff_t *pos)
 	if (*pos > 0) {
 		addr += size;
 		event = addr;
-		size = calc_tpm2_event_size(event, event_header);
-		if ((addr + size >=  limit) || (size == 0))
+		size = calc_tpm2_event_size(event, efispecid);
+		if ((addr + size >=  limit) || (size < 0))
 			return NULL;
 	}
 
 	for (i = 0; i < (*pos - 1); i++) {
 		event = addr;
-		size = calc_tpm2_event_size(event, event_header);
+		size = calc_tpm2_event_size(event, efispecid);
 
-		if ((addr + size >= limit) || (size == 0))
+		if ((addr + size >= limit) || (size < 0))
 			return NULL;
 		addr += size;
 	}
@@ -135,6 +75,7 @@ static void *tpm2_bios_measurements_start(struct seq_file *m, loff_t *pos)
 static void *tpm2_bios_measurements_next(struct seq_file *m, void *v,
 					 loff_t *pos)
 {
+	struct tcg_efi_specid_event *efispecid;
 	struct tcg_pcr_event *event_header;
 	struct tcg_pcr_event2 *event;
 	struct tpm_chip *chip = m->private;
@@ -144,6 +85,7 @@ static void *tpm2_bios_measurements_next(struct seq_file *m, void *v,
 	void *marker;
 
 	event_header = log->bios_event_log;
+	efispecid = (struct tcg_efi_specid_event *) event_header->event;
 
 	if (v == SEQ_START_TOKEN) {
 		event_size = sizeof(struct tcg_pcr_event) -
@@ -151,8 +93,8 @@ static void *tpm2_bios_measurements_next(struct seq_file *m, void *v,
 		marker = event_header;
 	} else {
 		event = v;
-		event_size = calc_tpm2_event_size(event, event_header);
-		if (event_size == 0)
+		event_size = calc_tpm2_event_size(event, efispecid);
+		if (event_size < 0)
 			return NULL;
 		marker = event;
 	}
@@ -163,8 +105,8 @@ static void *tpm2_bios_measurements_next(struct seq_file *m, void *v,
 	v = marker;
 	event = v;
 
-	event_size = calc_tpm2_event_size(event, event_header);
-	if (((v + event_size) >= limit) || (event_size == 0))
+	event_size = calc_tpm2_event_size(event, efispecid);
+	if (((v + event_size) >= limit) || (event_size < 0))
 		return NULL;
 
 	(*pos)++;
@@ -180,10 +122,13 @@ static int tpm2_binary_bios_measurements_show(struct seq_file *m, void *v)
 	struct tpm_chip *chip = m->private;
 	struct tpm_bios_log *log = &chip->log;
 	struct tcg_pcr_event *event_header = log->bios_event_log;
+	struct tcg_efi_specid_event *efispecid;
 	struct tcg_pcr_event2 *event = v;
 	void *temp_ptr;
 	size_t size;
 
+	efispecid = (struct tcg_efi_specid_event *) event_header->event;
+
 	if (v == SEQ_START_TOKEN) {
 		size = sizeof(struct tcg_pcr_event) -
 			sizeof(event_header->event) + event_header->event_size;
@@ -193,7 +138,7 @@ static int tpm2_binary_bios_measurements_show(struct seq_file *m, void *v)
 		if (size > 0)
 			seq_write(m, temp_ptr, size);
 	} else {
-		size = calc_tpm2_event_size(event, event_header);
+		size = calc_tpm2_event_size(event, efispecid);
 		temp_ptr = event;
 		if (size > 0)
 			seq_write(m, temp_ptr, size);
diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
index 20d9da77fc11..872ab1545456 100644
--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -121,4 +121,7 @@ struct tcg_pcr_event2 {
 	struct tcg_event_field event;
 } __packed;
 
+ssize_t calc_tpm2_event_size(struct tcg_pcr_event2 *event,
+			     struct tcg_efi_specid_event *efispecid);
+
 #endif
diff --git a/lib/Makefile b/lib/Makefile
index e1b59da71418..4458d914f40b 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -276,3 +276,5 @@ obj-$(CONFIG_GENERIC_LIB_MULDI3) += muldi3.o
 obj-$(CONFIG_GENERIC_LIB_CMPDI2) += cmpdi2.o
 obj-$(CONFIG_GENERIC_LIB_UCMPDI2) += ucmpdi2.o
 obj-$(CONFIG_OBJAGG) += objagg.o
+
+obj-$(CONFIG_TCG_TPM) += tpm.o
-- 
2.14.4
