Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2286113C918;
	Fri,  3 Jul 2026 00:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783039204; cv=none; b=g5uJswKs4CdRLkrz4h9CqzwOF25xz+gWIs3Nt5NSG5Z9OzmTjw1JMKw19ruwUcBJtaQ5Ngo/lLcq734j2orPWToVPPDQ30HMee89eiC7cjoubhNUI9jkyw1ONKaesi+MSAZ+8BZWL8IVoHB0BaQQZ1yf8efkSaiPmYOAh8YO9q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783039204; c=relaxed/simple;
	bh=WphSfNuhWIbNhvb8JfM9MwRmFV4W3Ca596Mp7xRkXBY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JmWCytr0t+w+hNr0ZButLHPgAHKbUO6G1SrHqE4pDhs9cgF4SFqE8iCoqE+qEurdMIDlVrFFkStDa3EZGXy3wG1OOfowgBetzzyQ3EnryrqMRup1kF5CDSOiiz4DUixkwzgBvQkt8xLUoNRNSZiTfOjVlWOAM6JYAijfaOxdBxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MJkHuKCM; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MJkHuKCM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783039202; x=1814575202;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WphSfNuhWIbNhvb8JfM9MwRmFV4W3Ca596Mp7xRkXBY=;
  b=MJkHuKCM2Lj/FFflqMpuk2IIHfmh04Xk8fAWkHlPewZrQ1pPib3reehl
   DaXnjQ4H17g9fsbsuA6TrI8drrQlwXXzySo3dVItfGtris+e1SGpOV2ls
   fTRTbMBZ90uBGO97ZQak59ssoLBTtOxgNLc+zw0yk5awObiXaVhoj4EXc
   D6nNX8sphPB9IzeCkmeCsVny+94+ycPh4hZol4gnDGozLP2J1rsfirAw4
   da4MVl09DsctPl8icyZyXTKyn5E1jS2+V2OlRFUHjaJ8Mofyw87cfHd4a
   88RekCQFtAy2A8TTBeenu/J1+2UZpVChPOrlHcFu+KZsXXlEYwKmBZ0mv
   Q==;
X-CSE-ConnectionGUID: SkXTbybrTFOLeijQaGlskw==
X-CSE-MsgGUID: WAoD/AqASyCkZbPf+L+a9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="94150638"
X-IronPort-AV: E=Sophos;i="6.25,144,1779174000"; 
   d="scan'208";a="94150638"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 17:40:02 -0700
X-CSE-ConnectionGUID: VjIwKFdsSxe/7s39diUiFg==
X-CSE-MsgGUID: 5YvBqIatT/GyHEz5ytUb3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,144,1779174000"; 
   d="scan'208";a="250329284"
Received: from junxiao.bj.intel.com ([10.238.152.69])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 17:39:59 -0700
From: Junxiao Chang <junxiao.chang@intel.com>
To: ardb@kernel.org,
	ilias.apalodimas@linaro.org,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: -cc=junxiao.chang@intel.com
Subject: [PATCH] mefi: add dynamic control interface for EFI runtime services
Date: Sat,  4 Jul 2026 08:33:41 +0800
Message-ID: <20260704003341.3923900-1-junxiao.chang@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an interface to dynamically enable or disable EFI runtime
services at runtime. By default, EFI runtime services remain
enabled, but they can be temporarily disabled to improve real-time
latency.

Currently, EFI runtime services are typically disabled on RT
systems using kernel parameters such as "noefi" or "efi=disable".
However, this permanently disables EFI services, preventing use
cases such as UEFI firmware updates.

With this change, EFI runtime services can be disabled during
execution of real-time workloads and re-enabled afterwards,
allowing better balance between real-time performance and firmware
service availability.

Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
---
 .../admin-guide/kernel-parameters.txt         |  5 ++-
 drivers/firmware/efi/efi.c                    | 39 +++++++++++++++++++
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b5493a7f8f228..533213101f808 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1595,7 +1595,8 @@ Kernel parameters
 	efi=		[EFI,EARLY]
 			Format: { "debug", "disable_early_pci_dma",
 				  "nochunk", "noruntime", "nosoftreserve",
-				  "novamap", "no_disable_early_pci_dma" }
+				  "novamap", "no_disable_early_pci_dma",
+				  "dynamic" }
 			debug: enable misc debug output.
 			disable_early_pci_dma: disable the busmaster bit on all
 			PCI bridges while in the EFI boot stub.
@@ -1612,6 +1613,8 @@ Kernel parameters
 			novamap: do not call SetVirtualAddressMap().
 			no_disable_early_pci_dma: Leave the busmaster bit set
 			on all PCI bridges while in the EFI boot stub
+			dynamic: enable EFI runtime services, which can be
+			disabled via /sys/firmware/efi/dynamic_enable.
 
 	efi_no_storage_paranoia [EFI,X86,EARLY]
 			Using this parameter you can use more than 50% of
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 0327a39d31fa5..18d5d99fab821 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -81,6 +81,7 @@ struct mm_struct efi_mm = {
 
 struct workqueue_struct *efi_rts_wq;
 
+static bool efi_in_dynamic __initdata;
 static bool disable_runtime = IS_ENABLED(CONFIG_EFI_DISABLE_RUNTIME);
 static int __init setup_noefi(char *arg)
 {
@@ -115,6 +116,11 @@ static int __init parse_efi_cmdline(char *str)
 	if (parse_option_str(str, "runtime"))
 		disable_runtime = false;
 
+	if (parse_option_str(str, "dynamic")) {
+		disable_runtime = false;
+		efi_in_dynamic = true;
+	}
+
 	if (parse_option_str(str, "nosoftreserve"))
 		set_bit(EFI_MEM_NO_SOFT_RESERVE, &efi.flags);
 
@@ -401,6 +407,34 @@ static void __init efi_debugfs_init(void)
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
+	if (enable)
+		set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+	else {
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+		if (efi_rts_wq)
+			flush_workqueue(efi_rts_wq);
+	}
+
+	return count;
+}
+static struct kobj_attribute efi_dynamic_attr =
+	__ATTR(dynamic_enable, 0644, efi_dynamic_show, efi_dynamic_store);
+
 static int __init efipostcore_init(void)
 {
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
@@ -446,6 +480,11 @@ static int __init efisubsys_init(void)
 		goto err_destroy_wq;
 	}
 
+	if (efi_in_dynamic && efi.runtime_supported_mask) {
+		if (sysfs_create_file(efi_kobj, &efi_dynamic_attr.attr))
+			pr_warn("unable to register efi dynamic sysfs interface\n");
+	}
+
 	if (efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE |
 				      EFI_RT_SUPPORTED_GET_NEXT_VARIABLE_NAME)) {
 		error = generic_ops_register();
-- 
2.43.0

