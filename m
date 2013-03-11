From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH] efivars: allow efi pstore variable when validate filename
Date: Tue, 12 Mar 2013 03:00:28 +0800
Message-ID: <1363028428-27976-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: matt.fleming@intel.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Seiji Aguchi <seiji.aguchi@hds.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Al Viro <viro@zeniv.linux.org.uk>, Lingzhu Xiang <lxiang@redhat.com>
List-Id: linux-efi@vger.kernel.org

We mount efivarfs fail after pstore generated 'dump-type*' variables and
reboot.

This issue introduced by commit 47f531e8ba3bc3901a0c493f4252826c41dea1a1
(efivarfs: Validate filenames much more aggressively)

The pstore variable is 'dump-type*-*-*-*-GUID'style, it could not pass
the "GUID should be right after the first '-'" check. This patch allow
the variable name that has 'dump-type' pass the name check.

Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Lingzhu Xiang <lxiang@redhat.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
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
