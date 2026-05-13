Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC42C357CE1
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778661835; cv=none; b=A970NV+rKKdmAs7Yqk2zrSvbyFqiWVsQQCipEMBaj/i09o1en9ROxMTG/1/9so7tvJuFPm5w6sgoi/eXHqCZklYu2S8EPvHnCh8wgUMyzjmNE8s3q4vhmJCptvyffls8e5QE4Ga4zNB+DzlqsEWkb4W01bSGFjSUsTFWMBtqFjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778661835; c=relaxed/simple;
	bh=qUtIRS+qNGJhjFA+Y3AJFh/1zZDEKWdPV6JngSIVVUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzTuAPUaDUSQNfeatgSGnUUsC0Lrbk5vFcf6WOSd86amYbODs3pYUzpEq4I/m6DvcCAMIxF1g3eleSokg9PmzXfFo6NDZZlftQ8K7lmpt34ce+W9xMnxi5Rwc19Jwl4D0uZfqI9D+p2CuTRMT322Gsw13fDD773YONGFcSLpj1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PVY2NhZl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SGwuJgYh; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PVY2NhZl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SGwuJgYh"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64D4pBps2331496
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:43:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=ZsTYqbukSC2
	gNcKAlH0Q1txs/g5j4eHRax/TlmVURj0=; b=PVY2NhZlOkpU5eEQdbYJr4v0WnJ
	eIU3l3b4LkvTNgWgMVIRW+4hg75jgGW1/4vqAk3rZLMDnlAfjuVhNMG++U0GU/4w
	dIw5jlcVN8NbIRjnDnPEVgiAxxAgB0X4GMija/rkWozakzeCKgKLz8094lHyoppB
	tPGFgr/Svl2T8KfPmH1IGfY/NadkGKKRYTjQr+r0+t9msxR2o2HC4mAGgRcM1KUU
	sUCSppWNRf6WvBkvadAB2qDj3DVGpzCg+37USjAa1AqiE6j9ZzAcOCefL4qX7uKw
	+mPdyJKnp7PcIjK5agkIWNClHGkkugHJBUeZSQL4YSuQ1TD5qOCCgx6KAKA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e43ypc8ec-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:43:50 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b9a6d84522so123085205ad.2
        for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 01:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778661830; x=1779266630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZsTYqbukSC2gNcKAlH0Q1txs/g5j4eHRax/TlmVURj0=;
        b=SGwuJgYhJsOdADlzklQwDxXBRQJR/wh+fV31EJAlbsj5Tzs5uP+Q0zkra/NohOwU4m
         ZWrMiAab2xZeO7uLe9c1MJsO37d8kk/ouHs+Lepdu0NzisI8NuulAIFAR42klEvXIRQ1
         sK8xAx8PQlh6OTUKzCiotICKJHolphKPif6xfM4GV+VKNVds2j5ZFJLW8aEdkiXlVACC
         izGKvGh14mGZQTqGiPwGHZSNR69w8fZ50waLDe+/fVnOeQMoQx8zih7194scwifNH/yY
         Hfvw0HBPgL4GSgvj3N45t0K9JfEXCgVmtGylLdUgSFui3EeF63cPe6XlA2PInc7JRIeA
         8lsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778661830; x=1779266630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZsTYqbukSC2gNcKAlH0Q1txs/g5j4eHRax/TlmVURj0=;
        b=GjbYak7+7IRsmTmxztIZfJTkLSTSA1/tGPFPWhmParcMupUHu+RcKQcz+Wn/qMrAfl
         2gxPNff/kAcubvd3ohVHB/ifqENqWCORyMFFVUtg63QIgFIQ1OBYY4TGyZIi2ho1UMQE
         AM8Kp6iNaXgBnbTMSWTeQoRa63DJOj+lkPiT0vB9g8FKvUVTEApIs8qN5BocSjYRB7L8
         uPZlYdeeKtOz+mGv8+lO76CE9ritaW6ZIUxboGGZWP7Rz5EDJH9eGMIZ6Dr+dQgzWewC
         4k0TcIFGxhCPQrTOg9+RTAhPvDyxyTosOADC/jYwMxPOkz5JY3gAE/Mw2zvySfziawDZ
         h+Dg==
X-Forwarded-Encrypted: i=1; AFNElJ8zT8m49I/fzdzhoRsEYmh0SPKFn2fXlzFF0BeD/pyG4dlFb0um3YFM6zoTfB9bKqNPXlV/3PasQMc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVX4AD7azvlH0se38PUIjltq83OFIPAuRAUQZfyzJGNXpe5HCk
	lXfowgW9dG1bqMVRmA1tfe2yvISonpwKjKBtSTLxLixdP0q7FWGM02fqQb/4eBNKYq0YtOt2Wgy
	Z6H/0IBMW3kD3qtyIm1AjMnMNYyFKwgtWOmtRaT2QN6a0P5DY1k8InY+jZrjPRmk=
X-Gm-Gg: Acq92OFG+Mr5lyFO7Je1kL2qugMHnqnDJgChUgMyT/Ozk0PvvQx+laGNR37b+U4X7t8
	DzBwW5RoJeOCTT7Wjm29lVl1gRWHdYWWJWGuDQ6JCYZAmtfSjr1Myyd2wqYk01iKbwU4gYZD79O
	M3iu/ZvRbOKkVhBVWMgb8VjjGfiF8rTnc/cU2g1hstBLBUFgyOUqIrVAy3Chz03JYXB8c6EGoWB
	lDb+uf9wbJNbHCx99aW6UsdDZUH3xXwu+yPM7iY0zPb+LPd8aRPJLYl5qHwUd4vJRhreGFhNgFR
	rRp20l7PcZ5BK+4WXLXp4kWIG/sg35Jjtoz/iAW5NdzbVZxtBzFbPiwrdzIkmq12eT3UeRwHCJk
	GJCJSTxm8N5MiEFkT5lC9C86FdJfgKczjzxsCNq8bnE/iX56k1aWKfjhozhP4k5ns3I7dGThUmO
	g/17uyn+vCVqQxwBetgdjZwy1PdHeYp/g4Wn8hhuBN3wI84Q==
X-Received: by 2002:a17:903:31d5:b0:2b4:5cea:f61c with SMTP id d9443c01a7336-2bd2718bf40mr20936985ad.4.1778661829992;
        Wed, 13 May 2026 01:43:49 -0700 (PDT)
X-Received: by 2002:a17:903:31d5:b0:2b4:5cea:f61c with SMTP id d9443c01a7336-2bd2718bf40mr20936745ad.4.1778661829451;
        Wed, 13 May 2026 01:43:49 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2709bsm169158725ad.5.2026.05.13.01.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 01:43:49 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org,
        acpica-devel@lists.linux.dev, paul.walmsley@sifive.com,
        palmer@dabbelt.com, lenb@kernel.org, james.morse@arm.com,
        tony.luck@intel.com, ardb@kernel.org, conor@kernel.org,
        cleger@rivosinc.com, robert.moore@intel.com, sunilvl@oss.qualcomm.com,
        anup.patel@oss.qualcomm.com
Cc: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v4 01/10] riscv: Define ioremap_cache for RISC-V
Date: Wed, 13 May 2026 14:13:16 +0530
Message-ID: <20260513084325.2176952-2-himanshu.chauhan@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: No2FPbvqlMuFDBbJMlYVq3YU3QtpA4iP
X-Authority-Analysis: v=2.4 cv=R5kz39RX c=1 sm=1 tr=0 ts=6a0439c7 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=JWN5yfGi9shfayy-Z8YA:9 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDA4OSBTYWx0ZWRfX46s3+e1Pjgh4
 tgRSbjBlHWtbfC1WD39Lb6bKLXUq2yY+iB73iMJSRlwgf7aikOoDyA9kemqgYQgiTPFyRoObdQT
 G88TyTCdBOIerS6TKPhP1D7n9jrS7kSHq24kQqLEBNHKPxOUlD/6KGA2vUMsWRoe6aVTHyClHbg
 f2cvx8dLzlq/I6FymwjT4FyAJVpa5+eLyIDqKa/FWbA6RvlDum60RnpG3Aq1JaSvrbijDGxKIpJ
 1MjSLZa0yFEsIBFoPM+zGFSX8XVkU0TAS5cf/s0Jad827Gp2vHYpEpy9wkeiCut0Nn7gN56a+W1
 NEj8DS9yWWn3QtWkqAmnoBEfJ/vf+YWPL4vGgtr+ijNuopT213tk9M1IrSB7yQD2lBscotD/nwr
 4jAeOFGRmqf4JFYRkzVCIFjSqoh1vzUGi+ONk4XIZ/wTq2muA2f16EsrBijZo7L8eOmOBNnZrih
 t5iV+oq42Cn2SVxCg6w==
X-Proofpoint-GUID: No2FPbvqlMuFDBbJMlYVq3YU3QtpA4iP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605130089

bert and einj drivers use ioremap_cache for mapping entries
but ioremap_cache is not defined for RISC-V.

Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 arch/riscv/include/asm/io.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/include/asm/io.h b/arch/riscv/include/asm/io.h
index 09bb5f57a9d3..5550b28f38db 100644
--- a/arch/riscv/include/asm/io.h
+++ b/arch/riscv/include/asm/io.h
@@ -142,6 +142,9 @@ __io_writes_outs(outs, u64, q, __io_pbr(), __io_paw())
 #ifdef CONFIG_MMU
 #define arch_memremap_wb(addr, size, flags)	\
 	((__force void *)ioremap_prot((addr), (size), __pgprot(_PAGE_KERNEL)))
+
+#define ioremap_cache(addr, size)					\
+	((__force void *)ioremap_prot((addr), (size), PAGE_KERNEL))
 #endif
 
 #endif /* _ASM_RISCV_IO_H */
-- 
2.43.0

