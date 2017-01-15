From: Alden Tondettar <alden.tondettar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] partitions/efi: Fix integer overflow in GPT size calculation
Date: Sun, 15 Jan 2017 15:31:56 -0700
Message-ID: <1484519516-18295-1-git-send-email-alden.tondettar@gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alden Tondettar <alden.tondettar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

If a GUID Partition Table claims to have more than 2**25 entries, the
calculation of the partition table size in alloc_read_gpt_entries() will
overflow a 32-bit integer and not enough space will be allocated for the
table.

Nothing seems to get written out of bounds, but later efi_partition() will
read up to 32768 bytes from a 128 byte buffer, possibly OOPSing or exposing
information to /proc/partitions and uevents.

The problem exists on both 64-bit and 32-bit platforms.

Fix the overflow and also print a meaningful debug message if the table
size is too large.

Signed-off-by: Alden Tondettar <alden.tondettar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 block/partitions/efi.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index bcd86e5..39f70d9 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -293,7 +293,7 @@ static gpt_entry *alloc_read_gpt_entries(struct parsed_partitions *state,
 	if (!gpt)
 		return NULL;
 
-	count = le32_to_cpu(gpt->num_partition_entries) *
+	count = (size_t)le32_to_cpu(gpt->num_partition_entries) *
                 le32_to_cpu(gpt->sizeof_partition_entry);
 	if (!count)
 		return NULL;
@@ -352,7 +352,7 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 			gpt_header **gpt, gpt_entry **ptes)
 {
 	u32 crc, origcrc;
-	u64 lastlba;
+	u64 lastlba, pt_size;
 
 	if (!ptes)
 		return 0;
@@ -434,13 +434,20 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 		goto fail;
 	}
 
+	/* Sanity check partition table size */
+	pt_size = (u64)le32_to_cpu((*gpt)->num_partition_entries) *
+		le32_to_cpu((*gpt)->sizeof_partition_entry);
+	if (pt_size > KMALLOC_MAX_SIZE) {
+		pr_debug("GUID Partition Table is too large: %llu > %lu bytes\n",
+			 (unsigned long long)pt_size, KMALLOC_MAX_SIZE);
+		goto fail;
+	}
+
 	if (!(*ptes = alloc_read_gpt_entries(state, *gpt)))
 		goto fail;
 
 	/* Check the GUID Partition Entry Array CRC */
-	crc = efi_crc32((const unsigned char *) (*ptes),
-			le32_to_cpu((*gpt)->num_partition_entries) *
-			le32_to_cpu((*gpt)->sizeof_partition_entry));
+	crc = efi_crc32((const unsigned char *) (*ptes), pt_size);
 
 	if (crc != le32_to_cpu((*gpt)->partition_entry_array_crc32)) {
 		pr_debug("GUID Partition Entry Array CRC check failed.\n");
-- 
2.1.4
