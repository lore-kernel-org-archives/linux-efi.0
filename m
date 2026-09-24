Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75504334CA
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235498; cv=none; b=iG/OAZ+X04SNWjYHaWidQ7ugMJuBK9sENiiSgbu4eDQnfKYzCghYKAW+dbmjvsC851DMnDX/xV31mA2CNlzgazWuqf3Tqh770HJqX+nUNj1b+vw97VTt9tTVIO/PZJSojCHIZIH/nkqA3VbHq8/fPeuVlnO1+jJ/pf30Js8wggM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235498; c=relaxed/simple;
	bh=IPDczm67WB9cdss4DG7r4mgvBThj4nInB+DV/41f8tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwUUTIz9K49V2/ghS4f6KEx2IF7W/9s2pQ5SahhS+LsXtQ4TDfuxK6j4U4sjKYCncqTvC5vl2qNq5VreNQvgzdu8tNind98IeaOJxPT0y22m7EXN7R5lVQYtTPD/tqS+zJNfOiRpzVFLxcv3rSjyXihXOCcRhQVYs7+UxWNRIqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZBLfErtj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PCJ4dnXs; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZBLfErtj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PCJ4dnXs"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5eKX2582475
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:38:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=c4sUVCmmjjo
	/P0eMok8JUuO6sZJCdXw8PrIwaTMTfUA=; b=ZBLfErtjnHbpJBbL2C3TJnOe6dC
	rnrCo7Njc0NBxWlfBgH3egh5mSCMfCi72t6i+zCk+AEp711U7KE9VOV0nN9PzMY9
	HgMn4Drml+qLliqS3z5jQdWXo5MVVXhhS0Jg2sAgVWbnylsdfmUsGaL5n0jdEeWi
	wJYEJDAelI4PCLyCrbPjyk2b242HOqHdau7MfxrctdkRl5nNfAS49wyu+g9klAib
	88w7retfxiU0dHd6Zrywd6pZPGn2ZeQHbLj3qH/4Ip+S7vfekM6wcUfB0KgEjVxW
	TCChsOlO0SekmYqLNZjo4QS7M1DfHcTOUgT4hlivSPT/puQ7W7w46YDLmFA==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvfmwkwux-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:38:15 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30f1b904861so2472440eec.0
        for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 00:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790235495; x=1790840295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c4sUVCmmjjo/P0eMok8JUuO6sZJCdXw8PrIwaTMTfUA=;
        b=PCJ4dnXsgqIKXoIVTPVpokOLAt2vgqTddPLg0HboYMqUyfsUohccjMTKvMriXc81FT
         eaVoOwwoCXayv8aICrIvSlxHaTKM2aZuAtw/m2Yk/S0i/ghBqNmpork2pQhrMOzYddVE
         1BnObrb4tRMpW2o4dnVi2a2FuyIYS3RtOz/RURYwJx8YCJpboOGsKj/uSUqfJzbTUAo5
         +6C+pJlY1AHAJeSwly1iOZidRmkDZqLSLSiWmaRb9zhMW6YiGFOaXb58qxi41ONw7y6u
         fOsYV4cYd9q/mN/QTxxgMXc4FLBFEBwDNReJsVW9hVfmtn+jWnuwp8Gu1cddXjxLq+4K
         30uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790235495; x=1790840295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c4sUVCmmjjo/P0eMok8JUuO6sZJCdXw8PrIwaTMTfUA=;
        b=alU4eJzCjvRuxHK3ekWNJRtqgZV/9Ddkjk4Hjb4RZxI7DMgmexIUS47SBAw2C6eSE3
         NM3u5w1XokuIq5W9Gq0dzrCjJLS67PevvASFAYeOImkA1jyY2SnFt92FN/9rGRiF1t3/
         5ro0DJ2iHahAxZeLOgbpo1s053XfQuK0KmiEY/g5cQiRoRhBHjOB/w0OMRttCLfI44ZW
         2Vb2C1YcJHkti4HVBaffA0nT4yY6buySnt8anh3Tv7eJzQP2S/Ir5MUaJE9UmjlJIidg
         KpI/nECWT3su5/shuCInacmFltUTVIgzXF4/6uluonx9LfzB1Al1W40Fo20BBTENXxKk
         ZRRQ==
X-Forwarded-Encrypted: i=1; AKwUvBwAm6Cswl5xx4i5VbpBMCUwjJNe+UGHEBGaPR0ZxgJMiKF7EL+G5qchBSlxrhGVG5gCupgTQv1t5uc=@vger.kernel.org
X-Gm-Message-State: AFuF++kCohDCl/USEtE9C1NyAmPdKmyK5TbYlm9sxWL9GEj6I3QWCvX/
	KHmO58jVbSc9wLMgPxMdjy9+wTGY7Hf+/SyDzT3517dnfmGnPEDGp/FCQ8xxWS7MwwuoPvODINq
	neQ8cHoN8UmFuPVVui/hI/UVde8H7yIsN+IzviC/XjaxW+rjBUgSs3jMdltVs+qQ=
X-Gm-Gg: AYBFou1cf/0wuGztOiMVL79dkHp3Zs5jmPgFrHvHHRUySXqz93mAxaP4NAq+EDWhPt7
	+weIfisotFE2Zt4HjYYOjOisjYR00xarIpM7cpxu2OxlhKk4K13W1CiQIUc64SQtaNux/gi5E5f
	Frsmvrfi0i5ne49gpfnGcOEjpkkmuNQe17BNH9hWK6p+nWp25/l9mVBdfSXtNZVZkXK8SecCW9c
	HG97TowWAGF9CmhWG26uKursOOUmhaDh1T+UZU4LqtgtW90un14JNg6niWCxeTKMr/ibf2u+MsM
	24WiCFuWf/33s57HY0HcoH0SeNcKQOdwgLPvxHEGIrj67YLqjpFJSRmI3SGs4ospuv8FNSdpdUB
	AnJd15APuSMd97smbw1GcwJSEaewv06QrwrhNJEJW3+i+cuzWdn4hu/ILbdjYDlBph4l+vRz7sN
	uz/pKZyczJgNdpMjgJLtGqMBGq
X-Received: by 2002:a05:693c:821a:b0:33e:699d:575d with SMTP id 5a478bee46e88-34003ca6caamr1230463eec.1.1790235494695;
        Thu, 24 Sep 2026 00:38:14 -0700 (PDT)
X-Received: by 2002:a05:693c:821a:b0:33e:699d:575d with SMTP id 5a478bee46e88-34003ca6caamr1230426eec.1.1790235493990;
        Thu, 24 Sep 2026 00:38:13 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e95c7cfd9sm12120680eec.5.2026.09.24.00.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:38:13 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
Cc: acpica-devel@lists.linux.dev, anup.patel@oss.qualcomm.com, ardb@kernel.org,
        conor@kernel.org, james.morse@arm.com, lenb@kernel.org,
        palmer@dabbelt.com, paul.walmsley@sifive.com, robert.moore@intel.com,
        sunilvl@oss.qualcomm.com, tony.luck@intel.com,
        zhangzhanpeng.jasper@bytedance.com,
        Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v5 8/9] riscv: Select HAVE_ACPI_APEI required for RAS
Date: Thu, 24 Sep 2026 13:07:13 +0530
Message-ID: <20260924073714.1650588-9-himanshu.chauhan@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfXxiBo+DlM66tV
 vaVDlaKrs82rx7m2MCflc6Bm71ocGdEObCpTM14psRT9Mj3kI4hLdavimlPqknGkJjuE8Gl6VUa
 l6qu8rBiC8oNkDPC7Tb89oBcgy7As97w0t9y4wWs+ymvrjdjiwTZAtQN6k9ZgO+rRrYIZqFU7Ru
 4T2tzEJLBRtppN4LUNSqwQYBbdfo/cZqGOMj4Ov2QTTUqmd3kr6if3R/3PruTi2/PLoaBwSNTru
 i5l//Sei6q4Zsvq3BgIaT9jwlNz1CFoGbTXP378pnDCKDABCsHOK2EOpge/3cc5ziJhmFGACcvJ
 h9MHahkZCT8B+cHkirLsAikvfItZ+J9LGUHZeToMvk8FlKMgcGRPnNfg9w20hY4aByjVLMkex+6
 FdMj2pKmtbIlk1XZ2phgBAZnJUOpPZI5xErDXSwprh2+qJYyc1iTF+O9Agc2O5nXvHFP71NX0K1
 PoAv6QGr06/AX/2Is3A==
X-Authority-Analysis: v=2.4 cv=WK/qzXsR c=1 sm=1 tr=0 ts=6ab4d367 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=ctgbmQax9_dbRqqonagA:9 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfX5mVDLYaOgKZ6
 VssXCneg4S09OjW7lu3sNOUy1spUDdWhQeeCvlo3sLJxL1h1oqhaEwl8l8p1sX8Nfmajgsvy87d
 phBP0JR4bDSokYav5YMYQ6IBKYcblHc=
X-Proofpoint-ORIG-GUID: LX8T9qoNDz_TU-ymgeIR1EVXjWPvNX3M
X-Proofpoint-GUID: LX8T9qoNDz_TU-ymgeIR1EVXjWPvNX3M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609240032

Select the HAVE_ACPI_APEI option so that APEI GHES config options
are visible.

Reviewed-by: Sunil V L <sunilvl@oss.qualcomm.com>
Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 arch/riscv/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index d6c2dbf8455c..9608abe126a0 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -191,6 +191,7 @@ config RISCV
 	select HAVE_MOVE_PUD
 	select HAVE_PAGE_SIZE_4KB
 	select HAVE_PCI
+	select HAVE_ACPI_APEI if ACPI
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
-- 
2.43.0

