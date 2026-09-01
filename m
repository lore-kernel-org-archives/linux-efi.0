Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DDE34854E9;
	Tue,  1 Sep 2026 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281854; cv=none; b=q05X5U8I0aO8bh5DZCf2fXiq7pjmBz8xQ/Sol/leNNkQ6R+1tn8OCQFeUzcT2DcV0O5YF7AXao/jcKwOQPKZnBHhcMtlwg3avhS7otfcFc80H8i2QCqECJrMRs271EVDbskgDR9spNU+gSA1asXUK9HOEslkErsx81L7PE+sflo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281854; c=relaxed/simple;
	bh=S2Dt3VCKZlPDBnXFbLzMG+pmQmPlj2Atkjq5lqR6CWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPYSqctWPDL99JqdhtZ7vSwP1xu6N7VrqSQHfMNGEqTFz0XbQVr0s0zQOlwPW3nC4jTGHh6cUGTEJNe3PlxB9NljWgR0DuEtj85laW8OLHCQINlDCst5vV4IQ0q1LLMJYz7v5G//Df9yGqe7NMA9qkwFE5OoTAqfRpTiFuDHALA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=QL94u6KX; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="QL94u6KX"
Received: by linux.microsoft.com (Postfix, from userid 1130)
	id E579F20B7136; Tue,  1 Sep 2026 09:56:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E579F20B7136
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788281814;
	bh=Hpw3uP2WjGzMTwKeoL5pQcN469geeudvRdcHZ29vy1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QL94u6KX39PrItpwS2B/Qhhi1IIUvys+QiLJMrMnu7W6O1xzlVlxNsw+ptOvZ8/Br
	 Ux4sYuVzzM2agoyp5t473tqttqq7HtQUrB63B5XctW7CpH1dhurwdoaCxhgogORhOW
	 7lb6U1j3vAxvG/cNA2se5oqLek1nG4ruDxq+pVgM=
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
Subject: [RFC PATCH 05/12] include: hyperv: hvgdk_mini.h: Add VTL-specific structures and bits
Date: Tue,  1 Sep 2026 09:55:19 -0700
Message-ID: <20260901165647.3160413-6-tgopinath@linux.microsoft.com>
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

Add the definitions needed by the upcoming VSM / VTL1 bring-up code:

  - HV_ACCESS_VSM and HV_ACCESS_VP_REGS partition privilege bits
  - HVCALL_ENABLE_PARTITION_VTL and
    HVCALL_MODIFY_VTL_PROTECTION_MASK hypercall IDs
  - hv_input_enable_partition_vtl input structure and its flags union
  - hv_register_vsm_{partition_status,vp_status} register layout unions
  - HV_REGISTER_VSM_PARTITION_STATUS and
    HV_REGISTER_VSM_VP_SECURE_CONFIG_VTL0 register names

Definitions taken from the Hyper-V TLFS.

Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
---
 include/hyperv/hvgdk_mini.h | 46 +++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/include/hyperv/hvgdk_mini.h b/include/hyperv/hvgdk_mini.h
index 6a4e8b9d570fd..a50af532fc7f9 100644
--- a/include/hyperv/hvgdk_mini.h
+++ b/include/hyperv/hvgdk_mini.h
@@ -303,6 +303,8 @@ union hv_hypervisor_version_info {
 #define HV_ACCESS_STATS					BIT(8)
 #define HV_DEBUGGING					BIT(11)
 #define HV_CPU_MANAGEMENT				BIT(12)
+#define HV_ACCESS_VSM					BIT(16)
+#define HV_ACCESS_VP_REGS				BIT(17)
 #define HV_ENABLE_EXTENDED_HYPERCALLS			BIT(20)
 #define HV_ISOLATION					BIT(22)
 
@@ -438,6 +440,8 @@ union hv_vp_assist_msr_contents {	 /* HV_REGISTER_VP_ASSIST_PAGE */
 #define HVCALL_GET_LOGICAL_PROCESSOR_RUN_TIME		0x0004
 #define HVCALL_NOTIFY_LONG_SPIN_WAIT			0x0008
 #define HVCALL_SEND_IPI					0x000b
+#define HVCALL_MODIFY_VTL_PROTECTION_MASK		0x000c
+#define HVCALL_ENABLE_PARTITION_VTL			0x000d
 #define HVCALL_ENABLE_VP_VTL				0x000f
 #define HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX		0x0013
 #define HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX		0x0014
@@ -878,6 +882,46 @@ struct hv_init_vp_context {
 	u64 msr_cr_pat;
 } __packed;
 
+union hv_enable_partition_vtl_flags {
+	u8 as_uint8;
+	struct {
+		u8 enable_mbec:1;
+		u8 enable_supervisor_shadow_stack:1;
+		u8 enable_hardware_hvpt:1;
+		u8 reserved:5;
+	};
+} __packed;
+
+struct hv_input_enable_partition_vtl {
+	u64					partition_id;
+	union hv_input_vtl			target_vtl;
+	union hv_enable_partition_vtl_flags	flags;
+	u16					rsvd_z16;
+	u32					rsvd_z32;
+} __packed;
+
+union hv_register_vsm_partition_status {
+	u64 as_uint64;
+	struct {
+		u64 enabled_vtl_set : 16;
+		u64 max_vtl : 4;
+		u64 mbec_enabled_vtl_set: 16;
+		u64 supervisor_shadow_stack_enabled_vtl_set : 4;
+		u64 reserved : 24;
+	};
+} __packed;
+
+union hv_register_vsm_vp_status {
+	u64 as_uint64;
+	struct {
+		u64 active_vtl : 4;
+		u64 active_mbec_enabled : 1;
+		u64 reserved_z0 : 11;
+		u64 enabled_vtl_set : 16;
+		u64 reserved_z1 : 32;
+	};
+} __packed;
+
 struct hv_enable_vp_vtl {
 	u64				partition_id;
 	u32				vp_index;
@@ -1061,8 +1105,10 @@ enum hv_register_name {
 
 	/* Synthetic VSM registers */
 	HV_REGISTER_VSM_CODE_PAGE_OFFSETS	= 0x000D0002,
+	HV_REGISTER_VSM_PARTITION_STATUS	= 0x000D0004,
 	HV_REGISTER_VSM_CAPABILITIES		= 0x000D0006,
 	HV_REGISTER_VSM_PARTITION_CONFIG	= 0x000D0007,
+	HV_REGISTER_VSM_VP_SECURE_CONFIG_VTL0	= 0x000D0010,
 
 #if defined(CONFIG_X86)
 	/* X64 Debug Registers */
-- 
2.34.1

