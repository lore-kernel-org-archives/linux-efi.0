Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7602A2C08CF;
	Tue,  1 Sep 2026 16:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281855; cv=none; b=qgGxdD0zXzxQN55yNRNEx/cO3lyoILafUZcqJCASJmnvsmSmlt/auzWcNRRdwMYVn1IOQmW6FpLZOe0LMUyviHKtOgoC1b1NXSoNjGhIsGapiySm8vFbJ4LgnoeL8wwIhIJmqhj09IMseQMvz0PXXqHnDSL+q7HO+P89QK+WFmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281855; c=relaxed/simple;
	bh=PLAM//gH3pC8RtY75QNvI4XuHtIFzX+atB5kQfIBgqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VJIknfmXNhsE0jMqujiECS6l1r/1yxg7dYHNAzkRfK8plzNIN+MTPdroMtQ8n12rxFmkTD6LHq+7kiCNXrR36qGZauZYHYuWPrRmgp/q7OQuiH/tzwlkO0sh4MaywTFekDEGxDoXkB/hcVbE8Ab+K+670Oe2x/061Kcjf/x1dU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=g8NEjFzx; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="g8NEjFzx"
Received: by linux.microsoft.com (Postfix, from userid 1130)
	id 4138D20B7017; Tue,  1 Sep 2026 09:56:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4138D20B7017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788281815;
	bh=ZY/1jnT1S4FvnKm9pAuQgFMfXX15iTnB1CdG+D9HuaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8NEjFzxKEUT2f1QYMKQCOhT9IsYFA5PlPTX04nFGSu2c3iZ1lZRYzbEyuGnjrkr2
	 s604NqHj4AlPuLmqJdpm0Nu79PpnW8+ALOuXP5jLwodZvKD5DjQ3fjhllDxRrLlMyd
	 hMJLXQ8mo9ooFAXbbi9WI7ErGiv72DSR/LKcFkoA=
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
Subject: [RFC PATCH 11/12] drivers: hv: hv_vsm_boot: Boot primary processor in VTL1
Date: Tue,  1 Sep 2026 09:55:25 -0700
Message-ID: <20260901165647.3160413-12-tgopinath@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

With partition-level VTL1 enabled, the secure kernel image loaded,
its initial vCPU context built, and VTL1 enabled on the boot CPU,
the final step of the primary-CPU bring-up is to actually transition
into VTL1 and start executing the secure kernel. Hyper-V restores
the CPU state from the vp_context supplied during VTL1 enablement
when the first vtlcall is issued.

Issue that first vtlcall on the primary CPU, passing the number of
possible CPUs and the location of the secure kernel reserved region
as the VTL1 boot handshake.

Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
---
 drivers/hv/hv_vsm_boot.c | 63 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/hv_vsm_boot.c b/drivers/hv/hv_vsm_boot.c
index abe82e03e1897..c4f15c42df1f6 100644
--- a/drivers/hv/hv_vsm_boot.c
+++ b/drivers/hv/hv_vsm_boot.c
@@ -35,6 +35,15 @@
 
 static void *vsm_skm_va;
 
+/*
+ * By default, when a processor boots in VTL1, we assume that MBEC (Mode-Based Execution Control)
+ * support is also enabled. MBEC distinguishes between user and kernel memory execution permissions.
+ * After the processor boots in VTL1, we verify whether MBEC is actually enabled. If it is not,
+ * we set a global flag to false. This flag is shared across all processors—if any processor fails
+ * to enable MBEC, the system treats MBEC as disabled.
+ */
+static bool hv_vsm_mbec_enabled = true;
+
 static int hv_vsm_get_register(u32 reg_name, u64 *result)
 {
 	struct hv_register_assoc reg = {
@@ -300,6 +309,51 @@ static int __init hv_vsm_get_partition_status(u16 *enabled_vtl_set, u8 *max_vtl,
 	return 0;
 }
 
+static int __init hv_vsm_init_code_page_offsets(void)
+{
+	union hv_register_vsm_page_offsets offsets;
+	u64 result;
+	int ret;
+
+	ret = hv_vsm_get_register(HV_REGISTER_VSM_CODE_PAGE_OFFSETS, &result);
+	if (ret) {
+		pr_err("Failed to read VSM code page offsets: %d\n", ret);
+		return ret;
+	}
+
+	offsets.as_uint64 = result;
+	hv_vsm_init_vtlcall(offsets.vtl_call_offset);
+	return 0;
+}
+
+static int __init hv_vsm_boot_vtl1(void)
+{
+	struct hv_vtlcall_param args = {0};
+	u16 vp_enabled_vtl_set = 0;
+	u8 active_mbec_enabled = 0;
+	int ret;
+	s64 sk_status;
+
+	args.a0 = num_possible_cpus();
+	args.a1 = sk_res.start;
+	args.a2 = resource_size(&sk_res);
+
+	/* Kick start vtl1 boot on the primary cpu. */
+	sk_status = hv_vsm_vtlcall(&args);
+	if (sk_status)
+		pr_warn("VTL1 boot returned status %lld\n", sk_status);
+
+	ret = hv_vsm_get_vp_status(&vp_enabled_vtl_set, &active_mbec_enabled);
+	if (ret)
+		return ret;
+
+	if (!active_mbec_enabled) {
+		pr_err("Failed to enable MBEC for VP0\n");
+		hv_vsm_mbec_enabled = false;
+	}
+	return 0;
+}
+
 static int __init hv_vsm_bootstrap_vtl(void)
 {
 	u16 partition_enabled_vtl_set = 0, partition_mbec_enabled_vtl_set = 0;
@@ -369,7 +423,14 @@ static int __init hv_vsm_bootstrap_vtl(void)
 			return -EINVAL;
 		}
 	}
-	return 0;
+
+	/* Point the vtlcall trampoline at the correct hypercall page offset */
+	ret = hv_vsm_init_code_page_offsets();
+	if (ret)
+		return ret;
+
+	/* Boot primary virtual processor in VTL1 */
+	return hv_vsm_boot_vtl1();
 }
 
 static void __init hv_vsm_get_sk_mem(void)
-- 
2.34.1

