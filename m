Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC58413D69
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235455; cv=none; b=qIvdmdikzvVHy3nRDlXAm2gY1UBvVKWch+PoDT1nhq29+etdpYrSYx20JcyPPt99yh/piCv1ngyP6/XZi0sNSErZraA2H6zCodediPolZMjVRhnul5wE1ilBUUOAr/gYIl009lYDerQtQTIgAiXYnVfLClS9WHUfo+SjRuA3A70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235455; c=relaxed/simple;
	bh=1hUFZzk8I02wwaixbUr5fn1Bm9Ue3PrxhfLlWreilAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OI5KRJZM5EWJJIBlf/U6A149/bnPjsF/u/uEpQUJ2EbXS6ZczDLjEu3CFpd2srsqHA5Qrngc1O1qcJux2Ndj3okqr+9jeF009XT3PAl5czeRV+qbMvCtqOhK8GgUq/JnnoWROQ7x7iPpT938vO1onzxR618DFEiGn1KJxypgcog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=io4eAL92; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Lja6XJBR; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="io4eAL92";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Lja6XJBR"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5eNDT2421116
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=COCHYx8vdlE
	VpwnqbwXHA67D8m795QMTNoWQg+xmxzc=; b=io4eAL92O4D+jrHD1TDM984uvmu
	64MNZODOVo+7yMikxK8gsjzkZxX8wiQ4zhpAZuPVaAyxz39onl+JYOvjErO4hcas
	SilhHoOcf2rWdtFS3lAzjrktbneNePETTvo0awaKTCyVoMJuTZq82Gz1S0vR52L4
	MKxMXM0iWqSs5UdzxHdljpL6CKc5kMz5PG6wdRSP5jQpCI4dpEUxlbGB9wXtI42A
	klsbyaa05UMMVwjWejhvqhuOsU2ZGlvp4Xk7DOPoaf0ndxWXxUXgjb5wXOoU289T
	JtiL9OQsOi4otO250ShDu2rZNeTDkvUK1YQXe8mbmjMDNruFZL4E9J+1hRA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvstuhadg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 07:37:33 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-333543ac378so2104199eec.1
        for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 00:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790235453; x=1790840253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=COCHYx8vdlEVpwnqbwXHA67D8m795QMTNoWQg+xmxzc=;
        b=Lja6XJBRKRwZfEfaq+4JhEjLSgsZXNXcA9FOsJ4sEHwsotMKfEcCJg2sxKipCHZSFb
         mCO73jRZUypxvFHnc+1mQwwr9gwmecIscKsztMPYBVX85IuAFZ9dJT5Kro8lLDfGlKRS
         4kOdR07aNslufMZLfecFLQEAWTte33Uanej3yPw5GAGcmKni0ocKmpwMa5PZwFAiicn+
         ma8ihmu0B12LlMeKTfEWZyw4AnXeZkdFgIhhCdgheECLTxhE+EFy1JUFILRro//FfO0T
         73DZ1wgUkhgkJxfDyf8vHUvWRl1ZJpsPFhjt6dEB18TN8gXCDb/siNH5O/jOBhubQNSq
         G1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790235453; x=1790840253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=COCHYx8vdlEVpwnqbwXHA67D8m795QMTNoWQg+xmxzc=;
        b=s/nRhV7T++7Zn5mXN22fSxLsmH021hZ7+a29czvEhuOsaLnL9HS36o610On9yjHRav
         j10CBiaFowS43bOldjetRZVxS8ZzEh+JTM8McDNpB6uM1pQ/AOBFX4fUVbLafOWEqxVx
         IgFmP8nsAG/NNeVRgWOzn2CTSFGlrjb+RQvN3/iBHnnyNAqQPRfHQX42dtLfXpqMLCHL
         03Nugc8Zo4mqtPTXnsNp5ND6LLi1MF2GD3F/3Wvt+TofrWFz1q9Nre4DYmL1OYrc9dpr
         lkpO5x6LQX+4yFQPUcauAy1BnriT/m/GfYljvKux7E6iSBj1fC9j8utUnv7DTQUvGLSD
         dZZw==
X-Forwarded-Encrypted: i=1; AKwUvBwyyNS7RvW9Fm9f5oCDU/oBRzlUyMMXUmcDlnIS6pa0wcMO5J4JeiQ5hY8QUIccx5FpHCPhLDIB/7Y=@vger.kernel.org
X-Gm-Message-State: AFuF++k6/J3n3RjRRMn8j8ixYExtV16uYit/uJodnp/tVWtqlrTvrVxp
	8Y+N213nTn0PanOdwUrE9Ieos8jdJbiSODcXt67zQYScfcH0YwQ+nk/CA+ktnTyIkS5yPLkneKg
	IR2Q0gzq/+aijmG8Vc4lCmRxPjrtzXXOZOEXcUQObhm89dt1GuS0Y9QKBVygcLGk=
X-Gm-Gg: AYBFou0/NTqywBNsoZKQoNuCPUvEA6ad6MKqijH++04yYb4RN7iclWWnH9ovDg7Cwfs
	0siPww71LOWau85oudzRvqFrKO5+aK+FOL03idB4HIuUKJWKXZPolC3CX0UR/FLBqMLPchNBD69
	xuOD724kyYYYy4dogoRBggynvulLdxd5Xx9Yw0elD/pEOKmR3oJZLyVWHDR6z0HOe+1TG1wMzxS
	4KryKbIEV9pLBKub4BT0Mn2yg3vZU444dWTVsP0katFHck0q505gH7ASt4P5vVUMIYN1wSDqXiR
	hHNoldCm2HBkLD8ZvxtWWQ9/xy64vYu7WaT1Ghe2GAjytuBC8RjwIy5nGQXWtCDYTyt6T/zYzyR
	nxAF8zlENFXUWleioifX/LIWTz8o9Aow6nZ726GAQ/1lz81Q3biDT0CwujYqGzuSFl66LIEwIan
	pdYoi1Rg3taPhYu5ByQhTn2uBY
X-Received: by 2002:a05:7301:90e:b0:33b:fc9d:947f with SMTP id 5a478bee46e88-3400566e970mr1106761eec.40.1790235452859;
        Thu, 24 Sep 2026 00:37:32 -0700 (PDT)
X-Received: by 2002:a05:7301:90e:b0:33b:fc9d:947f with SMTP id 5a478bee46e88-3400566e970mr1106736eec.40.1790235452334;
        Thu, 24 Sep 2026 00:37:32 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e95c7cfd9sm12120680eec.5.2026.09.24.00.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:37:31 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
Cc: acpica-devel@lists.linux.dev, anup.patel@oss.qualcomm.com, ardb@kernel.org,
        conor@kernel.org, james.morse@arm.com, lenb@kernel.org,
        palmer@dabbelt.com, paul.walmsley@sifive.com, robert.moore@intel.com,
        sunilvl@oss.qualcomm.com, tony.luck@intel.com,
        zhangzhanpeng.jasper@bytedance.com,
        Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v5 1/9] riscv: Define ioremap_cache for RISC-V
Date: Thu, 24 Sep 2026 13:07:06 +0530
Message-ID: <20260924073714.1650588-2-himanshu.chauhan@oss.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfX2UrRh1VemMK4
 YPIM2+2rKTGvMLMwKLTUH5BD5K6376fy9qZFHkciqCAcJitVpJAP2LTlLmJli7YZiPUtlmqOsjX
 jWZFlQUQs2mpU4JPtvgWxMjtyobGyRo=
X-Proofpoint-ORIG-GUID: 5lcLdwazkPvawusuceP9pvpbSwjYcogS
X-Proofpoint-GUID: 5lcLdwazkPvawusuceP9pvpbSwjYcogS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzMiBTYWx0ZWRfX0zXkQi4cxBFV
 f5E1RTebBc7wAcJO8vS8wl7UOpbDtbAtsH+nQmwON/bnJAToxSIebcDC34cmYw468qup+S5fPS7
 fWC8KeVtUKZX4cMJ6Kehnbzjwr+1QVwglWHoaWbuZep1+XQ6SXJ1LmE5yfQ2Cp/zn9AcYWDkGqa
 /Jo1z1s9hr1cOA+ScN1WoTM0b5Myzsg75KNt4+Gnc983Xg8+jtI8cDnNwVxlZYHXtGy88qwj14G
 KoFCtgioT1GRNYFdaUpTO5KbQqoprwfXhLbFTAQe5mCB5zF1n4zKbmUxQ2GOXYu+6Ti9OLZ2hUB
 7TfL38gagO6HyKs4EXjzmQTemlwBnKoGJL9blJg920ocDBsoH5bzBFsebZfbkMSCSndVzu17t9K
 TupQUMQ9RRSXQKOx1+2LXesgD417OMNDGbignAPbbA+OXKtDMOJQzx7tmsuVuddxJkZK6RsqEc7
 WdBc8mypKh+hjBMgwAg==
X-Authority-Analysis: v=2.4 cv=cKp1IVeN c=1 sm=1 tr=0 ts=6ab4d33d cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=JWN5yfGi9shfayy-Z8YA:9 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 impostorscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 clxscore=1011 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240032

bert and einj drivers use ioremap_cache for mapping entries
but ioremap_cache is not defined for RISC-V.

Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 arch/riscv/include/asm/io.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/include/asm/io.h b/arch/riscv/include/asm/io.h
index 92d5f831f349..a51904a6c79b 100644
--- a/arch/riscv/include/asm/io.h
+++ b/arch/riscv/include/asm/io.h
@@ -150,6 +150,9 @@ __io_writes_outs(outs, u64, q, __io_pbr(), __io_paw())
 #ifdef CONFIG_MMU
 #define arch_memremap_wb(addr, size, flags)	\
 	((__force void *)ioremap_prot((addr), (size), __pgprot(_PAGE_KERNEL)))
+
+#define ioremap_cache(addr, size)					\
+	((__force void *)ioremap_prot((addr), (size), PAGE_KERNEL))
 #endif
 
 #endif /* _ASM_RISCV_IO_H */
-- 
2.43.0

