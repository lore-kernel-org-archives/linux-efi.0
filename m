From: Eugene Korenevsky <ekorenevsky@gmail.com>
Subject: [PATCH v2] efi: take size of partition entry from GPT header
Date: Tue, 11 Sep 2018 19:15:27 +0300
Message-ID: <20180911161527.GA30689@vnote>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Use gpt_header.sizeof_partition_entry instead of sizeof(gpt_entry)
for GPT entry size.
According to UEFI 2.7 spec 5.3.1 "GPT overview":, the size of a GUID Partition
Entry element is defined in the Size Of Partition Entry field of GPT header.
The GPT with entries sized more than sizeof(gpt_entry) is not illegal.
OVMF firmware from EDK2 perfectly works with it, see edk2-tianocore source
code.

Changes since v1: refactoring (extract get_gpt_entry function),
                    fix (&ptes[i] -> pte)

Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>
---
 block/partitions/efi.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 39f70d968754..724f7c0805a2 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -428,11 +428,6 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 			 (unsigned long long)le64_to_cpu((*gpt)->first_usable_lba));
 		goto fail;
 	}
-	/* Check that sizeof_partition_entry has the correct value */
-	if (le32_to_cpu((*gpt)->sizeof_partition_entry) != sizeof(gpt_entry)) {
-		pr_debug("GUID Partition Entry Size check failed.\n");
-		goto fail;
-	}
 
 	/* Sanity check partition table size */
 	pt_size = (u64)le32_to_cpu((*gpt)->num_partition_entries) *
@@ -670,6 +665,11 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
         return 0;
 }
 
+static gpt_entry *get_gpt_entry(gpt_header *gpt_hdr, gpt_entry *ptes, u32 index)
+{
+	return (gpt_entry *)((u8 *)ptes + gpt->sizeof_partition_entry * index);
+}
+
 /**
  * efi_partition(struct parsed_partitions *state)
  * @state: disk parsed partitions
@@ -704,32 +704,36 @@ int efi_partition(struct parsed_partitions *state)
 
 	pr_debug("GUID Partition Table is valid!  Yea!\n");
 
-	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1; i++) {
+	for (i = 0;
+	     i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1;
+	     i++) {
+		gpt_entry *pte = get_gpt_entry(gpt, ptes, i);
 		struct partition_meta_info *info;
 		unsigned label_count = 0;
 		unsigned label_max;
-		u64 start = le64_to_cpu(ptes[i].starting_lba);
-		u64 size = le64_to_cpu(ptes[i].ending_lba) -
-			   le64_to_cpu(ptes[i].starting_lba) + 1ULL;
+		u64 start = le64_to_cpu(pte->starting_lba);
+		u64 size = le64_to_cpu(pte->ending_lba) -
+			   le64_to_cpu(pte->starting_lba) + 1ULL;
 
-		if (!is_pte_valid(&ptes[i], last_lba(state->bdev)))
+		if (!is_pte_valid(pte, last_lba(state->bdev)))
 			continue;
 
 		put_partition(state, i+1, start * ssz, size * ssz);
 
 		/* If this is a RAID volume, tell md */
-		if (!efi_guidcmp(ptes[i].partition_type_guid, PARTITION_LINUX_RAID_GUID))
+		if (!efi_guidcmp(
+		    pte->partition_type_guid, PARTITION_LINUX_RAID_GUID))
 			state->parts[i + 1].flags = ADDPART_FLAG_RAID;
 
 		info = &state->parts[i + 1].info;
-		efi_guid_to_str(&ptes[i].unique_partition_guid, info->uuid);
+		efi_guid_to_str(&pte->unique_partition_guid, info->uuid);
 
 		/* Naively convert UTF16-LE to 7 bits. */
 		label_max = min(ARRAY_SIZE(info->volname) - 1,
-				ARRAY_SIZE(ptes[i].partition_name));
+				ARRAY_SIZE(pte->partition_name));
 		info->volname[label_max] = 0;
 		while (label_count < label_max) {
-			u8 c = ptes[i].partition_name[label_count] & 0xff;
+			u8 c = pte->partition_name[label_count] & 0xff;
 			if (c && !isprint(c))
 				c = '!';
 			info->volname[label_count] = c;
-- 
2.18.0
