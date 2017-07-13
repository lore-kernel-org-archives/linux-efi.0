From: Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] efi: add gpt_overprovisioned kernel command line parameter
Date: Thu, 13 Jul 2017 15:21:04 -0700
Message-ID: <20170713222137.11529-1-salyzyn@android.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Allow a gpt partition table to be used if it is overprovisioned, the
last usable lba in the GPT headers is beyond the device boundaries.
This feature is enabled if gpt_overprovisioned is added to the kernel
command line.  It will not expose any individual partitions that go
beyond the device boundaries, just the ones that are under that limit.

Default off, one can perform an exploratory boot of the kernel and
triage or backup the properly provisioned partitions.  This would
allow the system to at least partially boot. For example if the boot,
root or system filesystems reside on properly provisioned partitions.

Examples, helpful should a RAID array be resized downwards, or
during embedded development should an overprovisioned partition
table update be flashed to a device by accident.

Signed-off-by: Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
---
 block/partitions/efi.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 39f70d968754..e18ee5cf138c 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -117,6 +117,15 @@ force_gpt_fn(char *str)
 }
 __setup("gpt", force_gpt_fn);
 
+static int overprovisioned_gpt;
+static int __init
+overprovisioned_gpt_fn(char *str)
+{
+	overprovisioned_gpt = 1;
+	return 1;
+}
+__setup("gpt_overprovisioned", overprovisioned_gpt_fn);
+
 
 /**
  * efi_crc32() - EFI version of crc32 function
@@ -420,7 +429,8 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 		pr_debug("GPT: last_usable_lba incorrect: %lld > %lld\n",
 			 (unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
 			 (unsigned long long)lastlba);
-		goto fail;
+		if (!overprovisioned_gpt)
+			goto fail;
 	}
 	if (le64_to_cpu((*gpt)->last_usable_lba) < le64_to_cpu((*gpt)->first_usable_lba)) {
 		pr_debug("GPT: last_usable_lba incorrect: %lld > %lld\n",
-- 
2.13.2.932.g7449e964c-goog
