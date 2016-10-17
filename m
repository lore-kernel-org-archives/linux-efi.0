From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] partitions/efi: Ignore errors when alternate GPT is not at the end of disk
Date: Mon, 17 Oct 2016 12:20:30 +0200
Message-ID: <1476699630-127009-1-git-send-email-hare@suse.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dbueso-IBi9RG/b67k@public.gmane.org>
Cc: Jens-l3A5Bk7waGM@public.gmane.org, "Axboe <axboe"@kernel.dk, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The GPT specification requires that the alternate GPT is at the
end of the disk. However, if a Software RAID1 is enabled the RAID
metadata typically placed at the end of the disk, and the actual
size of the disk is decreased by the size of the metadata.
Plus it's perfectly legit to have a partition table which is
_smaller_ than the device; eg we don't check for the device
size in the msdos partition, neither.
So don't print out a warning here.

Signed-off-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
---
 block/partitions/efi.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index bcd86e5..011faa7 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -550,21 +550,6 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 		       le32_to_cpu(agpt->partition_entry_array_crc32));
 		error_found++;
 	}
-	if (le64_to_cpu(pgpt->alternate_lba) != lastlba) {
-		pr_warn("GPT:Primary header thinks Alt. header is not at the end of the disk.\n");
-		pr_warn("GPT:%lld != %lld\n",
-			(unsigned long long)le64_to_cpu(pgpt->alternate_lba),
-			(unsigned long long)lastlba);
-		error_found++;
-	}
-
-	if (le64_to_cpu(agpt->my_lba) != lastlba) {
-		pr_warn("GPT:Alternate GPT header not at the end of the disk.\n");
-		pr_warn("GPT:%lld != %lld\n",
-			(unsigned long long)le64_to_cpu(agpt->my_lba),
-			(unsigned long long)lastlba);
-		error_found++;
-	}
 
 	if (error_found)
 		pr_warn("GPT: Use GNU Parted to correct GPT errors.\n");
-- 
1.8.5.6
