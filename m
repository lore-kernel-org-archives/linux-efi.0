Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E0B414DCB;
	Wed,  5 Aug 2026 09:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785923713; cv=none; b=RJBgnNESVF30129Ov+FemgZHb3xecOsOcVXLRLaBHG2RQYl9NQ69DIF5hYmZhnznbTU9t9p3E6WgzmYaQDCRB+xSXNF003rDkAiuV5bAygoBVGUu5V7Q+DvvsZrTDQg50AJBxZhKwMVeMlGefDtHOmr2OzyfXKHwpAW90QDlwds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785923713; c=relaxed/simple;
	bh=42kgk8ku6NfLS+gtLcjyvQYSOd8Pi9hGFBDV8zn0e+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnBRE/V5O4CQdKSYLdvO17ENZ1dI0rR1r4ZU/D9QUvaGI7imolUBhj/pKwLGS/MTMCYSUxYGog6dl3BebkwAvv5VE/KuT0L0e3Yf/vjJoKqH3P1kdmUinMDKAvnGZZwRrpKLmbGhlieg5GFfeS9qeU95uRg9q8p6zf2psjsPMh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g9OhP3tE; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g9OhP3tE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785923712; x=1817459712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=42kgk8ku6NfLS+gtLcjyvQYSOd8Pi9hGFBDV8zn0e+0=;
  b=g9OhP3tE35PEZ1UFHFalCFd6jLM2KDNJI3qi//rCJhA+FwH41YXyBGqr
   gAzWVHA9SjMANtmLdnKc8t//iVG5rnKykJyDsjG98kane8Zu5Q86nUt8B
   GuBsFcWO39nRiu4b8Qb9oMw3vsBCJlN779Q4FSf3lZSUcqyxCGpIu3d0X
   xmuOK55syUL+bGvcEOIgS0QIL9iAgw4YvCPhm9ekkQGlp/5/c/zvk+pBO
   OXzwQh9PZ22uiaN04gTu5vfzuB/NuYITqGw/Yn+kMQt6ox2QX9LS949z+
   4Yyikmd52uiOC3qaIZUkz31xgNihQONCjIow0M4BdRAmIedrApaZ4Uq3J
   A==;
X-CSE-ConnectionGUID: s/bpxoaEQCazptWnXI3cKQ==
X-CSE-MsgGUID: 1BVbJ7LzQsys9nWNTJ8pxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="97140819"
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="97140819"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 02:55:12 -0700
X-CSE-ConnectionGUID: Mobx2ToTQ1CnuzTkDpFKgw==
X-CSE-MsgGUID: rgyq+AAZRMWotbqVGU+DlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="261822987"
Received: from junxiao.bj.intel.com ([10.238.152.69])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 02:55:10 -0700
From: Junxiao Chang <junxiao.chang@intel.com>
To: ardb@kernel.org,
	ilias.apalodimas@linaro.org,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: bigeasy@linutronix.de,
	junxiao.chang@intel.com
Subject: [PATCH] efi: add dynamic control interface for EFI runtime services
Date: Thu,  6 Aug 2026 17:49:01 +0800
Message-ID: <20260806094901.1709381-1-junxiao.chang@intel.com>
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
index 0327a39d31fa5..f57784a815c61 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -401,6 +401,32 @@ static void __init efi_debugfs_init(void)
 static inline void efi_debugfs_init(void) {}
 #endif
 
+static ssize_t efi_dynamic_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", efi_enabled(EFI_RUNTIME_SERVICES));
+}
+
+static ssize_t efi_dynamic_store(struct kobject *kobj, struct kobj_attribute *attr,
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
+static struct kobj_attribute efi_dynamic_attr =
+	__ATTR(dynamic_enable, 0644, efi_dynamic_show, efi_dynamic_store);
+
 static int __init efipostcore_init(void)
 {
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
@@ -446,6 +472,11 @@ static int __init efisubsys_init(void)
 		goto err_destroy_wq;
 	}
 
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && efi.runtime_supported_mask) {
+		if (sysfs_create_file(efi_kobj, &efi_dynamic_attr.attr))
+			pr_warn("unable to register efi dynamic sysfs interface\n");
+	}
+
 	if (efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE |
 				      EFI_RT_SUPPORTED_GET_NEXT_VARIABLE_NAME)) {
 		error = generic_ops_register();
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index da8d296216441..24cd8d0478385 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -602,3 +602,31 @@ void efi_runtime_assert_lock_held(void)
 {
 	WARN_ON(efi_runtime_lock_owner != current);
 }
+
+efi_status_t efi_runtime_set_enable_flag(bool enable)
+{
+	static bool dynamic_disabled;
+	efi_status_t ret = EFI_NOT_READY;
+
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
+
+	if (enable) {
+		/* It could be enabled only if it is disabled here */
+		if (dynamic_disabled) {
+			set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+			dynamic_disabled = false;
+			ret = EFI_SUCCESS;
+		}
+	} else {
+		if (efi_enabled(EFI_RUNTIME_SERVICES)) {
+			clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+			dynamic_disabled = true;
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

