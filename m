Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DCBB484254;
	Tue,  1 Sep 2026 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281854; cv=none; b=UYbQDcEBoLV2hz2kmE4hKZuM8LSYfCjfckNtWha4YX7csNfKPbFsZUjzmArWWzy2dwWWZIHgFFJvG9YOiUZeMrBnFEiMFpIA8y7p/ZNUYC0qOOp7O5QvctpggYtzlb1bZX2UYlJYUBqJL9VzIg1C2akO3ZQQ1/8Ftgo4iw+nO9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281854; c=relaxed/simple;
	bh=5Dk+oy/IIAwKk745x2+ohPD/deYS0xe5TOjqlDR5Dww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5Ama2Jd7xOuuvVVj0cEvzMAaGKpN4ATL1+agEuEbdayUFSd6fpU6tbfA5ZpA4RP4OkU81/A/DIqOwSYVtd+oBrAg3Gkna5HjoZZqJK4o6V8p9L5NJqTc/tnPNfZ3Jv2qj3Eoej6iDbvHzSSR1PtbnephdQN74g7ouZfQGuSrJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Wj22b+m8; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Wj22b+m8"
Received: by linux.microsoft.com (Postfix, from userid 1130)
	id F35C020B7138; Tue,  1 Sep 2026 09:56:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F35C020B7138
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788281815;
	bh=rHauQ5CkArRSzF2IDix3yMncTDgrieA1wSxwg8lpu9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wj22b+m8qm572Qpmlptkc0JlsqJpsl68325zL87knXkvhdUbwK9kxttE53+ZZI+oK
	 XaVFsyfTKyFnAHlqnOs0SW70gsItL3Hgdy03+b9UwArCXKEvv8TFSVExYV4zsppKFk
	 FvxiX9S/gFjnzkxyXOWZes5iF9cR6wVvA/SDKy9I=
From: Thara Gopinath <tgopinath@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	ardb@kernel.org,
	ilias.apalodimas@linaro.org
Cc: James.Bottomley@HansenPartnership.com,
	"longli@microsoft.com--cc=tzimmermann"@suse.de, javierm@redhat.com,
	lszubowi@redhat.com, francescopompo2@gmail.com,
	tgopinath@microsoft.com, x86@kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Thara Gopinath <tgopinath@linux.microsoft.com>
Subject: [RFC PATCH 06/12] drivers: hv: Add VSM boot driver and enable VTL1 at the partition level
Date: Tue,  1 Sep 2026 09:55:20 -0700
Message-ID: <20260901165647.3160413-7-tgopinath@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linux VBS (LVBS) uses Hyper-V's Virtual Secure Mode to run a small
trusted kernel in VTL1 alongside the regular VTL0 kernel, so that
security-sensitive state (e.g. hypervisor-enforced code integrity,
credential isolation) can live behind a higher-privilege boundary
that VTL0 compromise cannot cross. Bringing that up from Linux
requires the VTL0 kernel to drive the VSM setup itself.

Add drivers/hv/hv_vsm_boot.c as the entry point for that sequence.
This first step handles partition-level VTL1 enable only:

  - Probe VSM / VP-register privileges and SynIC availability before
    doing anything.
  - Pin init to the VTL0 boot CPU so VTL1 comes up on the same CPU
    (later patches rely on this).
  - Read HV_REGISTER_VSM_PARTITION_STATUS, and if VTL1 is not already
    enabled, issue HVCALL_ENABLE_PARTITION_VTL with MBEC and confirm
    by re-reading the register.

Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
---
 drivers/hv/Makefile      |   4 +-
 drivers/hv/hv_vsm_boot.c | 178 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 180 insertions(+), 2 deletions(-)
 create mode 100644 drivers/hv/hv_vsm_boot.c

diff --git a/drivers/hv/Makefile b/drivers/hv/Makefile
index 880c570832381..563ebc36d2700 100644
--- a/drivers/hv/Makefile
+++ b/drivers/hv/Makefile
@@ -22,7 +22,7 @@ mshv_vtl-y := mshv_vtl_main.o
 # Code that must be built-in
 obj-$(CONFIG_HYPERV) += hv_common.o
 obj-$(subst m,y,$(CONFIG_MSHV_ROOT)) += hv_proc.o
-ifneq ($(CONFIG_MSHV_ROOT)$(CONFIG_MSHV_VTL),)
+ifneq ($(CONFIG_MSHV_ROOT)$(CONFIG_MSHV_VTL)$(CONFIG_HYPERV_VSM),)
 	obj-y += mshv_common.o
 endif
-obj-$(subst m,y,$(CONFIG_HYPERV_VSM)) += hv_vsm_securekernel.o
+obj-$(subst m,y,$(CONFIG_HYPERV_VSM)) += hv_vsm_securekernel.o hv_vsm_boot.o
diff --git a/drivers/hv/hv_vsm_boot.c b/drivers/hv/hv_vsm_boot.c
new file mode 100644
index 0000000000000..99e4dc8695837
--- /dev/null
+++ b/drivers/hv/hv_vsm_boot.c
@@ -0,0 +1,178 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * VSM boot framework that enables VTL1, loads secure kernel
+ * and boots VTL1.
+ *
+ * Copyright (c) 2023-2025, Microsoft Corporation.
+ *
+ * Author: Thara Gopinath <tgopinath@linux.microsoft.com>
+ *
+ */
+
+#define pr_fmt(fmt) "vsm: " fmt
+
+#include <linux/hyperv.h>
+#include <linux/cpumask.h>
+#include <asm/mshyperv.h>
+#include "mshv.h"
+
+#define HV_VTL1_ENABLE_BIT	BIT(1)
+
+static int hv_vsm_get_register(u32 reg_name, u64 *result)
+{
+	struct hv_register_assoc reg = {
+		.name = reg_name,
+	};
+	union hv_input_vtl input_vtl = {
+		.as_uint8 = 0,
+	};
+	int ret;
+
+	ret = hv_call_get_vp_registers(HV_VP_INDEX_SELF,
+				       HV_PARTITION_ID_SELF,
+				       1, input_vtl, &reg);
+	if (ret)
+		return ret;
+
+	*result = reg.value.reg64;
+	return 0;
+}
+
+static int __init hv_vsm_enable_partition_vtl(void)
+{
+	u64 status = 0;
+	unsigned long flags;
+	struct hv_input_enable_partition_vtl *hvin = NULL;
+
+	local_irq_save(flags);
+
+	hvin = *this_cpu_ptr(hyperv_pcpu_input_arg);
+	memset(hvin, 0, sizeof(*hvin));
+
+	hvin->partition_id = HV_PARTITION_ID_SELF;
+	hvin->target_vtl.as_uint8 = 1;
+	hvin->flags.enable_mbec = 1;
+
+	status = hv_do_hypercall(HVCALL_ENABLE_PARTITION_VTL, hvin, NULL);
+	if (hv_result(status))
+		pr_err("Enable Partition VTL failed. status=0x%x\n",
+		       hv_result(status));
+
+	local_irq_restore(flags);
+
+	return hv_result(status);
+}
+
+static int __init hv_vsm_get_partition_status(u16 *enabled_vtl_set, u8 *max_vtl,
+					      u16 *mbec_enabled_vtl_set)
+{
+	u64 result;
+	int ret;
+	union hv_register_vsm_partition_status vsm_partition_status = { 0 };
+
+	ret = hv_vsm_get_register(HV_REGISTER_VSM_PARTITION_STATUS, &result);
+	if (ret)
+		return ret;
+
+	vsm_partition_status = (union hv_register_vsm_partition_status)result;
+	*enabled_vtl_set = vsm_partition_status.enabled_vtl_set;
+	*max_vtl = vsm_partition_status.max_vtl;
+	*mbec_enabled_vtl_set = vsm_partition_status.mbec_enabled_vtl_set;
+	return 0;
+}
+
+static int __init hv_vsm_bootstrap_vtl(void)
+{
+	u16 partition_enabled_vtl_set = 0, partition_mbec_enabled_vtl_set = 0;
+	u8 partition_max_vtl;
+	int ret;
+
+	/* Check and enable VTL1 at the partition level */
+	ret = hv_vsm_get_partition_status(&partition_enabled_vtl_set, &partition_max_vtl,
+					  &partition_mbec_enabled_vtl_set);
+	if (ret)
+		return ret;
+
+	if (partition_max_vtl < HV_VTL_SECURE) {
+		pr_err("VTL1 is not supported by the partition\n");
+		return -EINVAL;
+	}
+
+	if (partition_enabled_vtl_set & HV_VTL1_ENABLE_BIT) {
+		pr_info("Partition VTL1 is already enabled\n");
+	} else {
+		ret = hv_vsm_enable_partition_vtl();
+		if (ret) {
+			pr_err("Enabling Partition VTL1 failed with status 0x%x\n",
+			       ret);
+			return -EINVAL;
+		}
+		ret = hv_vsm_get_partition_status(&partition_enabled_vtl_set, &partition_max_vtl,
+						  &partition_mbec_enabled_vtl_set);
+		if (ret)
+			return ret;
+		if (!(partition_enabled_vtl_set & HV_VTL1_ENABLE_BIT)) {
+			pr_err("Tried Enabling Partition VTL 1 and still failed\n");
+			return -EINVAL;
+		}
+		if (!partition_mbec_enabled_vtl_set) {
+			pr_err("Tried Enabling Partition MBEC and failed\n");
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+static bool __init vsm_arch_has_vsm_access(void)
+{
+	if (!(ms_hyperv.features & HV_MSR_SYNIC_AVAILABLE))
+		return false;
+	if (!(ms_hyperv.priv_high & HV_ACCESS_VSM))
+		return false;
+	if (!(ms_hyperv.priv_high & HV_ACCESS_VP_REGS))
+		return false;
+	return true;
+}
+
+static int __init hv_vsm_boot_init(void)
+{
+	cpumask_var_t mask;
+	unsigned int boot_cpu;
+	int ret;
+
+	if (!vsm_arch_has_vsm_access())
+		return 0;
+
+	/*
+	 * Copy the current cpu mask and pin rest of the running code to boot cpu.
+	 * Important since we want boot cpu of VTL0 to be the boot cpu for VTL1.
+	 * ToDo: Check if copying and restoring current->cpus_mask is enough
+	 * ToDo: Verify the assumption that cpumask_first(cpu_online_mask) is
+	 * the boot cpu
+	 */
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		panic("Could not allocate cpumask");
+
+	cpumask_copy(mask, &current->cpus_mask);
+	boot_cpu = cpumask_first(cpu_online_mask);
+	set_cpus_allowed_ptr(current, cpumask_of(boot_cpu));
+
+	ret = hv_vsm_bootstrap_vtl();
+	/*
+	 * At this point VTL0 has already advertised VSM support to the
+	 * bootloader/firmware via the Hyper-V OsLoaderIndications EFI
+	 * variable (see the x86-stub change). That signals the platform
+	 * that a trusted VTL1 will be brought up. If we fail to actually
+	 * set VTL1 up here, the partition is left in a state where an
+	 * attacker could race to configure VTL1 themselves and gain a
+	 * higher-privilege foothold than VTL0. Panic rather than continue
+	 * running with that exposure.
+	 */
+	if (ret)
+		panic("VTL1 boot failure caused kernel panic; consult log for more details.\n");
+
+	set_cpus_allowed_ptr(current, mask);
+	free_cpumask_var(mask);
+	return ret;
+}
+device_initcall(hv_vsm_boot_init);
-- 
2.34.1

