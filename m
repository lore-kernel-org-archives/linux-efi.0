Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E4E3E7653;
	Fri, 14 Aug 2026 09:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786701448; cv=none; b=dqfb+VlaYXXvjqFVu1Uo7UTxmjI1gnN6kjBkj2lTlI7EHsIEUtn/WdeLM1BpURBywHZQrnrFBPwCnCOIhozYltf8UU2d5Jgh/F60jujelcRCTrPZSr+mtGJAl7kI8aX56sNlrV10VAEIBKqHayWSVXhpz3dAaYrHYk+ssI7t0hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786701448; c=relaxed/simple;
	bh=iMe1ZJrBPtx2WY36/TEi8IYsVoDynFLV1toyqdXWDlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YP7wh/BBjsixgeXr42FnR3L2orb3s0Tz1x3xnF1n/e+OaKV2Uxk+dryPYEi4HNqJnou3FZMTWO6Bv/gvk9aH3OUTepKw9lscF6AM5nXt5/XUjRdvr4k7GcUq7Q5BDyMHt0Sq6UyF0zZfxT4eBQjJhpd61LTufxDKYIvPJwG/OuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LBpPid+9; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LBpPid+9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786701445; x=1818237445;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iMe1ZJrBPtx2WY36/TEi8IYsVoDynFLV1toyqdXWDlE=;
  b=LBpPid+9YG8QZ+kYL+TgJsKW3vk+mEaecUaiStEiGVyoP9SmVoAgJWlP
   JCCthsq0RgOHff513AjzqEWkQTlsbIAHn1Z47sIicygNWVbRKYkO/8iUg
   KM99NEBzQdf9YwxJTb8sS/0LYper8Wbrb4ySdwzxnZlmM0saWPGtq5KJv
   LLPNznA5rk8NsNxMqOh1bZmCLW23i+2HaQpHbBOCtTmZArW02l1Utog94
   FV1nAZOuerCFCPcxOqsgS54mp7PVmIPpo5fgqI9jPeXh0mVYpCebISYNa
   bdiZRr3GrrS+szZVkBel1NZpcnNl9OV7V5nK/nYZ+p/xbBvwxCQQaYVky
   g==;
X-CSE-ConnectionGUID: m74819AkSi2ANwOv2b1trg==
X-CSE-MsgGUID: bnTMHSgmSAWVjwrbiou94g==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="74815492"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="74815492"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 02:57:22 -0700
X-CSE-ConnectionGUID: uTNS/RyVQSauE/lkPAhozQ==
X-CSE-MsgGUID: jy0RQtxfSVGj9qWAPdrrGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="268037586"
Received: from junxiao.bj.intel.com ([10.238.152.69])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 02:57:20 -0700
From: Junxiao Chang <junxiao.chang@intel.com>
To: ardb@kernel.org,
	ilias.apalodimas@linaro.org,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bigeasy@linutronix.de
Cc: junxiao.chang@intel.com
Subject: [PATCH] efi: add dynamic control interface for EFI runtime services
Date: Sat, 15 Aug 2026 17:50:56 +0800
Message-ID: <20260815095057.2461943-1-junxiao.chang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260704003341.3923900-1-junxiao.chang@intel.com>
References: <20260704003341.3923900-1-junxiao.chang@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an interface for PREEMPT_RT kernels to dynamically enable or
disable EFI runtime services.

EFI runtime services are typically disabled on RT systems using
kernel parameters such as "noefi" or "efi=disable" to avoid
long latency caused by firmware calls. However, this permanently
disables EFI runtime services, preventing operations such as UEFI
firmware updates.

With this change, EFI runtime services can be disabled while
real-time workloads are running and re-enabled afterwards,
providing low-latency operation without permanently sacrificing
firmware functionality.

Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
---
 drivers/firmware/efi/efi.c              | 31 +++++++++++++++++++++++++
 drivers/firmware/efi/runtime-wrappers.c | 28 ++++++++++++++++++++++
 include/linux/efi.h                     |  1 +
 3 files changed, 60 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 0327a39d31fa5..6d987d7f97781 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -401,6 +401,32 @@ static void __init efi_debugfs_init(void)
 static inline void efi_debugfs_init(void) {}
 #endif
 
+static ssize_t efi_runtime_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", efi_enabled(EFI_RUNTIME_SERVICES));
+}
+
+static ssize_t efi_runtime_store(struct kobject *kobj, struct kobj_attribute *attr,
+				 const char *buf, size_t count)
+{
+	int ret;
+	bool enable;
+
+	ret = kstrtobool(buf, &enable);
+	if (ret)
+		return ret;
+
+	if (efi_runtime_set_enable_flag(enable) != EFI_SUCCESS) {
+		pr_warn("unable to enable/disable efi runtime service\n");
+		return -EAGAIN;
+	}
+
+	return count;
+}
+
+static struct kobj_attribute efi_runtime_attr =
+	__ATTR(runtime_enable, 0644, efi_runtime_show, efi_runtime_store);
+
 static int __init efipostcore_init(void)
 {
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
@@ -446,6 +472,11 @@ static int __init efisubsys_init(void)
 		goto err_destroy_wq;
 	}
 
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && efi.runtime_supported_mask) {
+		if (sysfs_create_file(efi_kobj, &efi_runtime_attr.attr))
+			pr_warn("unable to register efi dynamic sysfs interface\n");
+	}
+
 	if (efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE |
 				      EFI_RT_SUPPORTED_GET_NEXT_VARIABLE_NAME)) {
 		error = generic_ops_register();
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index da8d296216441..9000ac938746a 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -602,3 +602,31 @@ void efi_runtime_assert_lock_held(void)
 {
 	WARN_ON(efi_runtime_lock_owner != current);
 }
+
+efi_status_t efi_runtime_set_enable_flag(bool enable)
+{
+	static bool runtime_disabled;
+	efi_status_t ret = EFI_NOT_READY;
+
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
+
+	if (enable) {
+		/* It could be enabled only if it is disabled here */
+		if (runtime_disabled) {
+			set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+			runtime_disabled = false;
+			ret = EFI_SUCCESS;
+		}
+	} else {
+		if (efi_enabled(EFI_RUNTIME_SERVICES)) {
+			clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+			runtime_disabled = true;
+			ret = EFI_SUCCESS;
+		}
+	}
+
+	up(&efi_runtime_lock);
+
+	return ret;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ccbc35479684a..98b76008fd426 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1109,6 +1109,7 @@ extern void efi_call_virt_check_flags(unsigned long flags, const void *caller);
 extern unsigned long efi_call_virt_save_flags(void);
 
 void efi_runtime_assert_lock_held(void);
+efi_status_t efi_runtime_set_enable_flag(bool enable);
 
 enum efi_secureboot_mode {
 	efi_secureboot_mode_unset,
-- 
2.43.0

