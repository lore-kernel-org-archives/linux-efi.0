Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693841;
	b=TwMxANz/BLymW1cZYr0sVyautcoqRNuBubtbRl95n1j/oP9Y2N2R1LeKhLuy+ffg02oT
	 xFWuIGFensWS3C34cD2jsQU+Lq4j3b4lGKyv1aUVHkoMk+wVD7MdgnkrCF0WOZY8192dy
	 w6bIifJdFcf+PPm27IJbm5nsq361/kj2C9JKnMhdsSjbgynn/pr0spO4kgVPDckJbBcrQ
	 qql1Ia+GuBYGE+HM7Fh8YmWC1m1YBKZWeWW0KNvqeo0r+bF2/SsVrQ0si3r8/zv9QrPSQ
	 SZsJxsi9XBIgG1vNPdoQDqAo2Ijf7SsgfNKnvTcxJ7xoxYvLvjl5hAm2Vg45+6z6VFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693841;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=TP//3Tk37aCthCQTZ/xunNEX49UuOPZj/NRDLFDF0zU=;
	b=Q2lfN0gJSGi8rucaQFI8Hnbh0UmkuA2QotpPHfpmG++AKItVjy1nOxjVYC1MIFLlYd/t
	 GjVw/7aigNOS6s8+FTs+pD7h1LMf3/H53xcOIuXTmOEcn6lIamhOjERmusxVUTnmWtUgp
	 AfoOnKrSWjPCI9lxBUaBweu+/1wM0D88UuTqiVxBshHkFtwA6SohQCaLuRRSGDFmc6u07
	 8Oa6+t2xq6NcfJhCgvGfyuZa+rLtCsoEXcbE89zRiJLmhD8KP4Yf5ZkivlhtExFKi+bh0
	 4IUX8UjACBAiJFknNQIbY67oyQe4mA5hy3GUsucmM6zGsEopMDtQ51pJwtlMyDs5I6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=AB4BGLeP;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCFB9606A32E;
	Thu, 26 Nov 2026 11:50:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCFB9606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=AB4BGLeP
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56D901D13;
	Thu, 26 Nov 2026 03:50:37 -0800 (PST)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E5A033F632;
	Thu, 26 Nov 2026 03:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795693840; bh=Njex7zeOIT87pZjpvIb3q8+UKkGvQ82hdE93b1RTdGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AB4BGLePTMcmpAsoNOZGx/srsZ0881KVumLYg2lkQYWz48tgYOIUEkbchNMIi+whV
	 uUiYmB34fMgdwLhsU9Svtl/Jqvvhjg0AjmWEaEosXzeHa9SFSW5eFgAO3lRnP3tbOH
	 rHRWtBGym9z78C2L+nmaoI8VX5k2j5/qpqJw6N30=
From: =?UTF-8?q?Kristina=20Mart=C5=A1enko?= <kristina.martsenko@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-acpi@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-efi@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [RFC v2 09/13] efi/arm: Check return value of init_new_context()
Date: Thu, 26 Nov 2026 11:49:32 +0000
Message-ID: <20261126114936.864256-10-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261126114936.864256-1-kristina.martsenko@arm.com>
References: <20261126114936.864256-1-kristina.martsenko@arm.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

init_new_context() will soon be able to return an error. Check for
errors before continuing.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 drivers/firmware/efi/arm-runtime.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 3167cab62014..054a110986c5 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -55,7 +55,8 @@ static bool __init efi_virtmap_init(void)
 
 	efi_mm.pgd = pgd_alloc(&efi_mm);
 	mm_init_cpumask(&efi_mm);
-	init_new_context(NULL, &efi_mm);
+	if (WARN_ON(init_new_context(NULL, &efi_mm)))
+		return false;
 
 	for_each_efi_memory_desc(md) {
 		phys_addr_t phys = md->phys_addr;
-- 
2.43.0

