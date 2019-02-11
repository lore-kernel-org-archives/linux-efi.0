From: bsz@semihalf.com
Subject: [PATCH 1/5] tpm: Copy calc_tpm2_event_size() to TPM library
Date: Mon, 11 Feb 2019 15:30:48 +0100
Message-ID: <20190211143052.3128-2-bsz@semihalf.com>
References: <20190211143052.3128-1-bsz@semihalf.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190211143052.3128-1-bsz@semihalf.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, peterhuewe@gmx.de, jarkko.sakkinen@linux.intel.com, ard.biesheuvel@linaro.org
Cc: tweek@google.com, mingo@kernel.org, hdegoede@redhat.com, leif.lindholm@linaro.org, mw@semihalf.com, Bartosz Szczepanek <bsz@semihalf.com>
List-Id: linux-efi@vger.kernel.org

From: Bartosz Szczepanek <bsz@semihalf.com>

Function to calculate event size in TPM 2.0 log will also be needed in EFI
stub. Separate it to library to make it accessible out of TPM character
driver.

It will be removed from tpm2.c in subsequent commit.

Signed-off-by: Bartosz Szczepanek <bsz@semihalf.com>
---
 lib/tpm.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 lib/tpm.c

diff --git a/lib/tpm.c b/lib/tpm.c
new file mode 100644
index 000000000000..aaeeafe52426
--- /dev/null
+++ b/lib/tpm.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2016 IBM Corporation
+ *
+ * Parts of this file based on earlier work by:
+ *      Nayna Jain <nayna@linux.vnet.ibm.com>
+ *      Petr Vandrovec <petr@vmware.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/types.h>
+#include <linux/export.h>
+#include <linux/string.h>
+#include <linux/tpm_eventlog.h>
+
+/*
+ * calc_tpm2_event_size() - calculate the event size, where event
+ * is an entry in the TPM 2.0 event log. The event is of type Crypto
+ * Agile Log Entry Format as defined in TCG EFI Protocol Specification
+ * Family "2.0".
+
+ * @event: event whose size is to be calculated.
+ * @event_header: the first event in the event log.
+ *
+ * Returns size of the event. If it is an invalid event, returns 0.
+ */
+int calc_tpm2_event_size(struct tcg_pcr_event2 *event,
+			 struct tcg_pcr_event *event_header)
+{
+	struct tcg_efi_specid_event *efispecid;
+	struct tcg_event_field *event_field;
+	void *marker;
+	void *marker_start;
+	u32 halg_size;
+	size_t size;
+	u16 halg;
+	int i;
+	int j;
+
+	marker = event;
+	marker_start = marker;
+	marker = marker + sizeof(event->pcr_idx) + sizeof(event->event_type)
+		+ sizeof(event->count);
+
+	efispecid = (struct tcg_efi_specid_event *)event_header->event;
+
+	/* Check if event is malformed. */
+	if (event->count > efispecid->num_algs)
+		return 0;
+
+	for (i = 0; i < event->count; i++) {
+		halg_size = sizeof(event->digests[i].alg_id);
+		memcpy(&halg, marker, halg_size);
+		marker = marker + halg_size;
+		for (j = 0; j < efispecid->num_algs; j++) {
+			if (halg == efispecid->digest_sizes[j].alg_id) {
+				marker +=
+					efispecid->digest_sizes[j].digest_size;
+				break;
+			}
+		}
+		/* Algorithm without known length. Such event is unparseable. */
+		if (j == efispecid->num_algs)
+			return 0;
+	}
+
+	event_field = (struct tcg_event_field *)marker;
+	marker = marker + sizeof(event_field->event_size)
+		+ event_field->event_size;
+	size = marker - marker_start;
+
+	if ((event->event_type == 0) && (event_field->event_size == 0))
+		return 0;
+
+	return size;
+}
+EXPORT_SYMBOL(calc_tpm2_event_size);
-- 
2.14.4
