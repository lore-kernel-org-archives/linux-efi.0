Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32EA5377EB0;
	Thu,  3 Sep 2026 11:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435171; cv=none; b=ed4QCEf3FXRkUUb5xEP/MQFSoLpOqz+AzcIq4/mEawsXTt569Nh4MOjdNffcHf+B8JAr/gfKDEb29G8efIpmm4CVCxu6VBXTAfsEykn8I/zuvHZH1nT5WbFUaQNYb2UJU4VkydKTTWaN89zt+e4gVYRqOiHfdaGj1oDhaEGcSso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435171; c=relaxed/simple;
	bh=ekfr9ze8xbBrKnpLVQLWiWIaYz8ipeTXJlHkB2y+Q6k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aRb7bZ8BuTIsyvrchPCyllvXAPwuOjvv3hkm19sMLfv8CWyQhmFb/yBRpE6yv+H9tFOTTaAY6bAUmEqOuRPy9EvKOlUC3Ajor6tqnL9kEc5SwI5jvaftOz5ZvJkzR8padjOgNxiFihtM0InSXNHO0d5MAawQTBitLAPJ48Gdfpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YkzbecWV; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YkzbecWV"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E7B41596;
	Thu,  3 Sep 2026 04:32:40 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 583EB3F7D8;
	Thu,  3 Sep 2026 04:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788435164; bh=ekfr9ze8xbBrKnpLVQLWiWIaYz8ipeTXJlHkB2y+Q6k=;
	h=From:To:Cc:Subject:Date:From;
	b=YkzbecWV9DSNRB07zZSFuatW3C87rqB1JW04SrIqvamweMMH3dsorPzqq0eU/NGdB
	 B8TgUcZ7IgLj9EcU5O1FQetlCmww+gXwJGHsuE1Q1H5ex5+Xz0N47OHvdnyuOyYBRQ
	 hhdQAIU/B/5wjjQWMp8pdS1/Q0vVkf0moi3suOcA=
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: ardb@kernel.org,
	ilias.apalodimas@linaro.org,
	leitao@debian.org,
	Sami.Mujawar@arm.com,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH] firmware: efi: add a separate timeout for UpdateCapsule()
Date: Thu,  3 Sep 2026 12:32:38 +0100
Message-ID: <20260903113238.2291844-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On platforms that allows to update firmware in runtime, UpdateCapsule()
may immediately write a firmware image to persistent storage.
This operation can take longer than EFI_RTS_TIMEOUT.

Use a separate timeout for the UpdateCapsule() runtime service. By
default, wait indefinitely to avoid interrupting an ongoing firmware
update. Administrators may configure an appropriate timeout, in seconds,
through /sys/firmware/efi/capsule_update_timeout.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 drivers/firmware/efi/efi.c              | 41 +++++++++++++++++++++++++
 drivers/firmware/efi/runtime-wrappers.c | 14 +++------
 include/linux/efi.h                     | 10 ++++++
 3 files changed, 55 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 0327a39d31fa..aef0ba170e3c 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -63,6 +63,18 @@ static unsigned long __initdata mem_reserve = EFI_INVALID_TABLE_ADDR;
 static unsigned long __initdata rt_prop = EFI_INVALID_TABLE_ADDR;
 static unsigned long __initdata initrd = EFI_INVALID_TABLE_ADDR;
 
+/*
+ * Depending on the platform, UpdateCapsule() may update the firmware
+ * immediately if the platform allows to update the firmware while in runtime.
+ * In this case, writing the image to firmware storage may take longer than
+ * EFI_RTS_TIMEOUT (120 seconds).
+ *
+ * To handle this, use a separate timeout for the UpdateCapsule() runtime
+ * service. Wait indefinitely by default, and allow administrators to set
+ * an appropriate timeout in seconds through /sys/firmware/efi/capsule_update_timeout.
+ */
+unsigned long efi_capsule_update_timeout = MAX_SCHEDULE_TIMEOUT;
+
 extern unsigned long primary_display_table;
 
 struct mm_struct efi_mm = {
@@ -163,15 +175,44 @@ static ssize_t fw_platform_size_show(struct kobject *kobj,
 	return sprintf(buf, "%d\n", efi_enabled(EFI_64BIT) ? 64 : 32);
 }
 
+static ssize_t capsule_update_timeout_show(struct kobject *kobj,
+					   struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lu\n", efi_capsule_update_timeout / HZ);
+}
+
+static ssize_t capsule_update_timeout_store(struct kobject *kobj,
+					    struct kobj_attribute *attr,
+					    const char *buf, size_t count)
+{
+	int ret;
+	unsigned long secs, timeout;
+
+	ret = kstrtoul(buf, 0, &secs);
+	if (ret)
+		return ret;
+	if (check_mul_overflow(secs, HZ, &timeout))
+		timeout = MAX_SCHEDULE_TIMEOUT;
+	if (timeout < EFI_RTS_TIMEOUT)
+		timeout = EFI_RTS_TIMEOUT;
+
+	efi_capsule_update_timeout = timeout;
+
+	return count;
+}
+
 extern __weak struct kobj_attribute efi_attr_fw_vendor;
 extern __weak struct kobj_attribute efi_attr_runtime;
 extern __weak struct kobj_attribute efi_attr_config_table;
 static struct kobj_attribute efi_attr_fw_platform_size =
 	__ATTR_RO(fw_platform_size);
+static struct kobj_attribute efi_attr_capsule_update_timeout =
+	__ATTR_RW_MODE(capsule_update_timeout, 0600);
 
 static struct attribute *efi_subsys_attrs[] = {
 	&efi_attr_systab.attr,
 	&efi_attr_fw_platform_size.attr,
+	&efi_attr_capsule_update_timeout.attr,
 	&efi_attr_fw_vendor.attr,
 	&efi_attr_runtime.attr,
 	&efi_attr_config_table.attr,
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 2344b9d1e81f..b0f867f828c1 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -118,14 +118,6 @@ union efi_rts_args {
 
 struct efi_runtime_work efi_rts_work;
 
-/*
- * Upper bound on how long we wait for a single EFI runtime service
- * call to finish before declaring firmware wedged. Chosen to be longer
- * than any plausible legitimate call (including UpdateCapsule on slow
- * SPI-NOR) while still bounding userspace wait time.
- */
-#define EFI_RTS_TIMEOUT		(120 * HZ)
-
 /*
  * efi_queue_work:	Queue EFI runtime service call and wait for completion
  * @_rts:		EFI runtime service function identifier
@@ -347,6 +339,8 @@ static void __nocfi efi_call_rts(struct work_struct *work)
 static efi_status_t __efi_queue_work(enum efi_rts_ids id,
 				     union efi_rts_args *args)
 {
+	unsigned long timeout;
+
 	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
 		pr_warn_once("EFI Runtime Services are disabled!\n");
 		return EFI_DEVICE_ERROR;
@@ -369,8 +363,8 @@ static efi_status_t __efi_queue_work(enum efi_rts_ids id,
 		goto exit;
 	}
 
-	if (!wait_for_completion_timeout(&efi_rts_work.efi_rts_comp,
-					 EFI_RTS_TIMEOUT)) {
+	timeout = (id == EFI_UPDATE_CAPSULE) ? efi_capsule_update_timeout : EFI_RTS_TIMEOUT;
+	if (!wait_for_completion_timeout(&efi_rts_work.efi_rts_comp, timeout)) {
 		pr_err("EFI runtime service %d wedged in firmware; disabling EFI runtime services\n",
 		       id);
 		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index aa15ff88539b..8e14ca5e57de 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1345,4 +1345,14 @@ extern struct blocking_notifier_head efivar_ops_nh;
 void efivars_generic_ops_register(void);
 void efivars_generic_ops_unregister(void);
 
+/*
+ * Upper bound on how long we wait for a single EFI runtime service
+ * call to finish before declaring firmware wedged. Chosen to be longer
+ * than any plausible legitimate call (excluding UpdateCapsule() while
+ * still bounding userspace wait time.
+ */
+#define EFI_RTS_TIMEOUT		(120 * HZ)
+
+extern unsigned long efi_capsule_update_timeout;
+
 #endif /* _LINUX_EFI_H */
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

