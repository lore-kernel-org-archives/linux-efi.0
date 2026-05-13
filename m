Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856993E023A
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778661858; cv=none; b=VvPKc/G8+lV4ZDz3t476a3zifVyqWB4YcftCFpQeZoWQLYUWrpEZQCiDnQ6KPKpe0ugauKR5/oyDFmUsUwmwYp6Oo7Hvkvg5C+iAtUVy2eMkTENxITGiCtCojEpcIPyLkFZV6xzzz4stC4UCFg3j7YxnfDLin6d1xXj9pKUBKJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778661858; c=relaxed/simple;
	bh=wsh7T9Es8tm7G5+cVDm4V2UDNK5E6+Q1OUCLkFOrdYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOmjcyEBKPpIAGloYZWTal16I3nlOWnPpfyG6Sy9iQxP1dDDQrUPiSTPriFAJLMvcH4wcEFl7NniwB4QV3NQSxXnsNJG62otIJv0f5X2R4rmp+GTtE8kZV1ARxMCgwpj4+IIcZ2JmRZU+QjDwAbnXsxSpwNpRTSpJU7s0Hz2Qg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ew1B5Uch; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kpIe/Oz6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ew1B5Uch";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kpIe/Oz6"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64D4pFSa2338896
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=V0HbiZ4P78p
	MMZLzC1v2KdG7nYX9gwkT4Ii7QaESwzY=; b=Ew1B5Uchu+VjkXeGWc9d3N/Pnp0
	nZzD6LFWdy1C5JumSy6HgxxxatVH7CrcEpiAr9tS75N2AIkHFhcuhJRYTQ8mgoyP
	k1wM/NjaJOAmnExQUkI3ZQALvNKL7NR6A92epgC9W1XZK9labvSiOzprUknX81XP
	UpnV7m3Y4Bttu2nKW79QfqCF4PFIRGybDVKuPRjTLw9qc4t2aI1vB8yBu89fjwzP
	fFdMdlBWmDobbsttc8VESNOP/+UnbmbEa23zIA9ufpAF+GWKY/+Ag75US69WBBTB
	h7+ga4OgAag/YdzmegpAqGLCjlOoUX3Xj2wXtuqPlacEWT0VTmuGmhuIz4g==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e49vxajt9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:12 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2baf7378ad0so53277365ad.0
        for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 01:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778661852; x=1779266652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0HbiZ4P78pMMZLzC1v2KdG7nYX9gwkT4Ii7QaESwzY=;
        b=kpIe/Oz6ykWXUvJhNnyLvwjUHC4+XajEDczsanrbaCykuSR7nuBLUO7unfcbx7WOGn
         cFtuDbZHIy+nKqpH+rn/zAF+oVMR+nXw0wG1U6KUh6q6gJUVWpgrPN5PSwaRKaipupeI
         Pfh6L6IOyxIdqN9doA5oEPa2VRGfIUwp31ZRhX6+eTBsCHT46Pen2FPCPavNT+3dY4ed
         Vm/Hlxgtwyt8UslUpMUrwGLQ247tbRqapS7kc9pP6c5ZWebbm45xU9TZQ/AHAR3IK8Ma
         ve+vAbEeuPQ2kXZwe5igZCAolnbpc4+8BVgpWB5bRLirvRmt8u8xciuxZkJ+6q6Z3ALl
         DqwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778661852; x=1779266652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V0HbiZ4P78pMMZLzC1v2KdG7nYX9gwkT4Ii7QaESwzY=;
        b=TrTYjMMI6mA5trCu6rdOygS3Qg4rxzU9SKJ2YEXPZJvsh0rwrIopLs7WttLR94Rs0W
         MxFMoHMloCGsocosBNgcLi1Jxy2XYQleR2TdNgq4D4Gch7SLU+qokvIp4RjJcsNn1Sy7
         2JOMg5Wp2gP3BonHP7l+FEaEoUlwnuqjgIbGDtheJGGOK2fLW/auOEe446nJEh/BNC1n
         YjITwpqlwXHPqx1kSEjFlxz/DXnbLccbggGCtZASfekStIrbIs3NQXwLIxMVanPvOFyq
         hxGaWzPFRhSO906QLaGTa912Q5aPO9/Q84aih+oYXtWApP2PrtyPOv+tfTwGHJg7CPvR
         cEvQ==
X-Forwarded-Encrypted: i=1; AFNElJ+K0wfBT3l/685oA0EsVSKyHkQYo4M030zyP1uf0yoNQfKegrIK/6pwUKY/TCcXP43fKgHoe/yC5do=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+PwJWJYA7ZQmSXo4CnpRYyuNtvmUGUGruI9BGt5I3Tt7GW8af
	2SzqxnIJBUKAcsuUpmGjRjoxlP2QE3dBZg/3wHZn3B1qjigUzUCOBMYUhyWxvackTf3KRMOJBzv
	D1eHm4zWyVlOgjoipoPWD6m2fy4JYgWQmpu7sf0qL2TiFAON9gvXdof3PT4MN4rUHLYPA/SM=
X-Gm-Gg: Acq92OFWbvQQV8ldaGtHV383X+92mHHwiYu36Hk7eoBvl5ySIcztpnd6Eo1GbLmxjFH
	yEqU/FPFoblsGoDkvvUcsj0krIiVSVNxjKDRvr0d5PQUTuONv5Yvy0JE0/KS70GOfkBnmozZmNW
	fWO/7+xzv0PWVeqSWO2M4H5qbmjLoIGbUXUf+OLeFCoCezPzUQBxtD7fXa5hqiQ6n7LWw2nNVUD
	cWCHunV68/hMNV1gpQL0lcHwJQ50587OssKGLcr7p3xdB1B4ZY/CVEjly63U+k5KsL7OGq/lC+J
	bylfe0FCNOrTvBiZute6XI7K09ppDlbeatXsNYarIXi38IoSeUz37M9Cl3os0veVnxQEmyo1nEJ
	mfZpcCTb5wWfD975gkos86PXMLDtnNUgRvll1U8rBG5tsQQKlSTzzeeOkhLjhTSR9bKi8LD2dHI
	rkLMjijpq6CJDilZNj+/37VVOrRATxJTJJEkD8woPDnYk3qw==
X-Received: by 2002:a17:903:11c3:b0:2b0:608d:d8a8 with SMTP id d9443c01a7336-2bd2f4cb703mr20265515ad.1.1778661851551;
        Wed, 13 May 2026 01:44:11 -0700 (PDT)
X-Received: by 2002:a17:903:11c3:b0:2b0:608d:d8a8 with SMTP id d9443c01a7336-2bd2f4cb703mr20264915ad.1.1778661851092;
        Wed, 13 May 2026 01:44:11 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2709bsm169158725ad.5.2026.05.13.01.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 01:44:10 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org,
        acpica-devel@lists.linux.dev, paul.walmsley@sifive.com,
        palmer@dabbelt.com, lenb@kernel.org, james.morse@arm.com,
        tony.luck@intel.com, ardb@kernel.org, conor@kernel.org,
        cleger@rivosinc.com, robert.moore@intel.com, sunilvl@oss.qualcomm.com,
        anup.patel@oss.qualcomm.com
Cc: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v4 05/10] riscv: conditionally compile GHES NMI spool function
Date: Wed, 13 May 2026 14:13:20 +0530
Message-ID: <20260513084325.2176952-6-himanshu.chauhan@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: KRpWf9xRMh-LwGKFdr5mDYnhFixDSoAJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDA4OSBTYWx0ZWRfX9D0rXCF3e5iW
 dyZ+WGoZ9yuDiENuvRxr6POfO/YVQ24rr9OlyQMgFEt/PpzjbN/+xFWr3KQVt2qAJMvbf+OuPT5
 QgfvNKrb//38GsdCgXVXhqe3bBr5EPSs7+wDEOjrP1UxydD19NEHTbYkhQ3MfAYB/mr0Xw8l/yy
 F19vFn6UzgLEHPZDTRHgf+Y4FgLzZkTQ5/Bl8KwU2z8IkLyg+fE6XMqBy8uiS912XowJ6ZVl9Gt
 L67IAsmFU32UYwUUuHDXgX2P5TuWTuJa8tDvUsyjbJ1P9Ubft8l+CnuboojDobMHLKqmoWo8Twt
 l0zKzV7L6WCEZaIZywMKvlWo0a3s+uL2u23opqZfRWCAca+mG8v+xnKOkGk1TrreYi7rGVZooQW
 +y2KgR8dg+mJ8dJz0GAAP8uV2m2lL0L8W+AqLJOFiD1haaTDwWppBynj6Nq1+kXEdW6a7G0p8nD
 HSWwFn4NWVXcZ6CCDcw==
X-Proofpoint-GUID: KRpWf9xRMh-LwGKFdr5mDYnhFixDSoAJ
X-Authority-Analysis: v=2.4 cv=A8Fc+aWG c=1 sm=1 tr=0 ts=6a0439dc cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=-FlRX8pefk0TmyAjS3oA:9 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605130089

Compile ghes_in_nmi_spool_from_list only when NMI and SEA
is enabled. Otherwise compilation fails with "defined but
not used" error.

Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 drivers/acpi/apei/ghes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 3236a3ce79d6..8edc2c8db1bb 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -1397,6 +1397,7 @@ static int ghes_in_nmi_queue_one_entry(struct ghes *ghes,
 	return rc;
 }
 
+#if defined(CONFIG_HAVE_ACPI_APEI_NMI) || defined(CONFIG_ACPI_APEI_SEA)
 static int ghes_in_nmi_spool_from_list(struct list_head *rcu_list,
 				       enum fixed_addresses fixmap_idx)
 {
@@ -1415,6 +1416,7 @@ static int ghes_in_nmi_spool_from_list(struct list_head *rcu_list,
 
 	return ret;
 }
+#endif
 
 /**
  * ghes_has_active_errors - Check if there are active errors in error sources
-- 
2.43.0

