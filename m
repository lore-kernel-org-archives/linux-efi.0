Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B120A3B3C1F;
	Fri,  3 Jul 2026 10:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072988; cv=none; b=u9n83upgQOR9HSX2nre8VTxxMqLb9v/UXqHCJ54CJiOaKJK3id0b43jcQf4XKodTe51SpCL9MmlqYmgPkojdniSbr947euxCaFgaYKAcJRKuL8JtPgNFt1q9owm9oTq5dbvPZjbFBoABjeX8HNRHTslUCa1lILA5YG6zcO5uyF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072988; c=relaxed/simple;
	bh=EEaMdnBkddUPklsHj5Rc6YB7H0ZR+oBaLOveonJSMrM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C7W2c6KSWdSOYqp6EXrZLGU8VjLvKeP4QjKpe9Q3ANZSrfWFpgzHhSZzLFUpP2oe3Yfh29Fy4PEdnjEiv6Q8OCE5b6oEF4guQPaNlPtIG3GfvRJV1rSPI2hcOK6neuXlF9eJK/DY30wdq05TwOCMBTYTQiWUBy9D2tZznnfvGP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=WMLTJuLo; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="WMLTJuLo"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=loQEiACSu9pu1AC19ibmREZdkokAjPPEsW8mztMylCU=;
	b=WMLTJuLoLIFk3cgj2PLIvoy+1AR12BDNRt8h+JG3svVgS7CxNKsISJMrXj+e6lZmYJWC3jK1r
	WD7mXAJUNBADcBmBfPREsyt2rh18UhUdAC8tujNo/rJcmKHW/IkJKhfaRrmhle6G9x04P25CInl
	wvUiTvWC4ze6RpXMTGC5Me8=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gs8Gp5Vj7zcZyH;
	Fri,  3 Jul 2026 17:54:10 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id CD2294056D;
	Fri,  3 Jul 2026 18:03:04 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Jul
 2026 18:03:01 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <maz@kernel.org>, <ardb@kernel.org>,
	<ilias.apalodimas@linaro.org>, <oupton@kernel.org>, <joey.gouly@arm.com>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<oleg@redhat.com>, <mark.rutland@arm.com>, <lpieralisi@kernel.org>,
	<tglx@kernel.org>, <ada.coupriediaz@arm.com>, <anshuman.khandual@arm.com>,
	<ruanjinjie@huawei.com>, <ebiggers@kernel.org>, <broonie@kernel.org>,
	<mrigendra.chaubey@gmail.com>, <baohua@kernel.org>, <lucaswei@google.com>,
	<james.morse@arm.com>, <zengheng4@huawei.com>, <thuth@redhat.com>,
	<yang@os.amperecomputing.com>, <leo.bras@arm.com>, <Sascha.Bischoff@arm.com>,
	<james.clark@linaro.org>, <peterz@infradead.org>, <leitao@debian.org>,
	<ben.horgan@arm.com>, <punit.agrawal@oss.qualcomm.com>, <gshan@redhat.com>,
	<osama.abdelkader@gmail.com>, <fengchengwen@huawei.com>,
	<ryan.roberts@arm.com>, <yangyicong@hisilicon.com>, <kevin.brodsky@arm.com>,
	<kees@kernel.org>, <jeson.gao@unisoc.com>, <zhaoyang.huang@unisoc.com>,
	<ryotkkr98@gmail.com>, <wsw9603@163.com>, <pasha.tatashin@soleen.com>,
	<jeremy.linton@arm.com>, <schuster.simon@siemens-energy.com>,
	<osandov@fb.com>, <arnd@arndb.de>, <zhangpengjie2@huawei.com>,
	<smostafa@google.com>, <vladimir.murzin@arm.com>, <tabba@google.com>,
	<vdonnefort@google.com>, <kaleshsingh@google.com>, <jic23@kernel.org>,
	<timothy.hayes@arm.com>, <alexandru.elisei@arm.com>, <zenghui.yu@linux.dev>,
	<david@kernel.org>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
	<memxor@gmail.com>, <qperret@google.com>, <chaitanyas.prakash@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-efi@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH 14/17] arm64/irq: Document handling of FEAT_NMI in irqflags.h
Date: Fri, 3 Jul 2026 18:01:32 +0800
Message-ID: <20260703100135.2512312-15-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260703100135.2512312-1-ruanjinjie@huawei.com>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500011.china.huawei.com (7.185.36.131)

From: Mark Brown <broonie@kernel.org>

We have documentation at the top of irqflags.h which explains the DAIF
masking. Since the additional masking with NMIs is related and also
covers the IF in DAIF extend the comment to note what's going on with NMIs
though none of the code in irqflags.h is updated to handle NMIs.

Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221112151708.175147-12-broonie@kernel.org
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/irqflags.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/irqflags.h b/arch/arm64/include/asm/irqflags.h
index a8cb5a5c93b7..f2af9f423d88 100644
--- a/arch/arm64/include/asm/irqflags.h
+++ b/arch/arm64/include/asm/irqflags.h
@@ -18,6 +18,16 @@
  * always masked and unmasked together, and have no side effects for other
  * flags. Keeping to this order makes it easier for entry.S to know which
  * exceptions should be unmasked.
+ *
+ * With the addition of the FEAT_NMI extension we gain an additional
+ * class of superpriority IRQ/FIQ which is separately masked with a
+ * choice of modes controlled by SCTLR_ELn.{SPINTMASK,NMI}.  Linux
+ * sets SPINTMASK to 0 and NMI to 1 which results in ALLINT.ALLINT
+ * masking both superpriority interrupts and IRQ/FIQ regardless of the
+ * I and F settings. Since these superpriority interrupts are being
+ * used as NMIs we do not include them in the interrupt masking here,
+ * anything that requires that NMIs be masked needs to explicitly do
+ * so.
  */
 
 static __always_inline void __daif_local_irq_enable(void)
-- 
2.34.1

