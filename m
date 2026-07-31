Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A02E3B27F7;
	Thu, 30 Jul 2026 06:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785393030; cv=none; b=JvZxcD2C0+3MOmROnjzBt3xjlgUzB1uB5d/rXzKAbfm83ElGg6Id/nAcZf6moEECIh7n1euYsz+VNia/vkACfg8j1BaHcNW+aWODOrJQnlVunNaIK6jQHMr+OIEXMIiwBQIlliArnJCB2smZ9SzW7o8nuVYf+98KEpebvz/XRIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785393030; c=relaxed/simple;
	bh=NZArUfPvS37aqM9pvd6b4Aj+9b7uqENuPYTItn+5Rsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3MhxHAACSdHxWL041vHWX93AebWiNUWylLeM8ZdKLHdEXKcqL3MuO643MO5w6ew0sqmR1NyXMcP5wJFkbySJGOZacKgVTB1lpYby2CD7sC3mU17QXeOeJ7L5yg26RA5s1Hb+qQUQXsSNfv9l3xLzZ8sKkw79K0SFZKDx4G+/Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UPPyZSiU; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UPPyZSiU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785393028; x=1816929028;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NZArUfPvS37aqM9pvd6b4Aj+9b7uqENuPYTItn+5Rsw=;
  b=UPPyZSiU2/GcVOAX88wrvh+cQZUpje+EL5C2Xe2S9rGMKb+rHmYhICp9
   tH0lL1VgTlGyPRoTf8rFPa/ITV52E2oYyOspvmTYn1tiQirTmaPJZchm7
   uDBlfjrGAxaGKnhppIK7apIKKL33Wt2dkVCk0jy/HPz3I1l0XLvhBg7DS
   S1k8DXfwYiyYNyMOSuRzEnE42nIe169vPDk42bMjSnUOlDmGO7IMRKRPN
   PO22gHpSIAk+NA1Vf1CvdURPnfQ/Azb6lYvmHchNpKi86a5VLe5SKlBJO
   9Iy+3MG/H0HVzAAvXW9lOjX89Cyhv+32XG3G1OBbrcwR4mddNoe7TN4Au
   A==;
X-CSE-ConnectionGUID: IqMq3gUMQ7+Mko07tKydpg==
X-CSE-MsgGUID: sseVTkMfQkeQeZkHoSo4bQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="88543507"
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="88543507"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 23:30:26 -0700
X-CSE-ConnectionGUID: 9u8jWPcKRs2P848Do+0W7Q==
X-CSE-MsgGUID: BS1lLcMrSnm5GWNSqh7NmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="298429773"
Received: from junxiao.bj.intel.com ([10.238.152.69])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 23:30:24 -0700
From: Junxiao Chang <junxiao.chang@intel.com>
To: ardb@kernel.org,
	ilias.apalodimas@linaro.org,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: bigeasy@linutronix.de,
	junxiao.chang@intel.com
Subject: [PATCH] efi: add dynamic control interface for EFI runtime services
Date: Fri, 31 Jul 2026 14:24:23 +0800
Message-ID: <20260731062423.639771-1-junxiao.chang@intel.com>
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
 drivers/firmware/efi/runtime-wrappers.c | 15 ++++++++++++
 include/linux/efi.h                     |  1 +
 3 files changed, 47 insertions(+)

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
index da8d296216441..8d1554714e3f4 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -602,3 +602,18 @@ void efi_runtime_assert_lock_held(void)
 {
 	WARN_ON(efi_runtime_lock_owner != current);
 }
+
+efi_status_t efi_runtime_set_enable_flag(bool enable)
+{
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
+
+	if (enable)
+		set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+	else
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+
+	up(&efi_runtime_lock);
+
+	return EFI_SUCCESS;
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

