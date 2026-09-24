Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A417432310
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235462; cv=none; b=Y3lwmKWFSsn/DGQh3hZBimw3zSUeb+6bI4Ov64I+1kPTIC/2wodc1ONvq+AWycB8lSfsvoMeFqq4Uzvf6PFJVthx40Kp0toBk+dV9sat5P/CJ8nyIzt3o3j192K++6W1S3K6U6d5tpH5o70shL03p+PK/rZoFE8rz0EIGFOb2aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235462; c=relaxed/simple;
	bh=v8z3bs/wKomA6O762f46n+RIupf/AQfAQtYjTHMBK64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxSJtoD7dP67ZoAEoH1KlUNSYp+eT/M59wRLbzXjGwkycSM8HfKfCCRnGugWxAf0/DfKHuXk4IIvph36z46FKgvIyp70LwaMU+O4O5MYeyUFVWuk4dqFY6ZnDNFBdBSH99qFFz0o5/mzo7O8/3IS6YoTJLNrgbdnkiFE2ka8GLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SGWP3EFX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WCHQh4Re; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SGWP3EFX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WCHQh4Re"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5eJnQ4147924
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:37:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=qPsTlQAM/LB
	nJylXg8OveQ+2HeryYn1OqFxtCZ6vpxA=; b=SGWP3EFXzqW2CbC0eoctGT8Jq2/
	dnut85dn8ztldhowjK0vriSqCD2uXChvmsgOEkhjzSZstsy8/AMhVYNZCwXGF7M3
	e685BogjiciCNsQSPmxw8wRIJlS1TNBahME2++C12ASkU0vNscbqPgYK5AIC07jo
	7Ydn0jcYTq3WBlQGANptp8MpjdbZKe576gW+xm1lwo1TB3FeFprIClMcTMYGrYBS
	iILgMCQe2aLRszr1pdHQXgTEJf+w8z8OPn3DXCdClNv4yZAsYrMLEOFwgvcBCspc
	ssuQ5LDI4ggg2wKyBOXiEr9sN/86/mvInNeaeOnMMwsVJK+dgsOvHA095Kw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvfjv3w36-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:37:40 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3286d2bac04so2110890eec.0
        for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 00:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790235460; x=1790840260; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qPsTlQAM/LBnJylXg8OveQ+2HeryYn1OqFxtCZ6vpxA=;
        b=WCHQh4Rey4zN9tUmHSQ+DZS6y6EZwshhVN32rD5ZjNX+EXMpWZ+mUJPSXSTtYvIYpD
         5HgOlyyUyr1GEJ8dbHJWIMbsaivNVbuDXUCnCo52jZeMyauEMdaIkHsAT9JxZyfugdR3
         cRXmRC2/1ynjvy3sTg1YsLuYdiJF8Ii7+jSopiGxRHj65ms+a/GX0Txis2LjOgjgkr1p
         b5rsiXzmA0I3Pqux74Ny5tt8NmMjKRs3slDqiKbKaQ/ibu5uzTQMfSWI1PNbymGOp8zC
         5yGHJiA5dmYZm0Xtbtkv8CIcO5rpXEWTiRsCdqo9Kwc9CYW/LbjhS5U1A/KrDSEVtMRH
         Wfdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790235460; x=1790840260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qPsTlQAM/LBnJylXg8OveQ+2HeryYn1OqFxtCZ6vpxA=;
        b=N7vXnPaHj9NUFuqaI2efSrvEKQPfVVMFpFkPFHE0Jwa6i9klKyJA8zlbYNylTQN5di
         EQdWXEgo0GKOcbvoaeDm7lcjnUKanHtQ2j7Ts8VAMmwlxCOJymCftQcaN0Ip1m8M+muB
         tRiOEmMtE8EEmCK6iumc2FW2ILLdnBc9ubBtqAw+0X7SNZT7U9VAYyxR/bo7+cB233HS
         +c0LIosDMW1xYCkwl8xksrfc4P7OvfuavOCizJEiHbsRJE7X4s5P5fOPqcRQRU8pfOOG
         Mj2CCtVmoBUriX/E4lwPA0QDFPYq9BazArPc100rP0U4yYKIxr8TZJ7unZJGYv5z9NJS
         n5Hw==
X-Forwarded-Encrypted: i=1; AKwUvBzCEv1RiZf2FqAsDYDiBHmBwlDSLqAyVJ4RV0KZZNS232STWHFYVxKAkKxvioBHvHpnM3a3GBRttv0=@vger.kernel.org
X-Gm-Message-State: AFuF++mNjYys6Oda3FL2v5b9QYJep9reNl/2FIqny626PY/iSzvWfaS0
	P0Yqtxsx5dxQo6BtemWDDycsqX1WAUXS9PJiOEF3XQPk7g6GofKKfUZDe4S7xhArTKOG/ewLFpc
	gEmFk926TudijWgGLfMQuyVVz/ANBxVjvAA71QFAGv+gwk803uJ0rOXdYAveDiKY=
X-Gm-Gg: AYBFou2sFybwNj6oLOVWkmKSjLXKANkp80yFE3Od3bDGrF84C7WRgkasK4DYo4HCnHa
	o0gXsL6RflefJoRzBQISTmMNlJdtMQpsIrGy6j5pu5fpC+XRSow07mbT90hO3y9ZD3VMs7OrhfK
	DqvBmDj/pVnvIDGIGFNbbHn2WCC3BZzRMq7Q02B4RNAcsZAAMDPBhsYNeBXE0LVcr+KmXk0+vGl
	+wD7E7O0CoehtFwXIUQJolcHPdryiTM26d2sFskedjWofZJKDVhI4ENMe+L6YVjWB4QQsRzshxd
	AVwzW7QFwZLWzvZ7mtZvrpcpye3AomtWble1uH8GFF7Mq6m5SN38T6RBn3IujqDA7COAr7zYUBG
	eDJEwmvMmc6qpshQMnkCbd1CYc6ECgYt4lLN36M3q2qDa8R9SlUwY2AxXstMRENuEquK8UbsMkQ
	EYeuVdZrsh36FTVV3HItAAS5R0
X-Received: by 2002:a05:7300:7315:b0:33b:e9a7:d81f with SMTP id 5a478bee46e88-340031cca3cmr1644044eec.11.1790235458640;
        Thu, 24 Sep 2026 00:37:38 -0700 (PDT)
X-Received: by 2002:a05:7300:7315:b0:33b:e9a7:d81f with SMTP id 5a478bee46e88-340031cca3cmr1644026eec.11.1790235458107;
        Thu, 24 Sep 2026 00:37:38 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e95c7cfd9sm12120680eec.5.2026.09.24.00.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:37:37 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
Cc: acpica-devel@lists.linux.dev, anup.patel@oss.qualcomm.com, ardb@kernel.org,
        conor@kernel.org, james.morse@arm.com, lenb@kernel.org,
        palmer@dabbelt.com, paul.walmsley@sifive.com, robert.moore@intel.com,
        sunilvl@oss.qualcomm.com, tony.luck@intel.com,
        zhangzhanpeng.jasper@bytedance.com,
        Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v5 2/9] riscv: Define arch_apei_get_mem_attribute for RISC-V
Date: Thu, 24 Sep 2026 13:07:07 +0530
Message-ID: <20260924073714.1650588-3-himanshu.chauhan@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924073714.1650588-1-himanshu.chauhan@oss.qualcomm.com>
References: <20260924073714.1650588-1-himanshu.chauhan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfX/7Qxk0bbi0tV
 VWHtTtL6o1jdJ0FI+TKs7b/bkmirykqXzgl3bxvI57CMB/8bgt4fzc3wkEnuPa/ujtdJrOd3EGH
 5vcDKWZBwvZCgEb3KSKHI8oomm71bhd4aOfQiXmQg2WahWkhCFlajeFODIhpFQXF8tVNNzjmRhQ
 YI6Er31SEFCaU4DmQZNXxrOU0N/oIJKv74YtqSS50c9CvzRFB/o2qlKX+FYKRLATIgC5OTCOa0y
 4f3wcPqLBq8YRrrUuVjyELKlzyfwPQC/k993Z1Zjuop4Znn8WRpjK2eyfriE5BCXjgxcZRB/wWo
 La9hTWyhF/52D1mMg9NZGe/32urGrWXc/wfDKig8QG0uhI5HTUR7CqFmJeuv5WE3lqqBBXI7jpX
 vqsfZENAysb5t0h1Ac5tR9Ys8kiRJQlkBZdvErQo9dULvaTexYjgGXUzcYxTJKFQN/KZL5fLOFX
 O8qxfTIsCdgvdBP8iyA==
X-Authority-Analysis: v=2.4 cv=aIxlOr9m c=1 sm=1 tr=0 ts=6ab4d344 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=eGWCFza2bnmXRcdnH9YA:9 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-GUID: ZUYquLfPDyQSrAC0lkeqgzW_-ZDhnPca
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfX6wLnXm3gh0NA
 GMDz7Y4QDbBSEGm3f1iTxKCH9ysdotZTBGwtohrSYlpCoJnSsIBm0CqSE4Fo3Jm6oXeiV7y1IC1
 3pzdGWLvAlTMKhewFSprIuNVHYcyTy4=
X-Proofpoint-ORIG-GUID: ZUYquLfPDyQSrAC0lkeqgzW_-ZDhnPca
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240032

ghes_map function uses arch_apei_get_mem_attribute to get the
protection bits for a given physical address. These protection
bits are then used to map the physical address.

Reviewed-by: Sunil V L <sunilvl@oss.qualcomm.com>
Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 arch/riscv/include/asm/acpi.h | 16 ++++++++++++++++
 arch/riscv/kernel/acpi.c      | 12 ++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/riscv/include/asm/acpi.h b/arch/riscv/include/asm/acpi.h
index cdefa1f2d67d..c7dee956cdb1 100644
--- a/arch/riscv/include/asm/acpi.h
+++ b/arch/riscv/include/asm/acpi.h
@@ -16,6 +16,7 @@
 
 /* Basic configuration for ACPI */
 #ifdef CONFIG_ACPI
+pgprot_t __acpi_get_mem_attribute(phys_addr_t addr);
 
 typedef u64 phys_cpuid_t;
 #define PHYS_CPUID_INVALID INVALID_HARTID
@@ -29,6 +30,21 @@ extern int acpi_disabled;
 extern int acpi_noirq;
 extern int acpi_pci_disabled;
 
+#ifdef	CONFIG_ACPI_APEI
+/*
+ * acpi_disable_cmcff to disable IA-32 Corrected Machine Check (CMC)
+ * Firmware-First mode. It is not required in RISC-V architecture
+ * and is present for compatibility
+ */
+#define acpi_disable_cmcff 1
+static inline pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr)
+{
+	return  __acpi_get_mem_attribute(addr);
+}
+#else /* CONFIG_ACPI_APEI */
+#define acpi_disable_cmcff 0
+#endif /* !CONFIG_ACPI_APEI */
+
 static inline void disable_acpi(void)
 {
 	acpi_disabled = 1;
diff --git a/arch/riscv/kernel/acpi.c b/arch/riscv/kernel/acpi.c
index efd52a5d05b5..d1e472ce0878 100644
--- a/arch/riscv/kernel/acpi.c
+++ b/arch/riscv/kernel/acpi.c
@@ -204,6 +204,18 @@ struct acpi_madt_rintc *acpi_cpu_get_madt_rintc(int cpu)
 	return &cpu_madt_rintc[cpu];
 }
 
+pgprot_t __acpi_get_mem_attribute(phys_addr_t addr)
+{
+	u64 attr;
+
+	attr = efi_mem_attributes(addr);
+	if (attr & EFI_MEMORY_WB)
+		return PAGE_KERNEL;
+	if ((attr & EFI_MEMORY_WC) || (attr & EFI_MEMORY_WT))
+		return pgprot_writecombine(PAGE_KERNEL);
+	return PAGE_KERNEL;
+}
+
 /*
  * __acpi_map_table() will be called before paging_init(), so early_ioremap()
  * or early_memremap() should be called here to for ACPI table mapping.
-- 
2.43.0

