Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CD73E7145
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235468; cv=none; b=F+6gciyoM5Z1GuRdXXEed12LIu9A2Ou+s4V+5qlFOTn0CUP92USpicu+J+Miz9uAgZASieQu1xBnM+sxgz2PLlWI4j1125uF8v5v9QbypN6lRcaodrp38xHeGQv6eBzhjmSvaJKKqQ9lRQQV0OL6GW3QSXd93BDtyn10wIscCyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235468; c=relaxed/simple;
	bh=Oc/lCz7J8IDjeFbK//EJABhRCbxS4k/rXQvZVa9k5zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iksesc+DKRseYeZnWpBoaxuWwnnC6576HZvTDDF1ScxOKB7ShxP8+BoHloyrZFaA5VjPD24/NKv1voremMIbzOFpGEVlhsPEOeb5mu0Xf//q30Lvgv8lmOgK4+oOw16mCiDhx0XrN4G00qiiprPxZlKHNBrUIU0hvV6uZg5svMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Pe/wqpde; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UYlF5qdh; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Pe/wqpde";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UYlF5qdh"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5eD1B4147349
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:37:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=pB6vrkBAByF
	zx3Q4zdQRRWEh7E4G3c0it3uuIjGmP0k=; b=Pe/wqpdeZ7PC+JWlQFS3sxeFLeb
	VUsxqEQqq4j43LQi5K6bmjtMVe7Can69P1VvO8utIXIxZxaGAqcbWbWuKtJ+0ERB
	VZXYDcKsb5/ELqplhyGtv3Mk/SyA7RmxMMJbC6ilvS4C1OCEKsNmNAjRCDAjZMQf
	KL+Y4zIW9MxZc6t6MrUuM+ZuP1ZPrfgA4p4fwYeTC6KE170rqUL99gsiG/IP34P+
	WJTMvjiYvhxtnkXasP2Ll1k79wUuhRlpnB5fJIWQ5jC4+FP+bTppMR/qeJUrvXLY
	vNQ1mDrluGHUlzuyeuqS80C8X7Dw8yyHcLUeomlQimYC7N4vdPid+uB48dw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvfjv3w3b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:37:45 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30c0d568830so3294979eec.1
        for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 00:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790235465; x=1790840265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pB6vrkBAByFzx3Q4zdQRRWEh7E4G3c0it3uuIjGmP0k=;
        b=UYlF5qdhOpYE16KUs/klRp6Eh4o/a2ekJUmInmlPDKGOEw0SUci+knkfvn3PQBOMyI
         izp+RK0FPPj5l+6TNDr0zG6ozKqCYs5jGUxZeMQFxL2soGUm1uRwYIa9IkWQkMzoUWXz
         DLMq9MPd3nR4wCGEX6yQSuZU6H5QbaKE4S57ALDawdEtFgqKfa8B1N0EGCBJdq9NhDXS
         hdk0And4fpnATzargNARVszfRfbzg1fS46LG3hbnVgvtGy4OnMSRRkcPOgS+IQp4Ujbr
         ANNzYO1Sa+TOZsUb5CHTRFEGyENehbc2ypeg42P/F3hgLTLspiLvVXZclTD9MYIEprqN
         yNpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790235465; x=1790840265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pB6vrkBAByFzx3Q4zdQRRWEh7E4G3c0it3uuIjGmP0k=;
        b=BQKwJhZZTdhJdLvI1X/iZr2Y99TKOTKs/jZUI8DfsOn5aOFKUM1Dx1zgcTYBH7KDjA
         kibAehj62JcAw8315e5LY6V/5EjUvex4sksrBhgRuiUIRCosx71bPTzpMkXcV0XDlYx1
         merDJ7zuTiqUDYy37gPtvHoAnzyFM4kcq3ge1tOo/P++vq37Rv8vs1Lz0O20wnf4oUHW
         EaFSQFPev3zcabQJP6HkkIy9n50Iy47JsQDMuUZrYH+O1+zF114LLDalxSUEndoj8G3/
         fk403jTLJzTe3w8vwVOLys8hVP5z/wuGz5KCU3RdLjkxdaqQoiBNCl7sZUUIGv9z1uS6
         1Rdg==
X-Forwarded-Encrypted: i=1; AKwUvBxr7hyJhYQRgz2d5dmZHnzBC0YiaFsYSFGFZB5BuKzdXNufUprwgt2M89WR/PLPBohP3BvdFJv4Quc=@vger.kernel.org
X-Gm-Message-State: AFuF++lQF2kzWHKR+wA1Ey3GNlYI91/pzL+c3VtA0FW9XWfTCwF4XOle
	M7Kj0EWzdaMKwCrb8hv6amCb17q8mE3nhjeSBgf1nsRIpvhLrL1C1Qb6HfTVS+BhfAmlOiKZOF3
	jMYTTUn4DP5/mKVnLRb8wKR0wAWOo2olfnaA0mIAI+twCcAUb0e9Qj+hyeE4LxgE=
X-Gm-Gg: AYBFou1scQYbfywGEeKNECL7G7RMcH48LGIUz8aCuNo+22gd6xbLXafHb/YKL/mIOJC
	i4+vDeKjEOLm4qNzXqfvZJa7Di6WKYmT0SvCgukhDuanjEQCOurkjhGz56yn8nxYx5fmJIYvl5u
	8XA1s2CWf1buUA1smEzkIqrsOc6+w6DbTW/xpMOODBZRkI/4QBFDQ0+5CYuX4+Bsl45Vbp+QuyG
	fEQ7GGA0sPWEUYGI+RPZaUIHuXw+5zOXKmGJVI3Mb/y8hVi7glfCKDvkKaVLAv2gcZZV/hdRghR
	lEF83xWyrJYATaBzUnGeABew4+V5tWc3HWXBIYIh7J1fX3JQgW0o+WYgOUqDM92LV3brdqOEJG2
	mwo/mFNiJsMeBTOkuHFfOv+iSSyqqVzYuduSdaG4GRl0rgKmZceejSKevXykht9U8C3WXF6VsFN
	gk3+7gu2jrD969eXBC+z9IL/0V
X-Received: by 2002:a05:7301:77ca:b0:33c:e93:764d with SMTP id 5a478bee46e88-3400151e050mr1333098eec.39.1790235464789;
        Thu, 24 Sep 2026 00:37:44 -0700 (PDT)
X-Received: by 2002:a05:7301:77ca:b0:33c:e93:764d with SMTP id 5a478bee46e88-3400151e050mr1333069eec.39.1790235464103;
        Thu, 24 Sep 2026 00:37:44 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e95c7cfd9sm12120680eec.5.2026.09.24.00.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:37:43 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
Cc: acpica-devel@lists.linux.dev, anup.patel@oss.qualcomm.com, ardb@kernel.org,
        conor@kernel.org, james.morse@arm.com, lenb@kernel.org,
        palmer@dabbelt.com, paul.walmsley@sifive.com, robert.moore@intel.com,
        sunilvl@oss.qualcomm.com, tony.luck@intel.com,
        zhangzhanpeng.jasper@bytedance.com,
        Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v5 3/9] Introduce a new HEST notification type for RISC-V SSE events.
Date: Thu, 24 Sep 2026 13:07:08 +0530
Message-ID: <20260924073714.1650588-4-himanshu.chauhan@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfXzqWIVl01wwsj
 47x1T4jEGY6GvoBA3sGwiDNk//BLJb5ebcq3epoDGT3tifaL9qKurjmd2VmxQv7RFittmlWximA
 UKahd+sbX9sSQu4uDQ1HNmpETLXhuoQFrvk5fHygIt8EzWezewv9JJ2WDMDbm9sQqBebliKzn2E
 XwvSAhv7Iw9q5tWXdM1TKezD6+WC9O7k05qivNk4hgll9wLT6jUis529CClbIHb0pBakny98jKQ
 s+ykaQJu+u8UFwGSBG1Kq50O493eKbL7ccV34fHFl3tYh2q4eV2u5ACO28srf9IkXUC9vye6Xiq
 QQKeYqetcm/UEzSEZz0tEScJ2vuZJiL9bi4psJzY3wl3cNWNs31OCYN+MrJgzq7spw63sq2tu2N
 yoiK6pRw4Dr1uj0iJJ27T2x9oFuwSYUVZ9x4PO5Fr8UxrNOracZzm/uc6XYvf5LC+FWQzWrXhK9
 iEjwHxhC8Pn7t3t10zg==
X-Authority-Analysis: v=2.4 cv=aIxlOr9m c=1 sm=1 tr=0 ts=6ab4d349 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=NEAV23lmAAAA:8
 a=EUspDBNiAAAA:8 a=6zSMeUNXk5_XeOI1LAoA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: nChgL81LmbA0x9PCrFPrQoc-UIVg-h07
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfX5zKfX/5JFqze
 Oza/ZwphPJNfIacSIHKAWxglSzgj91FSn7G80SzTcgZjiNqnKmJ5FG1bEftYFvcec0Mxr2LojK9
 9xxlLIY1KjTlRDOUe0oyFaufW92bc7g=
X-Proofpoint-ORIG-GUID: nChgL81LmbA0x9PCrFPrQoc-UIVg-h07
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240032

The GHES entry's notification structure contains the notification
to be used for a given error source. For error sources delivering
events over SSE, it should contain the new SSE notification type.
acpi: Introduce SSE in HEST notification types

ACPICA commit f73f39352c1170464afe812cc96b20cc9db1d822

Link: https://github.com/open-acpica/acpica/commit/f73f3935
Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 include/acpi/actbl1.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index d824838cb7af..105fd51f83ec 100644
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

