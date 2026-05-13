Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2605D3E5588
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778661870; cv=none; b=IrFV1vm9qgEYeDWQ0hUJYfF2IBAnZFlD9B1e0WcqmQaatfGO4Ij0AZvZoS9y4UUGZltvOnswRuxHvVLFJ1Yzv7NXCK/2pt3PE40BwfjGwT1O29XtDGOCeArgYJt/eb3kc9578VLRIraT7yxSZdzMyjO8P26OmLNyRyrxsFSVa9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778661870; c=relaxed/simple;
	bh=RbO1hZySTcpeqfT1OpALJtOaef3hmokwaW+RC72Ep7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBmivU9bvW3GblPtfTjMcdre96Ay4kYI7lsJgBw60N5uCKMa0cgMUwk5r0FYlJSwCTWITuW80UEdd3eO+H5TZaC+yNQSDZK5dusCm6zFj6CYU4TeV+WZhpv6fgYbFhlWtcjYfxyHdE7AKyeeSCfCIURotpc76b4i7Y61WC/xAjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=X4lVN1xq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QN3/jt4f; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="X4lVN1xq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QN3/jt4f"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64D5JjsD1393359
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=ewmAIgvqude
	m6foGMLA49zaPAzwEB58f49bB7peXZKM=; b=X4lVN1xqk/XVZG6sjDtsXx+B7o3
	twyEsZHNiIcE7JF9szlfsVRR6JAi9PbmO8mWej86qGUuRhvWz24HdzbGYIxxZKhY
	QuJ9tJDQALJHlZZgI0srhIs++H/l6egzv5uMI7Kjtk+G7/xQtt8teZ+KFBEwPTEJ
	h5bpHetYGdEsOuW2CwP57c9//ICdHsTetDMObbP9wxU14EO+btpQEOuq/cJRFVhS
	fsIPQDr6fYjKz35ExXF4avNBSv4R3jmrFXYK4+oRn5uwod964E7NS8ZKoGZluGxF
	+6UUCxf/LxBQ/22TL4q2MN8DclT1Op3RoN04ULivBvq1NFOSHaDpU+uUnHw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e4k260srt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:28 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b461b36990so69567355ad.3
        for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 01:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778661868; x=1779266668; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ewmAIgvqudem6foGMLA49zaPAzwEB58f49bB7peXZKM=;
        b=QN3/jt4fB1hQXnzUbFkIjzSIDwzxjUG5WCZMVLpe6cgrxt+q4Cb/Bm8T7rSqPgK8gG
         8tGyf1qb6VmXsBBSjMcKphEuhqm2QvSQNvc7zk+5MhjoDx25Nghi7ca5fRUl3+HSQXer
         YF02/VBWCmXQm4m3nZjJTWw/LerTyOWQoUvanAIwriP1gU28n/GatxaJjPmIUD9yqX4s
         oviG2/2RD5JDxF3QIZ3y5hBXDMERB/VdZPbtEjehU08aysyS/NKYdKAtCjonVlmSNYyr
         evHbzClu+16wPybaOa4Zqwv2Dj5OFtUL0+hNWBfy9lawG2Xfh3avozAZXzoBh4a1g7xJ
         k15g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778661868; x=1779266668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ewmAIgvqudem6foGMLA49zaPAzwEB58f49bB7peXZKM=;
        b=UeDziYNPkunSjbxTy4elwieWJLb0o473bwGKmq2620Sbx9CvxPRTFDnTFUpsLM00wF
         vOUc2KUO6Udjrj3OSJ2emZjHetnd8H96fdxtaQSKSWB/gDcHJXF5yb8eWHZBaofEunKv
         DMsVBV1Vjman5wjBzhXd/YtsVORX5DqYdSTNXhfEXBsc95SmVT1XmRqt3PZea3C6OrGB
         pebinkIP7gViAte/cwbppnfVqIEX3jV6awAQcqL43ux7XqlnnrzTFFS6/sT8oKtBFatm
         wKxRRhBJIyJZ3wfM+iFkZvSu5GTC0mYI8qyjmUq7HB9/IoSdwUHlNk9Q+ZSymUdLimOZ
         WTjQ==
X-Forwarded-Encrypted: i=1; AFNElJ8aTSgL2FXTNcpeI9W0HsYg/qXCxmYKSJPvtHgi9SivNuXRWsJjUOC1bNQn/s5uVRmWpEm2arrfrTM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8zQxQMVen07g15vhs52x1uONyHPtUe03XRb20AfBybFzN+S7o
	F5uygzgZGNKh7OXtbMjhSiBPpQDi+kHTx1IqDJtdYZVy+h+vvQZ+6wtZl9McRf8lU8ebPiYd9Qx
	ut6KzCVixlwBur+SQkgPpbuQo75NEXSOXDxDlU72dzu86CpDLuhS/xJBnUaFaDGc=
X-Gm-Gg: Acq92OF+byLdbDOez/HcZQnP1I8Si8ZqDqxc1CxTXd2gxhNDtPiSCnMDIZJP9o9knGc
	Qf8R85jGme8sbE6IriFsI/Sos0CPicG9r5D9tt7frFRRffK0A7JfBlTUZMk3PU7zICowf14MhIG
	Ikx7Qtp0TacJYmzDphW2LFaIE6nnMDXSnm9mnsBxUXxpzBbZcJYy0vdHIA+Zw8bLLy6gWJKvu6H
	u+K1SF4S41AYYnjXhuUviCEyZtOLHlUygCR4aWgZf/uqf/MNjXabVwwEO8KFUakziQfokevI+Se
	bZA6iBQIiFvh4uoYYJZys9G00bV/5HB+ZA+NOtdf+f20KDTmtwqfbDP9QoZxh/0beEI8dP8Bf1h
	s6C5t17yDzX5D3Ud7V7LLyt7rUbvKlczIdt675yNUeaJ9ImSZQOS/jRQpPHe9gZQOoACFMEPfHT
	s5Q2KMHaS5tjfCbMuyiS33a8zqd4ITqZKMk4VVa0PABSifUg==
X-Received: by 2002:a17:903:906:b0:2b2:4029:d77c with SMTP id d9443c01a7336-2bd27295b2amr28364105ad.23.1778661867638;
        Wed, 13 May 2026 01:44:27 -0700 (PDT)
X-Received: by 2002:a17:903:906:b0:2b2:4029:d77c with SMTP id d9443c01a7336-2bd27295b2amr28363715ad.23.1778661867179;
        Wed, 13 May 2026 01:44:27 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2709bsm169158725ad.5.2026.05.13.01.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 01:44:26 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org,
        acpica-devel@lists.linux.dev, paul.walmsley@sifive.com,
        palmer@dabbelt.com, lenb@kernel.org, james.morse@arm.com,
        tony.luck@intel.com, ardb@kernel.org, conor@kernel.org,
        cleger@rivosinc.com, robert.moore@intel.com, sunilvl@oss.qualcomm.com,
        anup.patel@oss.qualcomm.com
Cc: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v4 08/10] riscv: Introduce HEST SSE notification handlers
Date: Wed, 13 May 2026 14:13:23 +0530
Message-ID: <20260513084325.2176952-9-himanshu.chauhan@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513084325.2176952-1-himanshu.chauhan@oss.qualcomm.com>
References: <20260513084325.2176952-1-himanshu.chauhan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=M/l97Sws c=1 sm=1 tr=0 ts=6a0439ec cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=QyXUC8HyAAAA:8 a=Eu4eB5ymJzOrEwSPfFIA:9 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDA4OSBTYWx0ZWRfX+GGFq1mXlRdf
 GHHT6O/re21UWFOxOeFeSrPysCBpfboLOkUyL8Bx1WHzWIuB5HGQF5Yfx2X7+rEzKRoet/v9vyP
 lMfeVgiimKOqOcbQCa4J2lqRRqG96Cjvb3nfIR7hFcEFGGo25zMPPIjEVGuDTgFim6VBtNqEBOh
 JuahmuVPzNNKBjQp42n3OVg5LfdEAWlvJ0GF/mAVshsmvubvP/v8tdVDhYfsHu++o5KAfKByFiw
 D5aZEleuQeMSqByMqEMHZvN9reqCixgDGl8i0Ia0sw04eKS+4mK+Gt5p1b9MNh2msPdPBNMwUD1
 Aakk0VjYmzYwqPYZxWHhjfzyaf4QgRTisJrORgW7W4fFkyyGhBWaFT6hjD0OdnHC4dQk14+FzgM
 hI4gB9z1nCsZ1FxxlFks3msn15BwIE74+wAxbcKvJiQ/pOvBOovAbR5bPA6k0Cb0l7q/FZSX0zy
 rAkYuWA/zlFIaDZw2Qg==
X-Proofpoint-ORIG-GUID: IXJQpe0LDPbLXhOj-kYHXWmLunDaWJ-L
X-Proofpoint-GUID: IXJQpe0LDPbLXhOj-kYHXWmLunDaWJ-L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0 suspectscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605130089

Add config option to enable SSE in APEI. When it is enabled, functions
to register/unregister a ghes entry with SSE are avilable along with
low and high priority event handers. If a SSE notification type is
determined, a ghes common handler to handle an error event is registered.

Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 drivers/acpi/apei/Kconfig |  5 ++
 drivers/acpi/apei/ghes.c  | 99 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 93 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index 428458c623f0..895a843d0e36 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -46,6 +46,11 @@ config ACPI_APEI_SEA
 	depends on ARM64 && ACPI_APEI_GHES
 	default y
 
+config ACPI_APEI_SSE
+	bool
+	depends on RISCV && RISCV_SBI_SSE && ACPI_APEI_GHES
+	default y
+
 config ACPI_APEI_MEMORY_FAILURE
 	bool "APEI memory error recovering support"
 	depends on ACPI_APEI && MEMORY_FAILURE
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 8edc2c8db1bb..1baa8ddd10ea 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -17,6 +17,8 @@
  *   Author: Huang Ying <ying.huang@intel.com>
  */
 
+#include <linux/err.h>
+#include <linux/riscv_sbi_sse.h>
 #include <linux/arm_sdei.h>
 #include <linux/kernel.h>
 #include <linux/moduleparam.h>
@@ -100,6 +102,11 @@
 #define FIX_APEI_GHES_SDEI_CRITICAL	__end_of_fixed_addresses
 #endif
 
+#ifndef CONFIG_RISCV_SBI_SSE
+#define FIX_APEI_GHES_SSE_LOW_PRIORITY	__end_of_fixed_addresses
+#define FIX_APEI_GHES_SSE_HIGH_PRIORITY	__end_of_fixed_addresses
+#endif
+
 static ATOMIC_NOTIFIER_HEAD(ghes_report_chain);
 
 static inline bool is_hest_type_generic_v2(struct ghes *ghes)
@@ -1662,6 +1669,63 @@ static int apei_sdei_unregister_ghes(struct ghes *ghes)
 	return sdei_unregister_ghes(ghes);
 }
 
+#if defined(CONFIG_ACPI_APEI_SSE)
+/* SSE Handlers */
+static int __ghes_sse_callback(struct ghes *ghes,
+			       enum fixed_addresses fixmap_idx)
+{
+	if (!ghes_in_nmi_queue_one_entry(ghes, fixmap_idx)) {
+		irq_work_queue(&ghes_proc_irq_work);
+
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+/* Low priority */
+static int ghes_sse_lo_callback(u32 event_num, void *arg, struct pt_regs *regs)
+{
+	static DEFINE_RAW_SPINLOCK(ghes_notify_lock_sse_lo);
+	struct ghes *ghes = arg;
+	int err;
+
+	raw_spin_lock(&ghes_notify_lock_sse_lo);
+	err = __ghes_sse_callback(ghes, FIX_APEI_GHES_SSE_LOW_PRIORITY);
+	raw_spin_unlock(&ghes_notify_lock_sse_lo);
+
+	return err;
+}
+
+/* High priority */
+static int ghes_sse_hi_callback(u32 event_num, void *arg, struct pt_regs *regs)
+{
+	static DEFINE_RAW_SPINLOCK(ghes_notify_lock_sse_hi);
+	struct ghes *ghes = arg;
+	int err;
+
+	raw_spin_lock(&ghes_notify_lock_sse_hi);
+	err = __ghes_sse_callback(ghes, FIX_APEI_GHES_SSE_HIGH_PRIORITY);
+	raw_spin_unlock(&ghes_notify_lock_sse_hi);
+
+	return err;
+}
+
+static int apei_sse_register_ghes(struct ghes *ghes)
+{
+	return sse_register_ghes(ghes, ghes_sse_lo_callback,
+				 ghes_sse_hi_callback);
+}
+
+static int apei_sse_unregister_ghes(struct ghes *ghes)
+{
+	return sse_unregister_ghes(ghes);
+}
+#else /* CONFIG_ACPI_APEI_SSE */
+static int apei_sse_register_ghes(struct ghes *ghes) { return -EOPNOTSUPP; }
+static int apei_sse_unregister_ghes(struct ghes *ghes) { return -EOPNOTSUPP; }
+#endif
+
 static int ghes_probe(struct platform_device *ghes_dev)
 {
 	struct acpi_hest_generic *generic;
@@ -1708,6 +1772,14 @@ static int ghes_probe(struct platform_device *ghes_dev)
 		pr_warn(GHES_PFX "Generic hardware error source: %d notified via local interrupt is not supported!\n",
 			generic->header.source_id);
 		goto err;
+	case ACPI_HEST_NOTIFY_SSE:
+		if (!IS_ENABLED(CONFIG_ACPI_APEI_SSE)) {
+			pr_warn(GHES_PFX "Generic hardware error source: %d notified via SSE is not supported\n",
+				generic->header.source_id);
+			rc = -EOPNOTSUPP;
+			goto err;
+		}
+		break;
 	default:
 		pr_warn(FW_WARN GHES_PFX "Unknown notification type: %u for generic hardware error source: %d\n",
 			generic->notify.type, generic->header.source_id);
@@ -1775,6 +1847,17 @@ static int ghes_probe(struct platform_device *ghes_dev)
 		if (rc)
 			goto err;
 		break;
+
+	case ACPI_HEST_NOTIFY_SSE:
+		rc = apei_sse_register_ghes(ghes);
+		if (rc) {
+			pr_err(GHES_PFX "Failed to register for SSE notification on vector %d\n",
+			       generic->notify.vector);
+			goto err;
+		}
+		pr_err(GHES_PFX "Registered SSE notification on vector %d\n",
+		       generic->notify.vector);
+		break;
 	default:
 		BUG();
 	}
@@ -1804,7 +1887,6 @@ static int ghes_probe(struct platform_device *ghes_dev)
 
 static void ghes_remove(struct platform_device *ghes_dev)
 {
-	int rc;
 	struct ghes *ghes;
 	struct acpi_hest_generic *generic;
 
@@ -1838,16 +1920,11 @@ static void ghes_remove(struct platform_device *ghes_dev)
 		ghes_nmi_remove(ghes);
 		break;
 	case ACPI_HEST_NOTIFY_SOFTWARE_DELEGATED:
-		rc = apei_sdei_unregister_ghes(ghes);
-		if (rc) {
-			/*
-			 * Returning early results in a resource leak, but we're
-			 * only here if stopping the hardware failed.
-			 */
-			dev_err(&ghes_dev->dev, "Failed to unregister ghes (%pe)\n",
-				ERR_PTR(rc));
-			return;
-		}
+		apei_sdei_unregister_ghes(ghes);
+		break;
+
+	case ACPI_HEST_NOTIFY_SSE:
+		apei_sse_unregister_ghes(ghes);
 		break;
 	default:
 		BUG();
-- 
2.43.0

