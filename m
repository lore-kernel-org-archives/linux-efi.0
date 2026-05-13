Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30933D6478
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778661846; cv=none; b=ibK4Tf13nzym6nQIDaME5cQWsgAq4HTC/FogF7khFGyYyn/dekwK2mku0VP3DkmxjfvjHyiR9a1j9NQPlsy3i6g2xYqP5x6SqThn7eDu34mB1V+OdLGZeuj1ym4A95IdPSOvXvk8fIH9lVKjqBHe7FBnYY+y1u3pIlL/LqWFHa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778661846; c=relaxed/simple;
	bh=OM3puXfkqZmLNZrfom/EqiK3YzhGX1pHmbG85tQySaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yvsglw1RlEdlNu1mtzgADUUbdGDTB8eMLXljSdouzU3hTm1LFwdbIS7C42g2cPZWfE2ALfVe66anmu+BQg4FhzFWJI/E6DQIdHE0qDKyj2gKq35+WXU/dnr+eB1rIb63ce1O9B4X28zUseoKK+mu00Gyq7pNoPIhkNbsoaje8mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FiV9PcTO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Kg5hMPmf; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FiV9PcTO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Kg5hMPmf"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64D4p9CD2652381
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	10e/P1TFZBwN9btyQIYXv7eFhzP3u0CEgDuiofULBYw=; b=FiV9PcTOqUDEUrUB
	wi0As6qHPrmE1gK7uhvqXC2uVxa9J1dv7ySRSEbDJLDcDSaRwakuHud2jdMnNIwK
	Q0hNZ6dBU9a3s/Z0SfKkRwsydypn6S9OxbyfClQ0AH2illUtBPY0lOL+EBmocGs/
	pi6ioYi75L7WwnsGMhylhE3v+dWyYG3LPDDSoMF3YV/CKXBOiSCOyqzbDO4uPYqO
	gGs/hNOmOPNo8l9XQpt3K7iUwXJ5Je/tFiOSNvW4UlEjZBHYJkLO+pEUD1lNo/kj
	J+7Cfdr/7xYTwi72vawVCnv3U4srs/SJjVvCDmIO5j+nPL1VGlMVJrrIwy/Q9qmI
	hjYInw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e45avku5c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:02 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b4654f9bb6so69255435ad.2
        for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 01:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778661841; x=1779266641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10e/P1TFZBwN9btyQIYXv7eFhzP3u0CEgDuiofULBYw=;
        b=Kg5hMPmflBA3i8Ht8B/KXdInLhycQqmXoQb1Ht37LwinpgShpYI9/pFMv4yaelmKyi
         Hze73/1eK/i6VkOx1VcCtwvATDSe1DdiidZ1AR5MpYLt4gjiMMZ0jgg4hIxdKusIqPR1
         QQfuxzCjnnmSpNG/pmjVA4Jl2Ys9tf6pdzJnZkYFbGHGA4gkJEeqiJJ9op4xsrzqE2bf
         0j7INU5BPb0+4keqONQnCawcclxNVqi3OKehTfZMZXg7h5biwVn/UUfGv6t5NqbjwqgP
         NCZPsZoDZqfTikWwnrLhaCC8oykDZe3v9jZhU7l2eI2IeGsOazPIUksjvFw+ovb9rBxR
         /XzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778661841; x=1779266641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=10e/P1TFZBwN9btyQIYXv7eFhzP3u0CEgDuiofULBYw=;
        b=hGsOuEEe9ZGqX3QxHJrnezDNHy2M9br6z2H/AW0SBhcLWcJfLZXXEAOOsuHmXT8maN
         kcT+JC3aalQOwxT5whz4g/39Idkv4I50V6R18aICz1AHb5ryB/gkqCNBh+ZrBPzAYaoI
         zeuDaVdOGv0SKtgPVAZMU12zEJ9yr4VecoVXJUisjQIHDZK29wQR0f7U/xVO3qNepdhS
         oKEPSqH66FVZlTKDRYRdjGYnwN9ZrjSzF9+ViP2zi/A4IHmfKJRE+YbyLiIcvWihTCw7
         VJBxx7QUR8KstysWwPWAou133y+5x39EbKA4Tzqx961t9zaWPcsVw//rTku8N62+zGcP
         bC2A==
X-Forwarded-Encrypted: i=1; AFNElJ8P7wd1RatU3otkqITNzc0AqPHN/ue3GQXMtzXUQK6KCLHdf6nGbsHyWC+f55eYGu+g9Xj+7LG7Ork=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZdZI5m6RauZyTCu4ZiPkubP+p5DrHPRgL9SV1Vo1tP4IHlq5g
	6XeQAODiELQoNq3FRSfJ1wumQkOOGymDe3/SYkE4+6JU/yWXER8A5AYPyOioB+CtaqaPtR8XNCl
	4Q3wXApJiyaZema+NzNwSTbZSCokj0mEFvdKUxwfN4ABL6zUagVLzFgHGnOxROCQ=
X-Gm-Gg: Acq92OGlfuFIWL7qe/GKSfcI9fNsLD5PZz02BU1b2ndAoDpZiJu5ADXLVJF8HvDBMHz
	SktTHFwmp4rGQN16d0AbiqDi0eg88XcNA7Hi9lFUDknBDHLz92gmHLNOGLBj3Qhrf8uttUyuq1F
	e39difn6usnYV914VXHsqURsLI1wJKfsgWzI2Oz6IVKIoVR953ZZ8kAQnsEWFopFCyO/Ipm/0Pu
	ZgNbxgRkHMig3s+VblNt2IRExMZ33M/y1RDXPAg57TySinwCEvkPgpqIguUTpB2OGzFdHEUs+mf
	HuMBXu58Gf+5E6sDyoWU2Op+TN4283wgJAp8q1GsTiLkD2wCZco8iIQq1M5VVs2VDCrkEPXIng7
	RpzvYmQUA1oBoGy2dn/4rw+61k6M5zhVAlFMLaapmOIrMqccZX4eZZeh3Slsz2/zpo3p8C7uRHZ
	vXIpzpem9Suf0Zw0Jf1Uuw6smgDiqDbHUftQVdiZWsgO9Uvg==
X-Received: by 2002:a17:902:db01:b0:2b9:cd2d:6f13 with SMTP id d9443c01a7336-2bd2716dbd0mr27138375ad.10.1778661840782;
        Wed, 13 May 2026 01:44:00 -0700 (PDT)
X-Received: by 2002:a17:902:db01:b0:2b9:cd2d:6f13 with SMTP id d9443c01a7336-2bd2716dbd0mr27137965ad.10.1778661840293;
        Wed, 13 May 2026 01:44:00 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2709bsm169158725ad.5.2026.05.13.01.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 01:43:59 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org,
        acpica-devel@lists.linux.dev, paul.walmsley@sifive.com,
        palmer@dabbelt.com, lenb@kernel.org, james.morse@arm.com,
        tony.luck@intel.com, ardb@kernel.org, conor@kernel.org,
        cleger@rivosinc.com, robert.moore@intel.com, sunilvl@oss.qualcomm.com,
        anup.patel@oss.qualcomm.com
Cc: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v4 03/10] acpi: Introduce SSE in HEST notification types
Date: Wed, 13 May 2026 14:13:18 +0530
Message-ID: <20260513084325.2176952-4-himanshu.chauhan@oss.qualcomm.com>
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
X-Proofpoint-GUID: x4p5XbSiQTNZZ864fer3AGj7XRd7fqMf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDA4OSBTYWx0ZWRfX7UsB04T5GZjs
 k95Rq01h00rtqX0aMV48sg/7sspY6r2k0Rtg7ONVfK9ozH3XjoMGtnd4VN7FDMn8iB1BjLuLV7U
 7wyV1DDcMzy7GvmJIDtTPkbuB7zeDXDkOr96g9ZJxcrB6vr06yx8TXUjgV5yZN/3XGMv7uUoV7B
 mTUv/cOdMt4lwWXL/psvUqCo7iAX3bSCRFGzMBg1dRHIYqBfmo1vo8L+NfmXJlNnay0x0xo7gL8
 gZEIeEqTNDF+rPWvBWr4bQ7J8rwm33TMVdoMxtLe7pbClV15lIGucZCqEFtVbXWorh3HnWI+ylK
 uTd9Dyj5+W6FQDe82JR7FYa/Or3Nqua2R1gLZRp1RHdytapqfua6IJDsmUkp5gufQknoUzaEScw
 89Dmg8rEDdMkm11DAYhshLAuYIxsfTVPbkfX02vd+JcMytp8c+WzrbjfpN5PD1z1/lpFSt/cTje
 8Z/a8CCyVaCI9GaDDPg==
X-Authority-Analysis: v=2.4 cv=bOwm5v+Z c=1 sm=1 tr=0 ts=6a0439d2 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=h0uksLzaAAAA:8 a=6zSMeUNXk5_XeOI1LAoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22 a=MSi_79tMYmZZG2gvAgS0:22
X-Proofpoint-ORIG-GUID: x4p5XbSiQTNZZ864fer3AGj7XRd7fqMf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0
 malwarescore=0 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605130089

Introduce a new HEST notification type for RISC-V SSE events.
The GHES entry's notification structure contains the notification
to be used for a given error source. For error sources delivering
events over SSE, it should contain the new SSE notification type.

Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Reviewed-by: Clément Léger <cleger@rivosinc.com>
---
 include/acpi/actbl1.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index f72e00517eb3..2a8167979458 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -1798,7 +1798,8 @@ enum acpi_hest_notify_types {
 	ACPI_HEST_NOTIFY_SEI = 9,	/* ACPI 6.1 */
 	ACPI_HEST_NOTIFY_GSIV = 10,	/* ACPI 6.1 */
 	ACPI_HEST_NOTIFY_SOFTWARE_DELEGATED = 11,	/* ACPI 6.2 */
-	ACPI_HEST_NOTIFY_RESERVED = 12	/* 12 and greater are reserved */
+	ACPI_HEST_NOTIFY_SSE = 12, /* RISCV SSE */
+	ACPI_HEST_NOTIFY_RESERVED = 13	/* 13 and greater are reserved */
 };
 
 /* Values for config_write_enable bitfield above */
-- 
2.43.0

