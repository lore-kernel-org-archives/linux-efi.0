From: Nikolai Merinov <n.merinov@inango-systems.com>
Subject: [PATCH] partitions/efi: Fix partition name parsing in GUID partition entry
Date: Sat, 24 Nov 2018 21:21:23 +0500
Message-ID: <20181124162123.21300-1-n.merinov@inango-systems.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>, linux-efi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Nikolai Merinov <n.merinov@inango-systems.com>
List-Id: linux-efi@vger.kernel.org

GUID partition entry defined to have a partition name as 36 UTF-16LE
code units. This means that on big-endian platforms ASCII symbols
would be read with 0xXX00 efi_char16_t character code. In order to
correctly extract ASCII characters from a partition name field we
should be converted from 16LE to CPU architecture.

The problem exists on all big endian platforms.

Signed-off-by: Nikolai Merinov <n.merinov@inango-systems.com>
---
 block/partitions/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 39f70d968754..ea50ee1505ed 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -729,7 +729,7 @@ int efi_partition(struct parsed_partitions *state)
 				ARRAY_SIZE(ptes[i].partition_name));
 		info->volname[label_max] = 0;
 		while (label_count < label_max) {
-			u8 c = ptes[i].partition_name[label_count] & 0xff;
+			u8 c = le16_to_cpu(ptes[i].partition_name[label_count]) & 0xff;
 			if (c && !isprint(c))
 				c = '!';
 			info->volname[label_count] = c;
-- 
2.14.1
