Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654984;
	b=oyF5fMUAwUliYihjpM07Rw9VsCje+OinSK/PHf2ieq0iVx/+blgitO8Fv/8PtFtiVVyf
	 T3bs5K7bt/9QeeVgqYcVtarDvGikgnuWQ+HjJuoOwC1vsHwN7/scSdXklLbikxX3geWEq
	 LilIEDc0W4Elp7vX1Sgi7rHW7xMTfUJxvG1AQMVk8PkvDtCGalZpoEUen/PXr9XanSbam
	 kAUc3G0T3PDzs/oJqHjSE8MUZzLYGAX39GfvbMGln7x5Hf3CyglgMpULL0/1thItbGHZp
	 /sdtx0gW4zl9mzph75kOVBw6Ee3TuKqmZjQHG7EBwyqxFCKZ0rPLocTY3ag1OtIZOuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654984;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=FkTsVSM9a2+gqqimcCxQ5wUYQZ+H2WJBNDoRUBQk6tw=;
	b=buOgFbb4Ld+A9xr6rryKiEMtD87W73pY8otpg8gv9OBRPpAe3O8g2Stmcl9R44oU1EKY
	 fMuU/p8rmz5MKrfS1vX2gSjS0UAtFc4ZNFJ9bJtNMJ7DkApx3BfPTqKP8NJcW6PimAbQG
	 OLB/sre5ORLqUUysD9qdR4z5d/LKWseTdmy/yI+acaYwJ65fcUkhwUBc155qdLSe8/qj6
	 apojO5e/2UHQuxtYh0jqViRh6svOVJ9FyL0DqCJUmf7qZhJVcbo1wLt/POmdtE6CW7kYx
	 iRJZxUFct5o+D6T4HBifTOYSsDdeUMB4tXslw3NAPZWKx/u2YLjJ8YaEFfXKSAFwQMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WVB+xkcL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9CE606A32F;
	Mon,  2 Nov 2026 21:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WVB+xkcL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1820A1F00A22;
	Mon,  2 Nov 2026 21:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793654983;
	bh=FkTsVSM9a2+gqqimcCxQ5wUYQZ+H2WJBNDoRUBQk6tw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WVB+xkcL/nlg0j5o6zDKnXsGgZ1OZL6H+RIFJpFy2I5Dapuk4cPCoHeiDW1CM8o/3
	 qupELmsB0Z6RCCwCpZ+Yvb+Wytc8hj+xwWzXQN+yPjO1nlRadun/n+TFDFkIo/5YmG
	 8XmKQIGLSWTB61thHtxLc8jlL3XUAjh0j/t4G96Ze2h9cS7zAEq2sIpzH9koVHYTBt
	 CUyFpNddd9MhYMjdrY62AvmzvKDLZksKpFbQwHOGVP2FLqF/vRj/YkdmKPMqwAK54C
	 9MJqqtlhrXdxB30dOTBiwmoPkm+PiHM5TRBsvhAiVNc0Ws+qJeE41ITP6WtC1xlzaI
	 jwi7h3VdtSpJQ==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Mon, 02 Nov 2026 22:29:11 +0100
Subject: [PATCH v3 4/7] block: discover root by DPS partition type UUID
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-discoverable-root_partitions-v3-4-27f04b69b7ab@kernel.org>
References: <20261102-discoverable-root_partitions-v3-0-27f04b69b7ab@kernel.org>
In-Reply-To: <20261102-discoverable-root_partitions-v3-0-27f04b69b7ab@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Dave Hansen <dave.hansen@intel.com>, 
 James Bottomley <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Matthew Wilcox <willy@infradead.org>, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8648; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=BaPrGER3z75fMU17F6nTo679evSe/UlOykPi1g8wOJU=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkvGTbeK7pgrsuiUdxT/fna+ZJcjTkOzH7PnspoG3ZF7
 lvyuvVxx0QWBjEuBksxRZZl5ZzcCh2F3mGH/lrCzGFlAhkiLdLAAAQsDHy5iXmlRjpGeqbahnqG
 QIaOEQMXpwBM9ZEGhn8mJsXu3A3blz3PlLx9sGtqnLfJ4ifOjE/5amPFq8oiHu1g+J94bKmVkN2
 7k4xz3X8u2pBw7RPzM8lgpQVaDzh3uC3bp8EOAA==
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

When root= and ROOT_DEV are not set, discover the root block device
using the architecture's DPS root partition type UUID. Preserve explicit
root selection and an existing ROOT_DEV supplied by the boot protocol.

DPS [1] restricts discovery to the disk containing the active EFI System
Partition. Read LoaderDevicePartUUID from the Boot Loader Interface to
identify that disk and cache the UUID for subsequent lookup attempts.

Add early_lookup_bdev_by_type_uuid() to select the first matching
partition. The EFI System Partition may become visible before the root
partition has been registered. Hold the disk's open_mutex during lookup
so partition scanning finishes before returning -ENODEV.

Add early_lookup_dps_root() and have lookup_root_device() call it when
root= is absent. early_lookup_bdev() is kept unchanged so other callers
cannot trigger root discovery inadvertently. Return -EINVAL if the EFI
variable cannot be read or does not contain a valid UUID, so
lookup_root_device() disables rootwait. Return -EAGAIN if the EFI
partition is not available yet so rootwait can retry. Return -ENODEV if
its disk has no matching root partition. In that case, have
lookup_root_device() disable rootwait, clear the device number and
return zero to stop retries. This is safe because partition registration
failures do not schedule a rescan, nor does rootwait.

[1] The Discoverable Partitions Specification (DPS)
Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 block/early-lookup.c   | 117 +++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/blkdev.h |  10 +++++
 init/do_mounts.c       |  25 +++++++++--
 3 files changed, 145 insertions(+), 7 deletions(-)

diff --git a/block/early-lookup.c b/block/early-lookup.c
index 3fb57f7d2b12..e3da4bfb41e7 100644
--- a/block/early-lookup.c
+++ b/block/early-lookup.c
@@ -5,10 +5,14 @@
  */
 #include <linux/blkdev.h>
 #include <linux/ctype.h>
+#include <linux/efi.h>
+#include <linux/ucs2_string.h>
+#include <linux/uuid.h>
 
 struct uuidcmp {
 	const char *uuid;
 	int len;
+	struct gendisk *disk;
 };
 
 /**
@@ -45,13 +49,11 @@ static int __init match_dev_by_uuid(struct device *dev, const void *data)
  */
 static int __init devt_from_partuuid(const char *uuid_str, dev_t *devt)
 {
-	struct uuidcmp cmp;
+	struct uuidcmp cmp = { .uuid = uuid_str };
 	struct device *dev = NULL;
 	int offset = 0;
 	char *slash;
 
-	cmp.uuid = uuid_str;
-
 	slash = strchr(uuid_str, '/');
 	/* Check for optional partition number offset attributes. */
 	if (slash) {
@@ -252,6 +254,115 @@ int __init early_lookup_bdev(const char *name, dev_t *devt)
 	return devt_from_devnum(name, devt);
 }
 
+#ifdef CONFIG_DPS_ROOT_AUTO_DISCOVERY
+static int __init match_dev_by_type_uuid(struct device *dev, const void *data)
+{
+	struct block_device *bdev = dev_to_bdev(dev);
+	const struct uuidcmp *cmp = data;
+
+	return bdev->bd_disk == cmp->disk && bdev->bd_meta_info &&
+		!strcasecmp(cmp->uuid, bdev->bd_meta_info->type_uuid);
+}
+
+/*
+ * Search the ESP's disk for an eligible partition of the requested type.
+ * Return -EAGAIN until the ESP is available, or -ENODEV if no match exists.
+ */
+static int __init early_lookup_bdev_by_type_uuid(const char *type_uuid,
+						 const char *esp_partuuid,
+						 dev_t *devt)
+{
+	struct uuidcmp esp_cmp = {
+		.uuid = esp_partuuid,
+		.len = UUID_STRING_LEN,
+	};
+	struct uuidcmp type_cmp = {
+		.uuid = type_uuid,
+	};
+	struct device *esp_dev;
+	struct device *type_dev;
+
+	esp_dev = class_find_device(&block_class, NULL, &esp_cmp,
+				    &match_dev_by_uuid);
+	if (!esp_dev)
+		return -EAGAIN;
+
+	type_cmp.disk = dev_to_disk(esp_dev);
+	scoped_guard(mutex, &type_cmp.disk->open_mutex)
+		type_dev = class_find_device(&block_class, NULL, &type_cmp,
+					     &match_dev_by_type_uuid);
+	put_device(esp_dev);
+	if (!type_dev)
+		return -ENODEV;
+
+	*devt = type_dev->devt;
+	pr_info("VFS: Discovered root partition /dev/%pg with GPT type UUID %s\n",
+		dev_to_bdev(type_dev), type_uuid);
+	put_device(type_dev);
+	return 0;
+}
+
+static int __init efi_get_esp_partuuid(char *partuuid, size_t size)
+{
+	static efi_guid_t loader_guid __initdata = LINUX_EFI_LOADER_ENTRY_GUID;
+	efi_char16_t partuuid_ucs2[UUID_STRING_LEN + 1] = {};
+	unsigned long partuuid_ucs2_size = sizeof(partuuid_ucs2);
+	efi_status_t status;
+
+	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
+		return -EOPNOTSUPP;
+
+	status = efi.get_variable(L"LoaderDevicePartUUID", &loader_guid, NULL,
+				  &partuuid_ucs2_size, partuuid_ucs2);
+	if (status != EFI_SUCCESS)
+		return efi_status_to_err(status);
+
+	if (partuuid_ucs2_size != sizeof(partuuid_ucs2) ||
+	    partuuid_ucs2[UUID_STRING_LEN] ||
+	    ucs2_as_utf8((u8 *)partuuid, partuuid_ucs2, size) != UUID_STRING_LEN ||
+	    !uuid_is_valid(partuuid))
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * early_lookup_dps_root - discover the root device by DPS partition type UUID
+ * @dev: receives the discovered device number
+ *
+ * Return: 0 on success, -EINVAL if the ESP partition UUID cannot be read or
+ * is invalid, -EAGAIN if the EFI partition is not yet available, or -ENODEV
+ * if no matching root exists.
+ * With DPS disabled, return 0 and set @dev to zero.
+ */
+int __init early_lookup_dps_root(dev_t *dev)
+{
+	static const char root_type_uuids[][UUID_STRING_LEN + 1] __initconst = {
+		CONFIG_DPS_ROOT_PARTITION_TYPE_UUID,
+	};
+	static char esp_partuuid[UUID_STRING_LEN + 1] __initdata;
+	int err;
+
+	if (!esp_partuuid[0]) {
+		err = efi_get_esp_partuuid(esp_partuuid, sizeof(esp_partuuid));
+		if (err) {
+			pr_err("VFS: Unable to get EFI partition UUID: %pe, skipping root partition discovery\n",
+				ERR_PTR(err));
+			return -EINVAL;
+		}
+	}
+
+	for (int i = 0; i < ARRAY_SIZE(root_type_uuids); i++) {
+		err = early_lookup_bdev_by_type_uuid(root_type_uuids[i],
+						     esp_partuuid, dev);
+		if (err != -ENODEV)
+			return err;
+	}
+
+	return -ENODEV;
+}
+#endif /* CONFIG_DPS_ROOT_AUTO_DISCOVERY */
+
 static char __init *bdevt_str(dev_t devt, char *buf)
 {
 	if (MAJOR(devt) <= 0xff && MINOR(devt) <= 0xff) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0e0f5d68425d..5cfef05b552e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1748,6 +1748,16 @@ static inline int early_lookup_bdev(const char *pathname, dev_t *dev)
 }
 #endif /* CONFIG_BLOCK */
 
+#ifdef CONFIG_DPS_ROOT_AUTO_DISCOVERY
+int __init early_lookup_dps_root(dev_t *dev);
+#else
+static inline int early_lookup_dps_root(dev_t *dev)
+{
+	*dev = 0;
+	return 0;
+}
+#endif /* CONFIG_DPS_ROOT_AUTO_DISCOVERY */
+
 int bdev_freeze(struct block_device *bdev);
 int bdev_thaw(struct block_device *bdev);
 int bdev_deny_freeze(struct block_device *bdev);
diff --git a/init/do_mounts.c b/init/do_mounts.c
index b0dccad20971..c1106e3cab3d 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -406,10 +406,24 @@ static int __init lookup_root_device(const char *root_device_name, dev_t *dev)
 {
 	int err;
 
-	err = early_lookup_bdev(root_device_name, dev);
+	if (root_device_name[0]) {
+		err = early_lookup_bdev(root_device_name, dev);
+		if (err == -EINVAL && root_wait) {
+			pr_err("VFS: root= is invalid; disabling rootwait.\n");
+			root_wait = 0;
+		}
+		return err;
+	}
+
+	err = early_lookup_dps_root(dev);
 	if (err == -EINVAL && root_wait) {
-		pr_err("VFS: root= is invalid; disabling rootwait.\n");
+		pr_err("VFS: Root discovery is unavailable; disabling rootwait.\n");
 		root_wait = 0;
+	} else if (err == -ENODEV) {
+		pr_err("VFS: No discoverable root partition found; aborting.\n");
+		root_wait = 0;
+		*dev = 0;
+		return 0;
 	}
 	return err;
 }
@@ -422,7 +436,10 @@ static void __init wait_for_root(char *root_device_name)
 	if (ROOT_DEV != 0)
 		return;
 
-	pr_info("Waiting for root device %s...\n", root_device_name);
+	if (root_device_name[0])
+		pr_info("Waiting for root device %s...\n", root_device_name);
+	else if (IS_ENABLED(CONFIG_DPS_ROOT_AUTO_DISCOVERY))
+		pr_info("Waiting for discoverable root partition...\n");
 
 	end = ktime_add_ms(ktime_get_raw(), root_wait);
 
@@ -480,7 +497,7 @@ void __init prepare_namespace(void)
 
 	md_run_setup();
 
-	if (saved_root_name[0])
+	if (saved_root_name[0] || !ROOT_DEV)
 		ROOT_DEV = parse_root_device(saved_root_name);
 
 	initrd_load();

-- 
2.56.0

