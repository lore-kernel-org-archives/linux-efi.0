From: Eugene Korenevsky <ekorenevsky@gmail.com>
Subject: [PATCH v5 1/2] efi: add sanity checks for GPT entries
Date: Sun, 4 Nov 2018 22:50:55 +0300
Message-ID: <20181104195055.GA15428@dnote>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Obvious sanity checks have been added for GPT entries.
GPT entries should not:
- collide with GPT header
- collide with GPT partitions
- override the disk size 
These checks also ensure GPT entries are not too large.

Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>
---
 block/partitions/efi.c | 61 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 51 insertions(+), 10 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 39f70d968754..722117b32585 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -338,6 +338,24 @@ static gpt_header *alloc_read_gpt_header(struct parsed_partitions *state,
 	return gpt;
 }
 
+/**
+ * disk_regions_collide() - tests if two disk regions intersect or one region
+ *			    contains other
+ * @firstlba1: first LBA of the first region
+ * @lastlba1: last LBA of the first region
+ * @firstlba2: first LBA of the second region
+ * @lastlba2: last LBA of the second region
+ */
+static bool disk_regions_collide(u64 firstlba1, u64 lastlba1,
+				 u64 firstlba2, u64 lastlba2)
+{
+	if (lastlba1 < firstlba2)
+		return false;
+	if (lastlba2 < firstlba1)
+		return false;
+	return true;
+}
+
 /**
  * is_gpt_valid() - tests one GPT header and PTEs for validity
  * @state: disk parsed partitions
@@ -352,7 +370,8 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 			gpt_header **gpt, gpt_entry **ptes)
 {
 	u32 crc, origcrc;
-	u64 lastlba, pt_size;
+	unsigned short ssz;
+	u64 pt_firstlba, pt_lastlba, disk_lastlba, pt_size;
 
 	if (!ptes)
 		return 0;
@@ -369,11 +388,10 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 	}
 
 	/* Check the GUID Partition Table header size is too big */
-	if (le32_to_cpu((*gpt)->header_size) >
-			bdev_logical_block_size(state->bdev)) {
+	ssz = bdev_logical_block_size(state->bdev);
+	if (le32_to_cpu((*gpt)->header_size) > ssz) {
 		pr_debug("GUID Partition Table Header size is too large: %u > %u\n",
-			le32_to_cpu((*gpt)->header_size),
-			bdev_logical_block_size(state->bdev));
+			le32_to_cpu((*gpt)->header_size), ssz);
 		goto fail;
 	}
 
@@ -409,17 +427,17 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 	/* Check the first_usable_lba and last_usable_lba are
 	 * within the disk.
 	 */
-	lastlba = last_lba(state->bdev);
-	if (le64_to_cpu((*gpt)->first_usable_lba) > lastlba) {
+	disk_lastlba = last_lba(state->bdev);
+	if (le64_to_cpu((*gpt)->first_usable_lba) > disk_lastlba) {
 		pr_debug("GPT: first_usable_lba incorrect: %lld > %lld\n",
 			 (unsigned long long)le64_to_cpu((*gpt)->first_usable_lba),
-			 (unsigned long long)lastlba);
+			 (unsigned long long)disk_lastlba);
 		goto fail;
 	}
-	if (le64_to_cpu((*gpt)->last_usable_lba) > lastlba) {
+	if (le64_to_cpu((*gpt)->last_usable_lba) > disk_lastlba) {
 		pr_debug("GPT: last_usable_lba incorrect: %lld > %lld\n",
 			 (unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
-			 (unsigned long long)lastlba);
+			 (unsigned long long)disk_lastlba);
 		goto fail;
 	}
 	if (le64_to_cpu((*gpt)->last_usable_lba) < le64_to_cpu((*gpt)->first_usable_lba)) {
@@ -443,6 +461,29 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 		goto fail;
 	}
 
+	pt_firstlba = le64_to_cpu((*gpt)->partition_entry_lba);
+	pt_lastlba = pt_firstlba + (pt_size + ssz - 1) / ssz - 1;
+
+	/* Check GPT entries do not overwrite partitions */
+	if (disk_regions_collide(pt_firstlba, pt_lastlba,
+				 le64_to_cpu((*gpt)->first_usable_lba),
+				 le64_to_cpu((*gpt)->last_usable_lba))) {
+		pr_debug("Primary GPT entries overwrite partitions\n");
+		goto fail;
+	}
+	/* Check GPT entries do not overwrite GPT header. Note: GPT header must
+	 * reside in the single disk sector according to UEFI spec
+	 */
+	if (disk_regions_collide(pt_firstlba, pt_lastlba, lba, lba)) {
+		pr_debug("Primary GPT entries overwrite GPT header\n");
+		goto fail;
+	}
+	/* Check GPT entries are not beyond the end of the disk */
+	if (pt_lastlba > disk_lastlba) {
+		pr_debug("GPT entries are beyond the end of the disk\n");
+		goto fail;
+	}
+
 	if (!(*ptes = alloc_read_gpt_entries(state, *gpt)))
 		goto fail;
 
-- 
2.19.1
