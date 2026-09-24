Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A7540D587
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235503; cv=none; b=eLC7VYONVqXvzPqwGzKpHKovc7JA9pF7mdp7Qg4kYPi9xIfZkWYiXJd1nPUd0mMHVmz+cGnWvPhZN+BjFKWQezohazNWPd/jjWD6RVjSW0viU9p+pTK1YbIugCKduG0pe6FZKsB4cNZG+ULmW6njoCoL+jz4zizjLu1IsCKZXJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235503; c=relaxed/simple;
	bh=8XXN0JGE+aNQHVmkja0kyVPhb+92/XFFTPds/Qxn2ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ipv3OhLyFePi8ljxqgRDdH1yi+K5RWzQNIjWza5USt3xIpS80qGMEKi+MY18sNMw8yYs226eCpaD9tI9MZUDHQ0xhIl877Q8do64XbF/GfxXM72WW+R8haDLk05ZtbcMcb2IKZ/EpqJZJZUKL2Q0WDhDniYXjnj9kMYtlIyRMMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YvApSJIg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BIEjxekP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YvApSJIg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BIEjxekP"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5eBeZ2277192
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:38:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=LEuz0IYkO3v
	v3NkIV9hKvUGxpNw0DLo4XFrqlBEvznA=; b=YvApSJIg26yiUkCIqtY49o2Rn2S
	RQZLEU/0abNuxebWy1i691/5YtILrNLLRVrmrdr0Zs/dvgXDOj+HT1Mx7i7YvCwt
	VqSJ00sq6XIdnsMNrLa38U96SbH/QtvcrCz5HRZXMI+OWyOQb3tcIE5Se/zls/z9
	fH5r+OhALjcfF/bOM0BCBSouBgsqHyNKQGnx5ANzOTZi57NUdzqw1TbwZOetXhHP
	mUAuO9IzAK+kwKxdqvtlSAQ0RNPttMR6f8ilttFqK9QY/j1+4UCSTPnbPIMC/Xih
	DTcrRfL0m7D2nGcBTIifQyTDXcGFmkdVdj7UwWe+NdWfMzZI4uxzAc9WlcA==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvfjxux1b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:38:21 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso3003579eec.1
        for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 00:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790235500; x=1790840300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LEuz0IYkO3vv3NkIV9hKvUGxpNw0DLo4XFrqlBEvznA=;
        b=BIEjxekPDrlq1KDUCVFLvs7wsLQHHYkNdGBBD3QrGFsQsK3Fiw8iAmKPwY6lR3y25w
         QFrK61g9B3v/TRvFNBZ53cSRl2ZEfzi6hwwhvzS4T+RVc91WN79AVj/f8G4gcD4c2MnC
         L9ytHEWVjkWfB4c6NAeNxuXsgzhGm1L0M9fbLJWX4leK/Sy5M0cPolVFKBpk3h7DudNX
         3GPsC9IHvP7vTKkWoIUvcbTuUiaQaWH09yecmEe3SjR1t/uBthqYQql1yeWB65e0N7LI
         JCF3+ujdi2u9GPmYsoN642g1HvIwhqGXHQumeGDofkt23N5h6QzYyXXw5YTu04ynD7gL
         5iHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790235500; x=1790840300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LEuz0IYkO3vv3NkIV9hKvUGxpNw0DLo4XFrqlBEvznA=;
        b=O1bJC2RkdXUyv28e1rpfnECy/9Yl3cVT03/b8eVnYgqxqmoYnF3pHcjBkQ5qjXCLbR
         3XglgnhbAFHApBTb3yt1mPqMfnDi9mnu40AsAzuM+E0dmW2mnIw+hEhhoD1NSwjR1TfB
         9fMhz5YKSMlcuoX4IJSydJ6Bne8/mcC2E5A3r9V+NUu/Z0YtvTEUPbIKUZ82O+mL+qqj
         WPKsr0ntqox3PoKBCT6EUodhWhYeQJR3duBrNgFLwxdUIGKoGiEKXrpn9/rqgYTR8e5y
         5GiscIJntbtPFaG6uuuMmw4WcMAB65lmdlg0V1rJVk4McYCT6IdQU44X0z4DII88HZFC
         UV2A==
X-Forwarded-Encrypted: i=1; AKwUvBwF4X/JP0ZfKzd7gGJr1S1vzUfTagxAC8QSZAsat5N0VxxtEWvgwgVukpUrKZOlGK4DwdW0etpAsFc=@vger.kernel.org
X-Gm-Message-State: AFuF++l2l7a0TIzTsvFSa/8Kg3oXnEu0tn3Msp3J69rZRo8NJqL43+S2
	hGN73Q9mGOz63UIGe+r6oT+uXwJmxtMULi4Cq7D5N+jQdODr9y12T/TvlteHINGdTLdhsvt1akt
	qwphOBPY+UV5HXZpXY5452XDFa0IIGomLY1ZwbvLPPf67EtMMzvH3GgOdUadtd1s=
X-Gm-Gg: AYBFou2BCsyPP77okmwpexer9Zymkv12rU1T9gyyu6XAa37YSd5A4yLf65j0vIB7dQi
	LyRzu1M2Fl7KjHupPwYwbcMECzBTGdZL/Ic4qXD4rCl82g1dJGbvvTm8sZC6+hFZn5JqneHjMh9
	ww2OeDAbA7A48jMU9bBUxdaEkxM047AYLuJjmbW9EHMuetIsyo68i2pRB5lk/FNAFFkRq3I/w7e
	Pi4eTQVlyUEGKmwPGuhIcqguxZaVGr4iOyuNqMF3nivdjtp4nzlKkDtLVRqOqGaIXk65/AQouOR
	cuRg/ta7CBWLiv3ucE5WJmxzKMXrc0NeTMMpfZV3dXJWhhaO1JdZW/xXcOY2ldwYm19hJF/u6+y
	MzygEJtEC2RRs8iimPv6d8+vdapObg4pGHCMnGvyvO+hNxdc97IPN2OXT60SmihnututJNLD54y
	LIUuBdHt9k7UxmUfYuv8mzAgK2
X-Received: by 2002:a05:7301:4441:b0:33c:1ff7:8681 with SMTP id 5a478bee46e88-33ffee597f0mr1649411eec.15.1790235500393;
        Thu, 24 Sep 2026 00:38:20 -0700 (PDT)
X-Received: by 2002:a05:7301:4441:b0:33c:1ff7:8681 with SMTP id 5a478bee46e88-33ffee597f0mr1649373eec.15.1790235499750;
        Thu, 24 Sep 2026 00:38:19 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e95c7cfd9sm12120680eec.5.2026.09.24.00.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:38:19 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
Cc: acpica-devel@lists.linux.dev, anup.patel@oss.qualcomm.com, ardb@kernel.org,
        conor@kernel.org, james.morse@arm.com, lenb@kernel.org,
        palmer@dabbelt.com, paul.walmsley@sifive.com, robert.moore@intel.com,
        sunilvl@oss.qualcomm.com, tony.luck@intel.com,
        zhangzhanpeng.jasper@bytedance.com,
        Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v5 9/9] riscv: Enable APEI GHES driver in defconfig
Date: Thu, 24 Sep 2026 13:07:14 +0530
Message-ID: <20260924073714.1650588-10-himanshu.chauhan@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: z9RUwloMLqyzeo5g9v_9lYTdhd1Alp-D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfX3YFDzwYShOV5
 rZ0sPEK9cT/OU6CXa5i2G8mDxi79E6OAi9nutkzS84UjlbUr9gaJZs8ylE+7L2VyF+ug61SCsBW
 7hfxSbngS6IkF13GArYlOXxleLEzAnsRd+opnbKp2aPYERcZNvcNF7eol6RBEUKRRGkUMOUsUW4
 UjwpuAKZtNa2DlG0GYHSkH9imUu9Vg5m1KSjlsV0QSmgnamPrzgXQZjTsZiUf/iqztNOS4ICbfE
 TLIUIMt4KMxYcx3eu/lsBVJrLlcRbbe/5MYX59fZA5I1GpP9SgyS8ft1vJC9n+A9blg0lfrTBJT
 nKyG44cQggl7P4Cz2kBo3HpkzFyUcWpBTpoHsLpGFgGFVrzPbEYo2MdVvkx1bt7mie/L4CEgOvO
 Z3qFSeu4nSoM6R4fNB4QgcAL/fwT7REuOdYXlM0CgZZ+d7AFnRzw8eV8AAkW4FeCGva6TJeSyYR
 m/KS4JF1MAOWPJJa8oA==
X-Proofpoint-GUID: z9RUwloMLqyzeo5g9v_9lYTdhd1Alp-D
X-Authority-Analysis: v=2.4 cv=NLpAaE6g c=1 sm=1 tr=0 ts=6ab4d36d cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=xUlk1AThICIXWUt23vsA:9 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfX7h9yiAbz6blz
 lTSHR+Szq/X/0WrdcYLf2+W3sEK2Iew/za020UoQE3lqGonCX1T6Ornb4SUpNk7g68l68gs89Tf
 +/lmhnrXetC0CjfHc96PJ5YxjO6LQio=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 clxscore=1011 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240032

The APEI GHES driver is very important for error handling on ACPI
based platforms so enable it in defconfig.

Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 arch/riscv/configs/defconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index 04ae305d5511..66353b22298f 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -48,6 +48,9 @@ CONFIG_ACPI_CPPC_CPUFREQ=m
 CONFIG_VIRTUALIZATION=y
 CONFIG_KVM=m
 CONFIG_ACPI=y
+CONFIG_ACPI_APEI=y
+CONFIG_ACPI_APEI_GHES=y
+CONFIG_ACPI_APEI_ERST_DEBUG=y
 CONFIG_JUMP_LABEL=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
-- 
2.43.0

