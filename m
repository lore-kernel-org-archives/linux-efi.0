From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] partition/efi: use ilog2 to compute block size
Date: Wed, 22 Jun 2016 14:58:48 +0200
Message-ID: <20160622125905.1269359-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>, Jens Axboe <axboe@kernel.dk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-efi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Enabling CONFIG_UBSAN_SANITIZE_ALL on ARM caused a link error:

last_lba.part.0':
:(.text+0xc3440): undefined reference to `____ilog2_NaN'
:(.text+0xc3538): undefined reference to `__aeabi_uldivmod'
:(.text+0xc38e8): undefined reference to `__aeabi_uldivmod'

This is caused by gcc not behaving in the expected ways with __builtin_constant_p(),
but it also points to somewhat inefficient code: As we know that the
block size is a power-of-two value, we can turn the expensive 64-bit
division into a simpler variable bit shift.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/partitions/efi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index bcd86e5cd546..7d83cf069574 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -147,10 +147,13 @@ efi_crc32(const void *buf, unsigned long len)
  */
 static u64 last_lba(struct block_device *bdev)
 {
+	unsigned int blocksize;
+
 	if (!bdev || !bdev->bd_inode)
 		return 0;
-	return div_u64(bdev->bd_inode->i_size,
-		       bdev_logical_block_size(bdev)) - 1ULL;
+
+	blocksize = bdev_logical_block_size(bdev);
+	return (bdev->bd_inode->i_size >> ilog2(blocksize)) - 1ULL;
 }
 
 static inline int pmbr_part_valid(gpt_mbr_record *part)
-- 
2.9.0
