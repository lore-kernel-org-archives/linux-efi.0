Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C33F3E0C50
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235475; cv=none; b=DinHxirlcBzx+Tjrs1JTQL9q931VVPSG5J0EELztomWwTbK6a5IhF5kb51gsILLymySFq+Hc9oF8nCTBWZbpFT+ovcfTqweOrRBJpaSawfts8nsRaInRgmlgTPhkCBA7BCKRQJnRPsxpijcDkg7q9OMT9ask+Vd9NH+a1EFSlgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235475; c=relaxed/simple;
	bh=yPs54dR1sQ34iP9KP9L79uS4Msk6zBOQyyBaMkNA7CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZWmDLz0gh71iRI+3SiHQPxypnRU91FcqisYpDsL8DPBi6yTELocI9NmbWzYsl1sFz9DVVXZjKesaHEZ5p+jiWIsX0msL0Y0DocSTtql8ix0/Igh+rO10PUkc1/KkTJv0SRNfqkiLGHUj39KF1On8ZqNgF/az0RWp4B8yLec8nTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nUwXmaQA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Xy0ih52Q; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nUwXmaQA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Xy0ih52Q"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5eWAx1741995
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:37:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mknxxgoL3HW6ZUvafxGrZ8mdSHeN5aHUem6OHhh1IYY=; b=nUwXmaQA9SMdg14Q
	CXyYKtbH9a8HcwYYPNRPLL6vT2m1D8krKkkSA4YBkS2eP0MV8JkK9O5m11/XUA89
	tLX88fNfcSsuulD+yOq4DqZJWoqcNrCA7VDBIYFoHXNMIi9bpEHMYRvs/nQ5ulqh
	/IuKUrkYPPbOxBzCj05KTR/PGz/xFO14YZBpeT9dBWEbUj9IhD0d0IYfG6Gkxeg0
	HrtSVptcKdJM1q4ISr5ViAY/oscqbogbcyKNX3hqV7t1H8DOuYjlggAMVIxhsDsy
	xyk3BmtvLVUFZKDxRwGgD3K1/c1PJdIxfXQzbPXlq/G1J1+1fke6GR0E5kr5O4Jc
	CXltPA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvfkbkw4n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:37:51 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30f1b904861so2472018eec.0
        for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 00:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790235471; x=1790840271; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mknxxgoL3HW6ZUvafxGrZ8mdSHeN5aHUem6OHhh1IYY=;
        b=Xy0ih52QBhWb3maK30AVUCxmw+rFBFFjb7Ly99GogA/4wmKB6AWjPd6UdJuLsdMiGv
         V13Jk2fkiRU1V7T0rizVEhs2Ie3sSW+Gg6HQT+8dtY/6UK10ClX2oPP109dcvALgIL8j
         7RvKu6O/DYe+ulyVJ7POA+IepIce7DpNOTBjHaK/K8we4btgX/iJMi1ytb/W2DjXJdZz
         AfEtkK8jdftlkLtMDfu+Q3lPMLm3zgY9VUd0HYyOl0r2J+ZUs71r9GHA/85NUyWxOLf4
         kj49FVBMHLxQzaKW9qRjQxIKoJAkMDZehoICGYuLRCtmVGeTDA1emh3RGFi3UqO3PmKd
         IFUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790235471; x=1790840271;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mknxxgoL3HW6ZUvafxGrZ8mdSHeN5aHUem6OHhh1IYY=;
        b=n5cpgATJLEw1sM286Whs9FRn/uJ0mfYYy01rbDyOsq6lt+nkLDreQaTv0qjDDidIrs
         Zr1MhM4KMik47JKAHdqMsUr+4f2Z/zQoZKjVEFIicnymDlLpZPJxttywUtPyzSiBjVRa
         N6qLOHDACEGtzC/GliQ5Denlop6PEr9EyxQCMHIOFBTVD2IGwB4uLA9Q9Btw5VL+H8KO
         z0TBLALd7ynfutStrTcy7P55zY5sO1eFIHMWUJvBpdsvDHuFPU9FNmO+WsUspdHJr3M1
         WtATVuiRar6q5VkUkeHmhu6gM4R4C4BlDoA5Qyqz1MwvqrmBlthutvUJpkzB03qdCFE0
         tx5g==
X-Forwarded-Encrypted: i=1; AKwUvBz2VB4I3o7r5wTVq/CPNYBIul1RXssdci8oaeBCxqhJgf/rUo/USsjMLV4/8Gx2Q4LR27/83tTSnN8=@vger.kernel.org
X-Gm-Message-State: AFuF++kDYEP0LJct5+GFhUId6qFcO/79ih5uR0qFJFDvMpqx+6RKyvwl
	U0Tu3htBLVYxjmVrPF15041sYUp8n7BuLMpGI60tXulcm3nnr0sCv1umwimWw+QJraadYR00HFT
	JHwVh2s578haieFV/V4Jd195TOJVi5pHdiK58nbBmiWNPMphDdGGnCHQamqiMpcc=
X-Gm-Gg: AYBFou0vmYjHmYzyx6/wkuoXbCJJOtDVXXMh++oTdXQAl6nNnrr98inWK6CnjtnZAGC
	g+SBa+IB96hHXHpK0TCN58IogY3cwmbjFNb+eEphH+8FStYVdOdkhrbndMkr5LKNen1/meDw8rz
	yudjKxrsc+HXusgZYjLeKF9h1/cnW2gDOoAZSKpohtxQksJ1Qwwx+GMK3dCvTfv+JUyY8B+4rwU
	9tij7rKu8cmsxTfsx1llmLZYvOQz8Zah+q9MoHZZ8OGNhqSPxObVAprqmCaTSWzkDSMEXbmtigR
	jsvjrUFSmmy9lPkwr8rqRadl+6J0MBc6RyZ7ze4SbWsrzhSJQPv9oVJHm+2Exgee+PVJGb46Ed8
	xcptdM+JSosT7Gyz/22OcEjR4tszAj4Chnn+sLZzrUpp6tZ4P2eHYc7QClRqSym+JSemFcP1ZHB
	g8q1XFu24J2hJ+e/iHVkLzYzhg
X-Received: by 2002:a05:7300:f810:b0:33b:fc68:9790 with SMTP id 5a478bee46e88-34005c6210bmr1298362eec.21.1790235470865;
        Thu, 24 Sep 2026 00:37:50 -0700 (PDT)
X-Received: by 2002:a05:7300:f810:b0:33b:fc68:9790 with SMTP id 5a478bee46e88-34005c6210bmr1298326eec.21.1790235470219;
        Thu, 24 Sep 2026 00:37:50 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e95c7cfd9sm12120680eec.5.2026.09.24.00.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:37:49 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
Cc: acpica-devel@lists.linux.dev, anup.patel@oss.qualcomm.com, ardb@kernel.org,
        conor@kernel.org, james.morse@arm.com, lenb@kernel.org,
        palmer@dabbelt.com, paul.walmsley@sifive.com, robert.moore@intel.com,
        sunilvl@oss.qualcomm.com, tony.luck@intel.com,
        zhangzhanpeng.jasper@bytedance.com,
        Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
Subject: [PATCH v5 4/9] riscv: Add fixmap indices for GHES IRQ and SSE contexts
Date: Thu, 24 Sep 2026 13:07:09 +0530
Message-ID: <20260924073714.1650588-5-himanshu.chauhan@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924073714.1650588-1-himanshu.chauhan@oss.qualcomm.com>
References: <20260924073714.1650588-1-himanshu.chauhan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfXxVCR1Dn77taX
 LtlY8KkBL7x9IrT6Cjbp8CW7YN5yo2qJ93GL6V4b2vNTWsmHYc9JTxDLMMmPrGl9CNs1pJccfWm
 Oe0vEHFfy4Jl542glqszxijk9oUtBU0=
X-Proofpoint-GUID: DI9_Cj8aPmhSN54Yzv3Ch33aMXJWSvTh
X-Authority-Analysis: v=2.4 cv=RYMFmFtv c=1 sm=1 tr=0 ts=6ab4d34f cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=h0uksLzaAAAA:8 a=EUspDBNiAAAA:8 a=0wheRbxtA0UXKxI4o1AA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22 a=MSi_79tMYmZZG2gvAgS0:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfX5oyrFo/xnDb9
 n0fUotcB7F0D4o12KMXmLrQGnSHE9JXa+hCZk/p31jtiiFWCWwNY3bvgsLLqT1pFY/3bvy00NN2
 s2Wodh4P/bcfApWyix2BnDrwXSH8J5xHIm/oES5VryDcNNFVl9rd24t5BFD6fHfBs/XBoJ9bRQw
 f6Wmein19QcOA1aPXUhzOKitJEI92ySF3u+hHgiG5/MYGLOKIjx8tymPp7ZrtJ5kCZS22TIhAhg
 IWQ345RMibi79B3eEbcQ5QdzOQHqeHEqj6aECJzVn9WzrDGo8ofimdUQOnj6uavjg65eIPTTGWF
 OBphqxZd168j+vlbWWGiTDiKLiwruwFQdBOSdAZ8IrOD/t+WedLDA3ue1xSt+xChCf2U2u6CAjC
 Wun1xPzFx8ZPql2IZnQ6fJZhJS3sdcbIJ4HSfUek8cjFzcoTBS1iO57Kz05CLsoovL4PtAKjYLf
 0mgZRd39akFL7at5LOQ==
X-Proofpoint-ORIG-GUID: DI9_Cj8aPmhSN54Yzv3Ch33aMXJWSvTh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240032

GHES error handling requires fixmap entries for IRQ notifications.
Add fixmap indices for IRQ, SSE Low and High priority notifications.

Reviewed-by: Clément Léger <cleger@rivosinc.com>
Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 arch/riscv/include/asm/fixmap.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/include/asm/fixmap.h b/arch/riscv/include/asm/fixmap.h
index a81823c5ee4a..3a775b8d0cdd 100644
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

