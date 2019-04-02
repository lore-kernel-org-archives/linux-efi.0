From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH 2/2] tpm: Fix builds on platforms that lack early_memremap()
Date: Tue,  2 Apr 2019 14:55:56 -0700
Message-ID: <20190402215556.257406-3-matthewgarrett@google.com>
References: <20190402215556.257406-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190402215556.257406-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: peterhuewe@gmx.de, jarkko.sakkinen@linux.intel.com, jgg@ziepe.ca, roberto.sassu@huawei.com, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tweek@google.com, Matthew Garrett <matthewgarrett@google.com>, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

On EFI systems, __calc_tpm2_event_size() needs to be able to map tables
at early boot time in order to extract information from them.
Unfortunately this interacts badly with other architectures that don't
provide the early_memremap() interface but which may still have other
mechanisms for obtaining crypto-agile logs. Abstract this away so we
can avoid the need for two implementations while still avoiding breakage
on architectures that don't require remapping of the table.

Signed-off-by: Matthew Garrett <mjg59@google.com>
---
 drivers/firmware/efi/tpm.c   |  3 +++
 include/linux/tpm_eventlog.h | 32 ++++++++++++++++++++------------
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index f2a13cbb8688..fe48150f06d1 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -4,6 +4,9 @@
  *     Thiebaud Weksteen <tweek@google.com>
  */
 
+#define TPM_MEMREMAP(start, size) early_memremap(start, size)
+#define TPM_MEMUNMAP(start, size) early_memunmap(start, size)
+
 #include <linux/efi.h>
 #include <linux/init.h>
 #include <linux/memblock.h>
diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
index d889e12047d9..0ca27bc053af 100644
--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -128,6 +128,14 @@ struct tcg_algorithm_info {
 	struct tcg_algorithm_size digest_sizes[];
 };
 
+#ifndef TPM_MEMREMAP
+#define TPM_MEMREMAP(start, size) NULL
+#endif
+
+#ifndef TPM_MEMUNMAP
+#define TPM_MEMUNMAP(start, size) do{} while(0)
+#endif
+
 /**
  * __calc_tpm2_event_size - calculate the size of a TPM2 event log entry
  * @event:        Pointer to the event whose size should be calculated
@@ -171,8 +179,8 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
 	/* Map the event header */
 	if (do_mapping) {
 		mapping_size = marker - marker_start;
-		mapping = early_memremap((unsigned long)marker_start,
-					 mapping_size);
+		mapping = TPM_MEMREMAP((unsigned long)marker_start,
+				       mapping_size);
 		if (!mapping) {
 			size = 0;
 			goto out;
@@ -192,10 +200,10 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
 
 		/* Map the digest's algorithm identifier */
 		if (do_mapping) {
-			early_memunmap(mapping, mapping_size);
+			TPM_MEMUNMAP(mapping, mapping_size);
 			mapping_size = marker - marker_start + halg_size;
-			mapping = early_memremap((unsigned long)marker_start,
-						 mapping_size);
+			mapping = TPM_MEMREMAP((unsigned long)marker_start,
+					       mapping_size);
 			if (!mapping) {
 				size = 0;
 				goto out;
@@ -212,10 +220,10 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
 
 				/* Map the digest content itself */
 				if (do_mapping) {
-					early_memunmap(mapping, mapping_size);
+					TPM_MEMUNMAP(mapping, mapping_size);
 					mapping_size = marker - marker_start;
-					mapping = early_memremap((unsigned long)marker_start,
-						      mapping_size);
+					mapping = TPM_MEMREMAP((unsigned long)marker_start,
+							       mapping_size);
 					if (!mapping) {
 						size = 0;
 						goto out;
@@ -238,10 +246,10 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
 	 * we don't need to map it
 	 */
 	if (do_mapping) {
-		early_memunmap(marker_start, mapping_size);
+		TPM_MEMUNMAP(marker_start, mapping_size);
 		mapping_size += sizeof(event_field->event_size);
-		mapping = early_memremap((unsigned long)marker_start,
-					 mapping_size);
+		mapping = TPM_MEMREMAP((unsigned long)marker_start,
+				       mapping_size);
 		if (!mapping) {
 			size = 0;
 			goto out;
@@ -256,7 +264,7 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
 		size = 0;
 out:
 	if (do_mapping)
-		early_memunmap(mapping, mapping_size);
+		TPM_MEMUNMAP(mapping, mapping_size);
 	return size;
 }
 
-- 
2.21.0.392.gf8f6787159e-goog
