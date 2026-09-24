Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17AE439004
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235486; cv=none; b=TMMvTtH/pVkH4Z5/4lNPnKegDErul5n0MsEdyxlcu5W0qzt0TSxmWb0Vgph09GoY2Ugsto7GAYMsYE4V75MYsd+e46VotROt7evcsur9Tgz34Yy6PIwM/4Rvd7OB0ONx1yHJ0xP/kT3m4yZp1MY7W0T/6MrP2db0HTyeNKaJm3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235486; c=relaxed/simple;
	bh=PL8UoLF+ygZWvMxeFtx85isf5jQ4edZiCN25qkiuVPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMor+2WkVLNLBgh1ZzObwCmef02CtxSgxyZwlu0XWvxlpzGIi1nQWeHt3CACyawVwhk6E/lshC7JYUOviKTQQNuYEwyUipdnNXNB8CGR4xFPm1HYGVuiNM3Pk8v3FLyO/gF395B/rUBEHlJ4eGY2bylynv0P6+Ahq+G/c/BJLWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Sww/9JMG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eyjUzuyQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Sww/9JMG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eyjUzuyQ"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5e9qV2420865
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:38:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=9ko9wYXNb1l
	9AJ4BTleLCn1bm6Eblo34heY8xr2hrJM=; b=Sww/9JMGycO/MuG9UC6K+WzENPb
	Ik/71spcOH+1tGG/HaLWYAHINktuuyBGK3SROiojJndlkOsmfbeUEC05l3LPaAFQ
	m+XZaOqGc4/KUqv9jRERX/+W600Q7J443C7rTtIwft7ddRjU71oLEIBe5Lu89ywx
	mNIxMEDVc7UROB2DLovIbWv8F0Rk356pjV/L0NIm+EHLgozUs7r5vmhDgsVtuRtW
	3EYaGt4H6yRXZE36c04XUxOwJuGYFZi3s0HPF7XIMIXzEccSn+VW7C1bLPGIJdJA
	MjF8AVgSt5lWVCWsUHnocS/U8b8kYA+7GWtMGWEXz0IA7pW+H/bXST6B8QA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvstuhafy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:38:03 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30c0d568830so3295419eec.1
        for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 00:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790235483; x=1790840283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9ko9wYXNb1l9AJ4BTleLCn1bm6Eblo34heY8xr2hrJM=;
        b=eyjUzuyQVP3Vu1BuqBc8KD1nCEzpx1JoiHS975yD0+iQGNsn9irFZHhdywBvbX5gzA
         +6Sr0ku6UWeBsGxbLhABwoB+X/iVK/UrREx/7xn3Down7uEjOJSxyCkGoK874qDBvQGx
         KIWaZNMolxgRizmKZ9LMb5YGPJBqsWgPMzRCAW00ObJ2YQiFZfqzN4d92EA+SotjYqwO
         iu0kqiiNKh60uijq6v976z6Sc8Agyj/Fx7WwIdkWvRITDh3onA/LBeEuV2xMJEXtuNpv
         HgfcGBUcobw57zCswe/+4lWnFqHixpaqDjiynzb58YG0xizhqUMXFUhk9MhC+sJlybsK
         8gew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790235483; x=1790840283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9ko9wYXNb1l9AJ4BTleLCn1bm6Eblo34heY8xr2hrJM=;
        b=pCbYMEuoRRZpHjLJF1voQMVe2OtcjFdlMnzoIYgt19YNZ2fZN2Ut7RtiqpopcZKFfh
         PawresZH7W5Er/DQEjdtGLSIgL3pt/RnSHFq/+QvzE/wEkgPD/KsJC+8yqUQ85CKW6go
         u79jVjIJzXRvehvQqkfp5HvSBLkIosAAB7E2A8z+6s0SPab8HahX2ZBZWYpPSesbJaiW
         aMPErQRUhFLWoOktPMgVpTBZREntR4vHLqMe60ziGccXoH+jQYDYP0sKeQWYBVxswK6y
         rDrK2l5V+H3UCvNfrds+lsgH5t+XHL4JeagPq7xnralUtIL9NjZTj0yIan/pr+Am3o0N
         cAfQ==
X-Forwarded-Encrypted: i=1; AKwUvByttebxOn1O0amaUKqhK5zuq57Iy2nryHwaqRFpIQpvJAaPGP7zWPtxd4u+9FTRGkN3kUteqOJ174U=@vger.kernel.org
X-Gm-Message-State: AFuF++lg8PrYvL31DyyzXaZ1OqzZ5/O6R9AG2XQyrgiaPrSFV4RSGSDa
	YsbkMaN7kDzLkfkmSdmZDgQpxBi/yjIDJSyaIYJO4pvF+5q8IhlekdbRBeXTTMlv2AWGymvz8bx
	qrRRJy2Oz64hY2iCu5HS/OYGzKBPm4Sz0y386cPf3e2N6DF5bfGXmfdk2RUOvv+E=
X-Gm-Gg: AYBFou3ExJy6GTc3yaaOyy5ZexA32wgtagrDywm/4m1v4684x8qcyO0e7s4FAurRMK9
	TKthr8D+mUwp1sXUXW2lqpXFUXPuARVrf4Ajrebp7fkNRdlJHc8HPoo5W5DBUX6qZUmYJ7OY2Ti
	lTYGLA7jPkHq2yy0eGDme54Y41F6ggq5c5ReUMoLL2Ot8GmQHv+Q7A0aI3JlH0am/nStGKw7FRv
	kbnkWJZh6lCsgmGdqy6FS1boFQhmjssp1K86qP1wHGLHDPBpy7HfbHzwVPFjDpdreKKzKr0tDcU
	rYkkvClJATpYRke6MlI/w1dLb2a4cNXaqaAUZQGnyVEKclZUyNBKHi4ZE3H6W152Bg9D996xRL8
	VAfn4SG6/V4yq2iX8wTfnL+b/Zky7l7Gd5n7nZHhUyXz/+2+37QUh+9aP3RacQHDauCru0vwji7
	tdZUS142sNMjn4So+XXd/hVPM4
X-Received: by 2002:a05:7300:d115:b0:33c:e82:70c6 with SMTP id 5a478bee46e88-34000b32287mr1161299eec.29.1790235482993;
        Thu, 24 Sep 2026 00:38:02 -0700 (PDT)
X-Received: by 2002:a05:7300:d115:b0:33c:e82:70c6 with SMTP id 5a478bee46e88-34000b32287mr1161277eec.29.1790235482398;
        Thu, 24 Sep 2026 00:38:02 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e95c7cfd9sm12120680eec.5.2026.09.24.00.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:38:01 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
Cc: acpica-devel@lists.linux.dev, anup.patel@oss.qualcomm.com, ardb@kernel.org,
        conor@kernel.org, james.morse@arm.com, lenb@kernel.org,
        palmer@dabbelt.com, paul.walmsley@sifive.com, robert.moore@intel.com,
        sunilvl@oss.qualcomm.com, tony.luck@intel.com,
        zhangzhanpeng.jasper@bytedance.com,
        Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v5 6/9] riscv: Add RISC-V entries in processor type and ISA strings
Date: Thu, 24 Sep 2026 13:07:11 +0530
Message-ID: <20260924073714.1650588-7-himanshu.chauhan@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfX4Ix0xX/uwD7z
 1XnKZWsOUlM1qiZ45HHiFmZFPyCRTrQKx/yoR5EU8lwf861wqBfY1K7jRtA9PQoMsDc2ec26bwx
 advRUmC12Iiqtt8WukJqp8gUfA44yXI=
X-Proofpoint-ORIG-GUID: kmiH3ZVeB_pXIyGyjWGyqVE9RyhJrlh3
X-Proofpoint-GUID: kmiH3ZVeB_pXIyGyjWGyqVE9RyhJrlh3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfX+kyRxkgh5XGT
 5P5LwgLEHlmTsfWkfWazjGwaUeLaV8P6ah45NomDJNNWkwhAO6UL9Ikzd6ViOm5hBDNOO/7cpjI
 IAEPm1Qt6Rk3+ZEcNYGMZp7K/TX2MZnh8sW1X4O2YSbq6dV7QbEFxlmkUTLLlMIj12Ldz7ztJO0
 NCohPKFlusoi83K3+aTLrksKsS44TpGZR3sZ8CTGr0vYpIB5qb2JiapSWtVMXPh6GPmU5EColfr
 CLRs1pbjTHgXzQ+XzO94dg5TsJxexIKpJe/tF94mHs5iWUu1c6kMpjvcPiazqJsIpyQ3wTGJCSh
 DAmNsiD7P4tX9YX8qRTTVxnNT7WA79SGqbf8eU6XCwZCQgKCPaS7NOX43nmwyz9q734Q5wKoCde
 BYWtSdPjhZBEG5lAqlr3uSOPRJ/+4f7lbXq8AZVrYkN64F/ptZF16LrEKtBb5m/mdQmLAgdVkyN
 3RelrTQHqBAD60W711g==
X-Authority-Analysis: v=2.4 cv=cKp1IVeN c=1 sm=1 tr=0 ts=6ab4d35b cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=osVkw33_48dge00NZUcA:9 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 impostorscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 clxscore=1011 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240032

Add RISCV and RISCV32/64 strings in the in processor type and ISA strings
respectively. These are defined for cper records.

Reviewed-by: Sunil V L <sunilvl@oss.qualcomm.com>
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

