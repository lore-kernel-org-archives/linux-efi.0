From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] efivars: allow efi pstore variable when validate filename
Date: Tue, 12 Mar 2013 02:57:28 +0800
Message-ID: <1363028248-27788-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

We mount efivarfs fail after pstore generated 'dump-type*' variables and
reboot.

This issue introduced by commit 47f531e8ba3bc3901a0c493f4252826c41dea1a1
(efivarfs: Validate filenames much more aggressively)

The pstore variable is 'dump-type*-*-*-*-GUID'style, it could not pass
the "GUID should be right after the first '-'" check. This patch allow
the variable name that has 'dump-type' pass the name check.

Cc: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 drivers/firmware/efivars.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 3edade0..ab07f7f 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -930,7 +930,7 @@ static bool efivarfs_valid_name(const char *str, int len)
 		return false;
 
 	/* GUID should be right after the first '-' */
-	if (s - 1 != strchr(str, '-'))
+	if (s - 1 != strchr(str, '-') && !strstarts(str, "dump-type"))
 		return false;
 
 	/*
-- 
1.6.4.2
