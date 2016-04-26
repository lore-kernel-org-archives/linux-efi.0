From: Julius Werner <jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] block: partitions: efi: Always check for alternative GPT at end of drive
Date: Mon, 25 Apr 2016 18:06:46 -0700
Message-ID: <1461632806-5946-1-git-send-email-jwerner@chromium.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Doug Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julius Werner <jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The GUID Partiton Table layout maintains two synonymous partition tables
on a block device, one starting in sector 1 and one in the very last
sectors of the block device. This is useful if one of the tables gets
accidentally corrupted (e.g. through a partial write because of an
unexpected power loss).

Linux normally only boots if the primary GPT is valid. It will not even
try to find the alternative GPT to an invalid primary one unless the
"gpt" command line option forces more aggressive detection. This doesn't
really make any sense... if the "gpt" option is not set, the code
validates the protective or hybrid MBR in sector 0 anyway before it even
starts looking for the actual GPTs. If we get to the point where a valid
proctective or hybrid MBR was found but the primary GPT was not found
(valid), checking the alternative GPT is our best bet: we know that this
block device is meant to use GPT (because any other partitioning system
would've presumably overwritten sector 0), and we know that if the
alternative GPT is valid it should contain more accurate information
than parsing the protective/hybrid MBR with msdos_partition() would
yield (which would otherwise be what happens next).

Signed-off-by: Julius Werner <jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 block/partitions/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 26cb624..0d4ca8e 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -625,7 +625,7 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
 		good_agpt = is_gpt_valid(state,
 					 le64_to_cpu(pgpt->alternate_lba),
 					 &agpt, &aptes);
-        if (!good_agpt && force_gpt)
+        if (!good_agpt)
                 good_agpt = is_gpt_valid(state, lastlba, &agpt, &aptes);
 
         /* The obviously unsuccessful case */
-- 
2.1.2
