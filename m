Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAAB3DBD55
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778661852; cv=none; b=YpC94lezh+zwMegFh81n0y4iC+vk5y5IVdFajdfHvftAZdYIaoBo39myNJo0owTuPVQSSNL93Vz+9/nH6L8PxeMBFpkL8R1bkXnYfszdc8VFdDQPprmwaRNiwMYWfQxwnA9KgbkBaprHUTJLsbfLegbL+hcj9xKncJDHYgOrMio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778661852; c=relaxed/simple;
	bh=W9Z8ad/AN+KNVWAE5HEzWUcd28KekPEPytmpsuBKjhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UXxK9iMrIoTtmfA4ycXT7My/x1qEo4yYU3V2ZqVuRVPYEjTP4cxJ0L0u+Y3LCq9eF1VeXZIc/bqFF88ppcUmE3iTUmOvL5A8F++Zo2R5Xy3Dc2EO7REJWPFPg52NzlDi8/VE5d778Xjg1KkqQvmfY+5we+0BsNRLcMyT/t7LA8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KV2ULzrU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=j4bnpnBj; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KV2ULzrU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="j4bnpnBj"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64D4pNPP2933325
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IQxw9pRj4KjsMr71sZ2t5x+9tK+jz2fwPiFRsDjX/i0=; b=KV2ULzrUF+A121l9
	z9f955kn0s1jVBhILxSnebPtKiWic4KBX9jO7+5bV701hVPYAjoFWfFKYQ+w8bv+
	IfQMCgOpvfz8pP6wHuqSO/wlu4nYnTUCvi2m4sYEQ5S/4uTatQGRTCkM3yWtXvFj
	LhiT+JOzzI7Sd+i4bkvpSxa7avNl6uwHRRVCbKksMhULwrlXHg7wXa6xbADYoYT/
	S/LOfwG6PsNRU4CaR/RudRWeqhdn+ATc0Z3N5cEHpm9QfzrrpvLKkqNbsPBuPbhG
	aqxJzS1/PcCVa5l3Ggulq0N5DfhG01kxnRqLYbJ+kWSU6oq1480UIYiAvW8Q5zqE
	Vaap8g==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e4319vjf3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:07 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ba268cb5e6so57930175ad.1
        for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 01:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778661846; x=1779266646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQxw9pRj4KjsMr71sZ2t5x+9tK+jz2fwPiFRsDjX/i0=;
        b=j4bnpnBjH9xLB9kAhzjLSUPWFnEjK2t8mCME3gL63Na1g3mF5irQc+1SSbJI8TkcUs
         EQTDV0SOfUCPDiF3zjLF6J0Jl00GM8uwSU/aar6H1RFny/M8RjuhiO0c+SCC0uMdbYqj
         mgHsCaSuKIArMbMunwT+HM4uzT7f3XdkJkmSztl1U25zM75h30xUefWWR3QaXpV14IYi
         V2WBUcYqTZqIQ4mNbwxflvewIuEt9G0jsMzJlx2Oy6cRQ4KUmLQ/7mGs1+8vFwUgloKr
         lAbsilvKApNp4L2YAORsvJYFEtt0uIp6PUVsX/BhH4reqxCUZF5OqZ6hJC1JioiXO4Fv
         xuLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778661846; x=1779266646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IQxw9pRj4KjsMr71sZ2t5x+9tK+jz2fwPiFRsDjX/i0=;
        b=IPfNLTcDIjTOaRmSj97dagYmlSJCUiEPbcZPahtUgQ0UVDM/YBpKHOE17aOiuQMoaY
         w1U1xAkiBhJlK8v1Z7aMuIXQXQwwcOHP7G1/WZM9H7xzc/OS6fr24fZsd7aer+qeYBlC
         KWfqGcpnmclBVr+1G1a0QtajfrkRlsSQLI5oR2m3ByrxAIZ+GovsrqpIxBJOMUL2W7iO
         PJUKqPIcvA3gaBwH7zgNZlH/n7mi09LeSQ0CCPvCoj6g+MCgSzRiAdn2p7jPRMAnA1oQ
         DXa7oRBmpd9vUaCK2oEodQAqr7x+zkD4pLzKPNsDHDzym4HRuWJlVFEFaJGGMDGWk6Gu
         iYig==
X-Forwarded-Encrypted: i=1; AFNElJ/jbUxtNIDQjBlMlb0AxXgoptH09zOpexIoXwXDT9/1+Uk5Sp+zDAwwdvN6/HxXx4c3ARhvFfYfRYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzelyIqlYeMUAciMju+VTFcCmv5/Pjnmw2aY6CRHTuOjx42bp5E
	umh7KZetLJG2fVpZc8wlhAK4R+F0iBSrJtJ/gcPM0hzBOcfCJiJEbHbvUO2ZYjRLgBFEqjYbYw8
	N8YRxARu8kXlzLdcQDDU8WNrQ6Xw8jyT/97/29EBvhh+tTb/pzifVvDBB8RGa9Dc=
X-Gm-Gg: Acq92OHnJkKBk6GIwRqsid9L41l1809dljgoCZo2QH7QQmRzhhT3J0hUcDjlTaX8ZZa
	QkRp/ctkFm1tA/hMRnAv8j+w2+cH6ie/QBPODTGSMeR9BeNiGo7qzU3j+EYM9FHldXkbbHKDwtT
	5p1g1UzfTfdQS3oc2norcdmZSOGDyN6jvxeY12szJTt6V6DnIwCeSzqbdL1bPBuwtgDSRo51w1q
	5KlHg0SsaOyIGMnM8uLLEJ3gCSY/p7V1Ou2BRG3uUKVYUi3gfePBJlKiCMObeIM4hWmSbJyybBM
	J/ITow8f30960dkduOiKPNwtR9rXoBGkanprJDjd8lbcbB4wNhexAk+yu7XF0jnOHZiLoxLAcN1
	SCFfu21r8DhZEr0nwHhl218jxze3ujIkBr5p4wrip6mgoE3gVhaXjDWsvwPb+etej31Np4lHHvq
	ZDlB1aAXXXMwKJIqajDf4w/JDVsVGncGEf/Ar77JBJtPMzgw==
X-Received: by 2002:a17:903:238b:b0:2bd:a5e:4c66 with SMTP id d9443c01a7336-2bd27161669mr28108145ad.14.1778661846202;
        Wed, 13 May 2026 01:44:06 -0700 (PDT)
X-Received: by 2002:a17:903:238b:b0:2bd:a5e:4c66 with SMTP id d9443c01a7336-2bd27161669mr28107795ad.14.1778661845699;
        Wed, 13 May 2026 01:44:05 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2709bsm169158725ad.5.2026.05.13.01.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 01:44:05 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org,
        acpica-devel@lists.linux.dev, paul.walmsley@sifive.com,
        palmer@dabbelt.com, lenb@kernel.org, james.morse@arm.com,
        tony.luck@intel.com, ardb@kernel.org, conor@kernel.org,
        cleger@rivosinc.com, robert.moore@intel.com, sunilvl@oss.qualcomm.com,
        anup.patel@oss.qualcomm.com
Cc: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v4 04/10] riscv: Add fixmap indices for GHES IRQ and SSE contexts
Date: Wed, 13 May 2026 14:13:19 +0530
Message-ID: <20260513084325.2176952-5-himanshu.chauhan@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513084325.2176952-1-himanshu.chauhan@oss.qualcomm.com>
References: <20260513084325.2176952-1-himanshu.chauhan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDA4OSBTYWx0ZWRfXwY9yHgxmMrjj
 XX58tzBrUvp90FtjfZfz2aswyMBmYAHNgcaSkXa5vLHGufAnDmIuUN0SEnYti+dsO7P4ySslBJQ
 bbbVWP/Z89QcBu+iF5RMoC/OdhHwlO7Dkzbwl9pLzKrqCs/1Yr2b5X+4xjRTggdtBLiyV1MEXNa
 Mv7TzTYhHsuSav9zfq1RybQv6ArcpZ6QGxLP3L91qWlef/YYK7W7aCDmM6FBsORJbgn6I9D1POx
 HADm8dIvWOeju2yLpFisxOAg8dkwbFaaj3U6qqiAg6TI3+2JLu/Z7T1EGYNOJ4Hiw96S/Ts4s+S
 tDTIJUOxfMkd3d7xAGpw6VDg1A7h2xU/1Wt2rmOhOqU6vIeR43c8BoCKzelLNDEK5CWJySsoQmP
 DjBbrqKUXI79LoE0jrpqHWWfF7Kbeoshz3x/ePzLNno5ZJeUiQv7RKbxlEY3Bj2T4LYwAaDBL4r
 Qn0DL6Cm9MsF4v3uaQA==
X-Proofpoint-GUID: 7XAS3ImepzmN9rR0sQwEX3KxcxJmMd_V
X-Authority-Analysis: v=2.4 cv=bp98wkai c=1 sm=1 tr=0 ts=6a0439d7 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=h0uksLzaAAAA:8 a=0wheRbxtA0UXKxI4o1AA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22 a=MSi_79tMYmZZG2gvAgS0:22
X-Proofpoint-ORIG-GUID: 7XAS3ImepzmN9rR0sQwEX3KxcxJmMd_V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605130089

GHES error handling requires fixmap entries for IRQ notifications.
Add fixmap indices for IRQ, SSE Low and High priority notifications.

Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Reviewed-By: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/fixmap.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/include/asm/fixmap.h b/arch/riscv/include/asm/fixmap.h
index 0a55099bb734..e874fd952286 100644
--- a/arch/riscv/include/asm/fixmap.h
+++ b/arch/riscv/include/asm/fixmap.h
@@ -38,6 +38,14 @@ enum fixed_addresses {
 	FIX_TEXT_POKE0,
 	FIX_EARLYCON_MEM_BASE,
 
+#ifdef CONFIG_ACPI_APEI_GHES
+	/* Used for GHES mapping from assorted contexts */
+	FIX_APEI_GHES_IRQ,
+#ifdef CONFIG_RISCV_SBI_SSE
+	FIX_APEI_GHES_SSE_LOW_PRIORITY,
+	FIX_APEI_GHES_SSE_HIGH_PRIORITY,
+#endif /* CONFIG_RISCV_SBI_SSE */
+#endif /* CONFIG_ACPI_APEI_GHES */
 	__end_of_permanent_fixed_addresses,
 	/*
 	 * Temporary boot-time mappings, used by early_ioremap(),
-- 
2.43.0

