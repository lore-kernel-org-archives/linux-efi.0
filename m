Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5693E5A0E
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778661876; cv=none; b=FncekqdzkGx01FZKZDJE7p27lmQRvngAKzlg5aYnAiouNTJBbUKQQ7jNx6ItXVGmsHRdD7STYdYJfjWictORDH9/jleV9p2DA+cNEnBkWHwmcMipq9EJOTe9G6z0T2UJW3oDi7KY/DYUxP2KoFGpcmn/0McsE5P+xWtGzBFNiRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778661876; c=relaxed/simple;
	bh=Z9H2IrGiWap4bBYZmAUQVqDaXWdawcf9g8slb/LeoRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1Z16Bu8VuziT2Qbusi9gbkOPI4nxq7tO8GiTxf3tEnPIkF04bKLiX5Wt5WbTc0aZd0loUHR4F4PKE1hNDo0BVM2b+iIg5lRYkdjV8ApvBNt2mpDk8QDw0/fHhAdwO1hNeg7TILu5V6HuiQ3TJxVUAqlzHUfNvVxkF6KZ0UQU8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UmLLDQ0e; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HIJ7meEq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UmLLDQ0e";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HIJ7meEq"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64D4pLnn2321427
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=BpdgYqVS356
	+a0fEP+B5YTQRF4fTcXzt0S0SRfD6Nlc=; b=UmLLDQ0eXSzNMvpwnLG5/XnOyZN
	3Y8BRA1m+a4WyZcjb9sgMyCKUQ+NPMzjS84X2m6RKMGTWNoehW5uJYRVawYCpZuV
	Tbnomd29MYOIGQHX0OQgiB9yJWSKfVgJu06ejrnP+U5bmKH+GWLPkJb1yrAkWDsY
	oJbWG5cENFhsctGn8qCpK23+br2yfOw31dTRp9Hrc8vg17He39SpmTyuFgD3iZhh
	wjxDYdpLW0HsnJc6xnTcfF4hsU5vzG8v0szRlR1Dam/7j6LrjXQ9oBRKxHm6RpgI
	4QeY50BLqf8/+vSQQM7jgNWPN3QX25XADJ3vP0T6WrYl5kx7TePxCt0A9uQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e4hgu93cj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:33 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2babbeff9e4so77896445ad.0
        for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 01:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778661873; x=1779266673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BpdgYqVS356+a0fEP+B5YTQRF4fTcXzt0S0SRfD6Nlc=;
        b=HIJ7meEqseWFuyvWVFgzKOxytYaLV52uE8e3JI1qR/CyuvMszczc3VslLghjUtC+PM
         C65KsbTFa9Sq3iIxxi5HXm9zCoSYELA4CUOPXU4ktM3QJY+zP3kTPV8Eum/z+9IUU45o
         IS1pKpqe40tqV299mg6NpVcYKGyyzqIueZYkBF5N3f4CfdRzzC5+cx77YLEtAgdekN7u
         Vb4YFkv64i7xGzEBbmNhv3PHURYmOGq3Gtw/ky3qiBuZ9c3B1qGy0YG4TogtYdSRVYk2
         PLi+0vcLQzaHRFXCFW/g97x4dWHVTYtwXMct2NPz56H1nBbvI2DKtovm0ZNnu/+jjEL6
         Xy2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778661873; x=1779266673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BpdgYqVS356+a0fEP+B5YTQRF4fTcXzt0S0SRfD6Nlc=;
        b=sWVhDzF9ehyvt7OgRCE0otKcm1aBWaby2dqG+FpkvUNTa8PKRz6/7kISNqFv0aVBK4
         EJtHd1M5ETFzKwMAnLjz0l4m6mJhjfmbK+TxKqKRzwfWg6c1B0A9OhD0FsjcBpqXL/aT
         8pYZmwb5cNWWl2+bt1GTinjgWSIT6BZXqr48dlmNMnAYYcCTZJ01ild0cf5I9q9NEV6H
         3IE/uzrVelWutzFWg1gnBgUixBGBiDmDcTVrXWt8Si38rgfG2xu8Om5P/Z8zLkl6+wdu
         gCQ0/snLe5E+aqDRX2ReqO55tHKSlHPhau2U21KYF9tS5LvrsUI5ZpPGFO/slujx7wmY
         ZX2w==
X-Forwarded-Encrypted: i=1; AFNElJ9dQzBogyDqs63sLaEK902XBexi/S1JKllicMK/xjIxBo7wyfRA79GASJi+4T37HMd4EFv5Rj0labg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFXYLaZLXXivT8tbfwB19dtWMTp3Apd2ON84/BEFDX7Jo82OT0
	OJDHH2ZJnw9IcNrdUQmeDaw8UFAVUY90pUlNrtC++g9LrM1UJ4qWV4W+dPrmkRmkQ6srgCw4c/0
	lPKOKULv61ThV62vYrRKGjEnKA6PJT520GiVLiwZYP8q6pobtmJ/ibdU8sdqP8nE=
X-Gm-Gg: Acq92OHm6mrMjdNDvoVXrUOtnG3yOTuu7YAm87+1oIN1W+mfLxWcGJbiLK9mg7qCISL
	GdBtbaLWbGZBa5uh9tH7S15tVyV/Ambm9gLrnKJBQjLZqnafxtqjg7gWqCAyzaq6ptLiiH2oMIh
	fSTlhHkHuIbkGGndHjLPtSrXiMaoiQ3fZwWQXMLztZLRTkX5GIV598WLQ+wdY6i4VdvFkF14BJ+
	+QT/N1g6fJILLBXnuRZXHOaVThP+K7kP03LPE065IscgGJ38CAR5Fgf4r/ZxJRUEQv9UHfq7RXn
	TpGp90vqduAXnsEF13T7E3+C33kOxn0jAGD/qWkTrlLny8AGJY1if3DfiUAbk2phXHUbKwTMJbj
	R95TnT0BDiUwI4KXRn+kRSkwgmnRmjBMlQRsw9Ro91WXzkEY24lNDtNpEpcxB5L0ryMn/FZbNRe
	3ZvBTV+rtJZ3Lz1CiXjxDyK3EWK83JR7laW+VRc9hFSKcJnA==
X-Received: by 2002:a17:902:aa8e:b0:2b2:4bbc:14b0 with SMTP id d9443c01a7336-2bcfd48a8bdmr42628625ad.20.1778661873026;
        Wed, 13 May 2026 01:44:33 -0700 (PDT)
X-Received: by 2002:a17:902:aa8e:b0:2b2:4bbc:14b0 with SMTP id d9443c01a7336-2bcfd48a8bdmr42628535ad.20.1778661872580;
        Wed, 13 May 2026 01:44:32 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2709bsm169158725ad.5.2026.05.13.01.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 01:44:32 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org,
        acpica-devel@lists.linux.dev, paul.walmsley@sifive.com,
        palmer@dabbelt.com, lenb@kernel.org, james.morse@arm.com,
        tony.luck@intel.com, ardb@kernel.org, conor@kernel.org,
        cleger@rivosinc.com, robert.moore@intel.com, sunilvl@oss.qualcomm.com,
        anup.patel@oss.qualcomm.com
Cc: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v4 09/10] riscv: Select HAVE_ACPI_APEI required for RAS
Date: Wed, 13 May 2026 14:13:24 +0530
Message-ID: <20260513084325.2176952-10-himanshu.chauhan@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=X4di7mTe c=1 sm=1 tr=0 ts=6a0439f1 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=cq_Hu0Mfxj2oTTqF29wA:9 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: R6pEkxVh51C8v1DnSgWOSzsBFMiZ_WnN
X-Proofpoint-ORIG-GUID: R6pEkxVh51C8v1DnSgWOSzsBFMiZ_WnN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDA4OSBTYWx0ZWRfXyhZM76IU1qEW
 FilipmCaVazBJUWsWCLqP+/W+/ZLmQbZue77hLbm5hO41Cj38GobpPKpkvoXM0FizeknTQP0Wn0
 Pq6Iy71unFAim5xvvxalYpvBC3yckDsERJY5X/x1Ko244VT8RVMpzbQ9+Qgep/N1gJIxmi4Fv/A
 MN7WSFJzkFEyRUXgJuvumoxWpwtv5fbPAnUbkUT04DlUx7KFMqoped9H6gz8VvlBmty6UnjiLSl
 zgiipVeID1JKYZ81LXWRszaAb9LNtzqrOT2Gqq89yOuQ4X8zm0g0FVNdP9h+iZt4e0k8vXejeAj
 2VmcSkv21gwsSFS5+4DSUWZUT0MdLsynSkTHtBHn7jIkASsH4mPQhNLoXwBTmpgcmhd84zZVyXI
 MaAxDVJXTA4k3wDZh9iSvu4RJk5hC7ax/gFzuATqSltYlJl9I+NY4qRcsjAF5MYDr148YrXKoQL
 ChXw7Rwh/1eEdJjfC/g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1015
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2605050000
 definitions=main-2605130089

Select the HAVE_ACPI_APEI option so that APEI GHES config options
are visible.

Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 arch/riscv/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index d235396c4514..b94b19fb4249 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -187,6 +187,7 @@ config RISCV
 	select HAVE_MOVE_PUD
 	select HAVE_PAGE_SIZE_4KB
 	select HAVE_PCI
+	select HAVE_ACPI_APEI if ACPI
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
-- 
2.43.0

