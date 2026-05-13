Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99843E5A20
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778661866; cv=none; b=p/Fv+4EmK+IC19oq7BaDNAwKUYNcj5og3/skInI37P8v9dKMwdhC6ekrxu3Pu/oleA+EjHbg4YFZdl02V0wjQedt29bTF0v2EhIP7MnSuqtnVOK8LDsNgmp6IccdJS2uM2n/e/nNVkUnw8viMXwRzXXCuu38rDJl8/HzLxKVVAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778661866; c=relaxed/simple;
	bh=nvHY3EcHTYRY9I9aMgWPVt8VieEY0jbt8ogsXLJbOJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrfUxYFQ8sNeyALRyPlyaVmqN2n+cfjI57OPrY2yiXaWZoxFmUDbrxfUQZancXvO1G/qYI4LZ9FqgyZF7TAglve2Av5fypoUa58fzpkSBEq871CAa0SyrUZiHhFTjt6cQxGm57Pgx4IjE5qdNgn3lEjZVvHISQXw77qEsmMexaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YRekJzfF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EpERTJXH; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YRekJzfF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EpERTJXH"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64D5JcCF1393176
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=NUjop8bIgjc
	4kzn5Txli1zlGm+BpePPllAZ0mN/qO84=; b=YRekJzfFZ/MHDlciDtRpJz040hC
	BlbOFPswO1P456inpjHtRnZ9ouyRtT0MY0O4FkMSeLeSm1WNmh194NcDk1zClm1d
	LbNeJVxalCUmw4bhrKN4xCzQkcIyfPhdcmwfo+iLf/3WxeLsfCKiihuINxAYP+2m
	RcwuHFrhocW4/fVs4vP6a2UQLSAUhBMHI3m03Img7RZCX0gsjPivVnUPBVVXmUv1
	1Gro2I3fb6r5zZXpJgY62ZBZa7c7q38FbGCX2x2mcmro4L+rq1eISBTCY2JWHnXc
	ZTDAXySzbbSg2F99Xq1tIZkMB8xu0zPxhHMBXjHWKHn1bBdiWssE2BjcCLQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e4k260srf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:22 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-365faf6006dso7610223a91.1
        for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 01:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778661862; x=1779266662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NUjop8bIgjc4kzn5Txli1zlGm+BpePPllAZ0mN/qO84=;
        b=EpERTJXHTwBy8KXwHIHVghUcNPdhOn9OLMzokJtmu7YOt5w2tQPWK+4CT5zL7YppKu
         Qxrfq3dPwH4xr7Z4SKUsWN4Nxu+3BYTM4zFDJ9PCmaAAsjQgsK2mBddU+TsFAya/8fyJ
         4c4wxzZ+9AjfmTCUFPvzGno8K2hDL2Y4oYTliXVHJoFugMU4kflb2qFVQ3CGux+9JepG
         EnK3dcCMcwbDrCA/x4T9qBWBvrUoqhy6VRknYe7I+B1ksPyFFR0Mit0VHVQBYWtcBs2r
         Ca/K6bSdYDsT27wy5F7+DrHN4ET6CnTPolk2Gxh46VK8kaQX0sy9fWQlsiwOzUF3sxNL
         /9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778661862; x=1779266662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NUjop8bIgjc4kzn5Txli1zlGm+BpePPllAZ0mN/qO84=;
        b=DAZvelv2nsdAB6E4si4S0f8ILhUH6Y0uMxs6Hu8Gev6R9fnHogQrEbOS8loy+TO0wx
         LnTYzjNh+ETlj6o9OzTC9S8adRpzzNh/TkG0RDw7hioJ+sdBpeKseF4RXss0APOF9oXE
         9vcUQsNAlcJhQZAvuUzRk/qJdxbGmWgm2r/iamUqfFjXjS5DfVmc1bebLA+OLK+XrelJ
         /TzdmbyNkrYh4Phk+CbGVYlsKJYJGTe5ysUC6DoGxsIBHkEVnMBZFFsfD2x5v5kMz6kJ
         LdNo41Et/2GSMImukt+hixP0wOb8wxPVebJDhljZY5EMtgUef1LdaeDW7Q9CvGGUPfWc
         hReA==
X-Forwarded-Encrypted: i=1; AFNElJ9TU4N+kLKNKh+FRvbwdyzLpJ3sGjxwmTGnetEpbeojtDtbYwyA5rnWFAl5hLLfbYgP0lCdXXcheYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy97a5ZnQiyNAuD9GwTzwBrux16kktlkJiKbMhShwssbkvlsHs/
	rJtzZslxQdDrxsYpNFnHZqCrSG7SAmk7r962mlbAzsBXyC6466RyZta2XpjRBe+GYr+QmB0b+PB
	1iS1ipfTmnowOR3nhqj65siKX8I33KDhLz8E4goZnjyCaq5cQqNA8fbflwb7ZX2M=
X-Gm-Gg: Acq92OE+o3CGY5mkiQQmg3uHOoHSEh7qDXwWTe09ku+/GBzxyFgAK9ULPIR4lyLm94U
	hmIbDS1RGivW0wzghq7OSGTbaYBX0DdiIe2DsBSh23ZtYQzzCdIVOemcuKkcXqGXYZdEBka0bcq
	1YUjl0j8FtcNDntq0UYf8dis269Ak1vxFHlS+ZIusGf+krA6SZVTOMO/MWJw5aKYICQRmDr2+Xl
	D5/6BT6igiTfI3db8nGUAgRlrfwGnciJxG0QyoivCNjxar4XAarRNs961ngZQNFzzBK/WKaJDV9
	OKWT9JY2bdBftfGv49v2VMYFRc8UHos0fUz6FQ9k93P6xtOzrFQJQwMt96+hZW4l+RZuW+ilM1c
	e0FpV+8HKgoOldJPlBWMObiifGzhsuldaXdjvDaBHiv3I9AaUyj14VBMXH3h8a6KUlldyf2iR3b
	YlDU70xDvIhE0XEZHc2OA4ybRmpmK5KZAxubkjFseeovamRw==
X-Received: by 2002:a17:90b:3845:b0:368:1064:62f2 with SMTP id 98e67ed59e1d1-368f3bd83ecmr2662359a91.3.1778661862221;
        Wed, 13 May 2026 01:44:22 -0700 (PDT)
X-Received: by 2002:a17:90b:3845:b0:368:1064:62f2 with SMTP id 98e67ed59e1d1-368f3bd83ecmr2662325a91.3.1778661861767;
        Wed, 13 May 2026 01:44:21 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2709bsm169158725ad.5.2026.05.13.01.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 01:44:21 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org,
        acpica-devel@lists.linux.dev, paul.walmsley@sifive.com,
        palmer@dabbelt.com, lenb@kernel.org, james.morse@arm.com,
        tony.luck@intel.com, ardb@kernel.org, conor@kernel.org,
        cleger@rivosinc.com, robert.moore@intel.com, sunilvl@oss.qualcomm.com,
        anup.patel@oss.qualcomm.com
Cc: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v4 07/10] riscv: Add RISC-V entries in processor type and ISA strings
Date: Wed, 13 May 2026 14:13:22 +0530
Message-ID: <20260513084325.2176952-8-himanshu.chauhan@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=M/l97Sws c=1 sm=1 tr=0 ts=6a0439e6 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=osVkw33_48dge00NZUcA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDA4OSBTYWx0ZWRfX19guY6F6X0d3
 hi6eB9+mBgzx8uOJXzkXmbx8IhKk1u+HveP6JfjwYhE9vDFGnwI6cNTLn7VP9aPwRUTHuipfsjW
 VFgwHXmv8UHb02SwwWcWdYxQ5YluV0y+GZhMYt6FyuiKmYZ6WFPEcJ0El/wSy6FqFv6lZJRkhc2
 CpzjBUpKNXdkiIweQJ6u4hjt8W0i00QaNm25PC5Mfi8/O1oT+daZJfuBzhxpYS1jPn5XHUX+kWA
 BtM1ujxbTFlezAEDhPmoygoDsQgN5iy3mlzt5Rej/NnOw0PlPYDfCcftEYuHGkhg5ePlpoKsXjS
 RlIvRgtBuYyr4c97d6CpLfFToc9coSoJKXfTk4cR829GGhThuUpqzhlG/YS42KLg6yc1TEUHeN/
 lKKCNfok0O8Mkewz6MrH0oxM5bIubVVe9TVTMWJK0kvWz8DEIrmorTCAo+ef2M0nJAR7T11Y+H1
 iyMnTkiQWIgN5Mzr/bA==
X-Proofpoint-ORIG-GUID: U0nsfFd2m8p3iDRDrrnxZphS8FTDs86p
X-Proofpoint-GUID: U0nsfFd2m8p3iDRDrrnxZphS8FTDs86p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0 suspectscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605130089

Add RISCV and RISCV32/64 strings in the in processor type and ISA strings
respectively. These are defined for cper records.

Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 drivers/firmware/efi/cper.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 06b4fdb59917..1b1ab2f1355b 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -170,6 +170,7 @@ static const char * const proc_type_strs[] = {
 	"IA32/X64",
 	"IA64",
 	"ARM",
+	"RISC-V",
 };
 
 static const char * const proc_isa_strs[] = {
@@ -178,6 +179,8 @@ static const char * const proc_isa_strs[] = {
 	"X64",
 	"ARM A32/T32",
 	"ARM A64",
+	"RV32/RV32E",
+	"RV64",
 };
 
 const char * const cper_proc_error_type_strs[] = {
-- 
2.43.0

