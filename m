Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370654218AD;
	Mon, 15 Jun 2026 16:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539872; cv=none; b=MlzobQBtIDA6U5SqTevh+ESBBEDHeJacmz5uHUlHBMkJIsx3UuB44WwocLYVoBfP1p8gWhoVNPngf+NpK6+6UYo7M7AuCmU3+Sw5Tu5bFwKlf8PFOr/d5FHYhWl1ffYzOzCv+2jf4a8J9ISzWOnvfvXRdELjPMg1PIlCX502w7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539872; c=relaxed/simple;
	bh=oIhDEhD8xz8GDiz72pbn2HwrEoY/TPBsffKkIXfMFvI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WW0x3ji62FMn55mww5UxGbEJYyatru807PTK+BlqrJZDSq3itFNbur6ZVSy8F0JEc6iEuifH/xA+qUoVfitG6TRgA1kLVjLWq0/64S3ct+6KUD2uK/KmFO7l0/OO7GPXjaP62HX1ohp4PFIdD+2MrisvjSzf8/TNpMq4Rtjs8+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DhsCYyRr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DhsCYyRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3271F000E9;
	Mon, 15 Jun 2026 16:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781539871;
	bh=2dpV8+Ol0zjRCfvZ5AlMUWwMBV0uwU+r3wDGHru8Kg0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DhsCYyRryl/GbKDjf3N1AgjoSgC8ICFRSnOKEcoBSycKnnHtE7JLTmOCq/5gwKbGq
	 HMkOi3hFdibhN88zw5oIgSNOzVGFxIE28XsUUXn6LMxTTrZbXq1/RvNU9Ikaf5qlp9
	 t4PYd70ls4jP0b8Zv20fIrt9crxNdft4JhUrUiPSSkB8BHNaREo6Qh8a/yhUwvUT+c
	 3osoRzcGaLPgpRSYCJhQHNFrph0oYpKIZdPLGVaTuSaoViHSUT6F3kcdz+7FUq+qLw
	 SILFBPMcptVd+JGEnmPgnr6dMm+5++QBXMIERoub6ST/huVerJorheknqDWBkQLyNg
	 Rst9zVcu+h8NA==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 15 Jun 2026 18:09:14 +0200
Subject: [PATCH 18/19] init: discover root by DPS partition type UUID
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-discoverable-root_partitions-v1-18-39c78fac42e2@kernel.org>
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
In-Reply-To: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4413; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=oIhDEhD8xz8GDiz72pbn2HwrEoY/TPBsffKkIXfMFvI=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkGytcSmFMOrou63C0SvfuzyzpGhh/TDSe88sicf+v9t
 47dMatUOyayMIhxMViKKbIsK+fkVugo9A479NcSZg4rE8gQaZEGBiBgYeDLTcwrNdIx0jPVNtQz
 BDJ0jBi4OAVgqs3sGP47aHg8ei/YGqPSVhQn8G5mTNsNfT05fz12mxM7ljv3XuxlZPisdMz7r0/
 UsXNLpu//mKviGuh9zUq9cU2pjyj390dy6/gB
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

When the root= cmdline option is absent, try to discover the root block
device using the architecture's DPS root partition type UUID.

DPS limits root discovery to the disk containing the active EFI System
Partition. Read LoaderDevicePartUUID from the Boot Loader Interface and
pass it to early_lookup_bdev_by_type_uuid() so the block lookup only
considers partitions on that disk.

Print a dedicated wait message while waiting for a discoverable root
partition and emit an informational message when discovery succeeds.

If LoaderDevicePartUUID cannot be read or does not contain a valid UUID,
clear root_wait so the kernel does not keep retrying a discovery path
that cannot succeed.

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 init/do_mounts.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 87 insertions(+), 2 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 5fb5aeb88da9..20c176945b32 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -10,6 +10,7 @@
 #include <linux/delay.h>
 #include <linux/mount.h>
 #include <linux/device.h>
+#include <linux/efi.h>
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/initrd.h>
@@ -19,6 +20,8 @@
 #include <linux/ramfs.h>
 #include <linux/shmem_fs.h>
 #include <linux/ktime.h>
+#include <linux/ucs2_string.h>
+#include <linux/uuid.h>
 
 #include <linux/nfs_fs.h>
 #include <linux/nfs_fs_sb.h>
@@ -402,9 +405,86 @@ void __init mount_root(char *root_device_name)
 	}
 }
 
+#ifdef CONFIG_DPS_ROOT_AUTO_DISCOVERY
+static char efi_partuuid[EFI_VARIABLE_GUID_LEN + 1] __initdata;
+
+static int __init efi_loader_get_device_part_uuid(char *efi_uuid, size_t size)
+{
+	efi_char16_t efi_uuid_ucs2[EFI_VARIABLE_GUID_LEN + 1] = {};
+	unsigned long efi_uuid_ucs2_size = sizeof(efi_uuid_ucs2);
+	efi_status_t status;
+
+	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
+		return -EOPNOTSUPP;
+
+	status = efi.get_variable(L"LoaderDevicePartUUID",
+				  &LINUX_EFI_LOADER_ENTRY_GUID, NULL,
+				  &efi_uuid_ucs2_size, efi_uuid_ucs2);
+	if (status != EFI_SUCCESS)
+		return efi_status_to_err(status);
+
+	if (ucs2_as_utf8((u8 *)efi_uuid, efi_uuid_ucs2, size) != UUID_STRING_LEN ||
+	    !uuid_is_valid(efi_uuid))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int __init lookup_dps_root(dev_t *dev)
+{
+	static const char dps_root_partition_type_uuid[] __initconst =
+		DPS_ROOT_PARTITION_TYPE_UUID;
+	int err;
+
+	err = early_lookup_bdev_by_type_uuid(dps_root_partition_type_uuid,
+					     efi_partuuid, dev);
+	if (!err)
+		pr_info("VFS: Discovered root partition with GPT type UUID %s\n",
+			dps_root_partition_type_uuid);
+
+	return err;
+}
+
+static dev_t __init try_dps_root_discovery(void)
+{
+	dev_t dev;
+	int err;
+
+	err = efi_loader_get_device_part_uuid(efi_partuuid,
+					      sizeof(efi_partuuid));
+	if (err) {
+		pr_err("VFS: Unable to get LoaderDevicePartUUID EFI variable: %pe, skipping root partition discovery\n",
+			ERR_PTR(err));
+		if (root_wait) {
+			pr_err("Disabling rootwait\n");
+			root_wait = 0;
+		}
+		return 0;
+	}
+
+	if (!lookup_dps_root(&dev))
+		return dev;
+
+	return 0;
+}
+#else
+static int __init lookup_dps_root(dev_t *dev)
+{
+	return 0;
+}
+
+static dev_t __init try_dps_root_discovery(void)
+{
+	return 0;
+}
+#endif
+
 static int __init lookup_root_device(char *root_device_name)
 {
-	return early_lookup_bdev(root_device_name, &ROOT_DEV);
+	if (root_device_name[0])
+		return early_lookup_bdev(root_device_name, &ROOT_DEV);
+	else
+		return lookup_dps_root(&ROOT_DEV);
 }
 
 /* wait for any asynchronous scanning to complete */
@@ -415,7 +495,10 @@ static void __init wait_for_root(char *root_device_name)
 	if (ROOT_DEV != 0)
 		return;
 
-	pr_info("Waiting for root device %s...\n", root_device_name);
+	if (root_device_name[0])
+		pr_info("Waiting for root device %s...\n", root_device_name);
+	else if (IS_ENABLED(CONFIG_DPS_ROOT_AUTO_DISCOVERY))
+		pr_info("Waiting for discoverable root partition...\n");
 
 	end = ktime_add_ms(ktime_get_raw(), root_wait);
 
@@ -480,6 +563,8 @@ void __init prepare_namespace(void)
 
 	if (saved_root_name[0])
 		ROOT_DEV = parse_root_device(saved_root_name);
+	else
+		ROOT_DEV = try_dps_root_discovery();
 
 	initrd_load();
 

-- 
2.53.0

