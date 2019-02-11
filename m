From: bsz@semihalf.com
Subject: [PATCH 2/5] tpm: Change calc_tpm2_event_size signature
Date: Mon, 11 Feb 2019 15:30:49 +0100
Message-ID: <20190211143052.3128-3-bsz@semihalf.com>
References: <20190211143052.3128-1-bsz@semihalf.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190211143052.3128-1-bsz@semihalf.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, peterhuewe@gmx.de, jarkko.sakkinen@linux.intel.com, ard.biesheuvel@linaro.org
Cc: tweek@google.com, mingo@kernel.org, hdegoede@redhat.com, leif.lindholm@linaro.org, mw@semihalf.com, Bartosz Szczepanek <bsz@semihalf.com>
List-Id: linux-efi@vger.kernel.org

From: Bartosz Szczepanek <bsz@semihalf.com>

Pass tcg_efi_specid_event as an argument instead of tcg_pcr_event, as the
former is what is actually needed to compute event size. tcg_pcr_event
structure describes TPM event log header (even though its name), from where
efispecid can be extracted -- it seems cleaner and less misleading to do it
out of calc_tpm2_event_size function.

Also, use ssize_t instead of int for event log size.

Signed-off-by: Bartosz Szczepanek <bsz@semihalf.com>
---
 lib/tpm.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/lib/tpm.c b/lib/tpm.c
index aaeeafe52426..263ccfdaefa5 100644
--- a/lib/tpm.c
+++ b/lib/tpm.c
@@ -15,6 +15,7 @@
 #include <linux/export.h>
 #include <linux/string.h>
 #include <linux/tpm_eventlog.h>
+#include <linux/errno.h>
 
 /*
  * calc_tpm2_event_size() - calculate the event size, where event
@@ -23,19 +24,18 @@
  * Family "2.0".
 
  * @event: event whose size is to be calculated.
- * @event_header: the first event in the event log.
+ * @efispecid: pointer to structure describing algorithms used.
  *
- * Returns size of the event. If it is an invalid event, returns 0.
+ * Returns size of the event. If it is an invalid event, returns -EINVAL.
  */
-int calc_tpm2_event_size(struct tcg_pcr_event2 *event,
-			 struct tcg_pcr_event *event_header)
+ssize_t calc_tpm2_event_size(struct tcg_pcr_event2 *event,
+			     struct tcg_efi_specid_event *efispecid)
 {
-	struct tcg_efi_specid_event *efispecid;
 	struct tcg_event_field *event_field;
 	void *marker;
 	void *marker_start;
 	u32 halg_size;
-	size_t size;
+	ssize_t size;
 	u16 halg;
 	int i;
 	int j;
@@ -45,11 +45,9 @@ int calc_tpm2_event_size(struct tcg_pcr_event2 *event,
 	marker = marker + sizeof(event->pcr_idx) + sizeof(event->event_type)
 		+ sizeof(event->count);
 
-	efispecid = (struct tcg_efi_specid_event *)event_header->event;
-
 	/* Check if event is malformed. */
 	if (event->count > efispecid->num_algs)
-		return 0;
+		return -EINVAL;
 
 	for (i = 0; i < event->count; i++) {
 		halg_size = sizeof(event->digests[i].alg_id);
@@ -64,7 +62,7 @@ int calc_tpm2_event_size(struct tcg_pcr_event2 *event,
 		}
 		/* Algorithm without known length. Such event is unparseable. */
 		if (j == efispecid->num_algs)
-			return 0;
+			return -EINVAL;
 	}
 
 	event_field = (struct tcg_event_field *)marker;
@@ -73,7 +71,7 @@ int calc_tpm2_event_size(struct tcg_pcr_event2 *event,
 	size = marker - marker_start;
 
 	if ((event->event_type == 0) && (event_field->event_size == 0))
-		return 0;
+		return -EINVAL;
 
 	return size;
 }
-- 
2.14.4
