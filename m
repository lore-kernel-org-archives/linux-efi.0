Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDEA6485507;
	Tue,  1 Sep 2026 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281855; cv=none; b=aJlFz4aMjdlRmwzuUmUZ3dc1Yii1xIUFKWBjTRd15/vg0vO5vTowyFerPs3EnFDfYq/LbJuKeBrfWrA6fXI3/udGrZ5kYtAkPgAw+I5lKXY1amQfemN9aOVJPS9aJ5vc4dDmfX1FFeQCpf7kiHC93eGWMAvtTGZq2WN5e5igKUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281855; c=relaxed/simple;
	bh=lnl15zYdbgw4AvbUTmF/UF1u8SAdM/W5i85Ngfz8ptw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlyNDXu3eaIEAr6hgX38Oy4AzTOZjpaba2XQ4IQ3iOiw0WW6CrY71nzqq+wDjU20On7aHBV7UfuFmOIIj2jo+wsh67cuX6jMY+ufNSQ0wnQYJOgUH+bCWIAAD54FmXUfGO78HSfzWCSkpswSw4oBX+WmpqJqH4kE9rMoA47fk8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Vlr3xV28; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Vlr3xV28"
Received: by linux.microsoft.com (Postfix, from userid 1130)
	id 264AA20B7007; Tue,  1 Sep 2026 09:56:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 264AA20B7007
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788281815;
	bh=ygiqmv+6eR1BISHHzIGNvCEf/BCpb358EIHFzlwQ96M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vlr3xV28NUa6ZW9/NIYzNFnpSsRvFTD7/ZN41fm61hlBAIwZRM4okCLvLFjRG4FJ/
	 MAFD7Xs/KFTkASBrn5x0KXYDN9bLJ0OqO73dSF/twKPJn8WQlrOf6TvY7B2/eVor7x
	 9PZpk4bQVSlQ8iHCgUrsJXxdU2NMcwxrfowTMmV0=
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
	Thara Gopinath <tgopinath@linux.microsoft.com>,
	Stanislav Kinsburskii <stanislav.kinsburskii@gmail.com>
Subject: [RFC PATCH 09/12] drivers: hv: hv_vsm_boot: Enable VTL1 on the boot processor
Date: Tue,  1 Sep 2026 09:55:23 -0700
Message-ID: <20260901165647.3160413-10-tgopinath@linux.microsoft.com>
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

With the partition-level VTL1 enabled and the secure kernel image loaded
into the reserved region, the next step is to enable VTL1 on the boot
virtual processor so that the hypervisor can dispatch it into the secure
kernel entry point.

Introduce two helpers in hv_vsm_boot.c:

  - hv_vsm_get_vp_status() reads HV_REGISTER_VSM_VP_STATUS.
  - hv_vsm_enable_vp_vtl() issues HVCALL_ENABLE_VP_VTL with an initial
    vCPU context built via hv_vsm_arch_init_vp().

Extend hv_vsm_bootstrap_vtl() to enable VTL1 on the boot VP if it is
not already enabled, and re-query the status to confirm the transition.

Signed-off-by: Stanislav Kinsburskii <stanislav.kinsburskii@gmail.com>
Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
---
 drivers/hv/hv_vsm_boot.c | 73 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 71 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv_vsm_boot.c b/drivers/hv/hv_vsm_boot.c
index dc20f935da5b2..abe82e03e1897 100644
--- a/drivers/hv/hv_vsm_boot.c
+++ b/drivers/hv/hv_vsm_boot.c
@@ -216,6 +216,47 @@ static int __init hv_vsm_load_secure_kernel(Elf64_Addr *sk_entry_pa)
 	return ret;
 }
 
+static int __init hv_vsm_enable_vp_vtl(Elf64_Addr sk_entry_pa)
+{
+	u64 status = 0;
+	unsigned long flags;
+	struct hv_enable_vp_vtl *hvin;
+
+	local_irq_save(flags);
+
+	hvin = *this_cpu_ptr(hyperv_pcpu_input_arg);
+	memset(hvin, 0, sizeof(*hvin));
+
+	hvin->partition_id = HV_PARTITION_ID_SELF;
+	hvin->vp_index = HV_VP_INDEX_SELF;
+	hvin->target_vtl.target_vtl = HV_VTL_SECURE;
+
+	hv_vsm_arch_init_vp(&hvin->vp_context, sk_entry_pa, sk_res.start);
+
+	status = hv_do_hypercall(HVCALL_ENABLE_VP_VTL, hvin, NULL);
+
+	local_irq_restore(flags);
+
+	return hv_result(status);
+}
+
+static int __init hv_vsm_get_vp_status(u16 *enabled_vtl_set, u8 *active_mbec_enabled)
+{
+	u64 result;
+	int ret;
+	union hv_register_vsm_vp_status vsm_vp_status = { 0 };
+
+	ret = hv_vsm_get_register(HV_REGISTER_VSM_VP_STATUS, &result);
+	if (ret)
+		return ret;
+
+	vsm_vp_status = (union hv_register_vsm_vp_status)result;
+	*enabled_vtl_set = vsm_vp_status.enabled_vtl_set;
+	*active_mbec_enabled = vsm_vp_status.active_mbec_enabled;
+
+	return 0;
+}
+
 static int __init hv_vsm_enable_partition_vtl(void)
 {
 	u64 status = 0;
@@ -262,7 +303,8 @@ static int __init hv_vsm_get_partition_status(u16 *enabled_vtl_set, u8 *max_vtl,
 static int __init hv_vsm_bootstrap_vtl(void)
 {
 	u16 partition_enabled_vtl_set = 0, partition_mbec_enabled_vtl_set = 0;
-	u8 partition_max_vtl;
+	u16 vp_enabled_vtl_set = 0;
+	u8 partition_max_vtl, active_mbec_enabled = 0;
 	Elf64_Addr sk_entry_pa;
 	int ret;
 
@@ -300,7 +342,34 @@ static int __init hv_vsm_bootstrap_vtl(void)
 		}
 	}
 
-	return hv_vsm_load_secure_kernel(&sk_entry_pa);
+	ret = hv_vsm_load_secure_kernel(&sk_entry_pa);
+	if (ret)
+		return ret;
+
+	/* Check and enable VTL1 for the primary virtual processor */
+	ret = hv_vsm_get_vp_status(&vp_enabled_vtl_set, &active_mbec_enabled);
+	if (ret)
+		return ret;
+
+	if (vp_enabled_vtl_set & HV_VTL1_ENABLE_BIT) {
+		pr_info("VP VTL1 is already enabled\n");
+	} else {
+		ret = hv_vsm_enable_vp_vtl(sk_entry_pa);
+		if (ret) {
+			pr_err("Enabling VP VTL1 failed with status 0x%x\n", ret);
+			/* TODO: Should we disable VTL1 at partition level in this case? */
+			return -EINVAL;
+		}
+		ret = hv_vsm_get_vp_status(&vp_enabled_vtl_set, &active_mbec_enabled);
+		if (ret)
+			return ret;
+
+		if (!(vp_enabled_vtl_set & HV_VTL1_ENABLE_BIT)) {
+			pr_err("Tried Enabling VP VTL1 and still failed\n");
+			return -EINVAL;
+		}
+	}
+	return 0;
 }
 
 static void __init hv_vsm_get_sk_mem(void)
-- 
2.34.1

