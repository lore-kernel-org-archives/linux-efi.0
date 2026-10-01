Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 621B051120F;
	Thu,  1 Oct 2026 11:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790852888; cv=none; b=LTr3nkcCmaB2jXseFoQjfZLVj5llZ1kRkqwITUbDmg0Jpk4bqjEonE0zHx9ALb/zGNJk2aS+WEYpChj+7EebwG8WuHpoGw0i+BrsHlNHNv/uVR20NtGKrl27lG24GUzRIk2OOMMq0aRLXhOT5cb20+lLQj2+PFVCG3h/LwSJfaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790852888; c=relaxed/simple;
	bh=IbyIhRdAEyhpQjWEVXWjjx2CVaRvxMBjRy4Q02Hak+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fOWAih9blLSZoCFw8t3j9Ftws6qzXYuhZDDs8uobw73HJZeEDVSIsIvnfE+ckRzDS8uLgbYLOoKgs8jNE4rtWsgkcGH6nhawOytbDCqBX48oDA9Wlxk6cblN6z2CEWJ5/ueM+eKhGBF+RBW29gCBuEPv3wgxilYq+NEQG7qjt3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SWdw0Xun; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SWdw0Xun"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 11699497;
	Thu,  1 Oct 2026 04:08:02 -0700 (PDT)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC83B3F86F;
	Thu,  1 Oct 2026 04:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790852885; bh=IbyIhRdAEyhpQjWEVXWjjx2CVaRvxMBjRy4Q02Hak+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SWdw0XunzW2EjZ+o5+edmWpFPGdsvLCmQkI9UtqXwT63EO0D4lqBNbglche4Lkgee
	 CUMNbPyAhI3rKNWxML7M/0u7CgcMOh+AGTBtodQUlHL1Y8RWaQbBOMVO8vSKsQiwIY
	 PgTCg32d9DSH5QDUgz7wlyXX9bUkcQ2QdsQU+Mbo=
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
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [RFC 08/12] efi/arm: Check return value of init_new_context()
Date: Thu,  1 Oct 2026 12:06:51 +0100
Message-ID: <20261001110655.461473-9-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001110655.461473-1-kristina.martsenko@arm.com>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

init_new_context() will soon be able to return an error. Check for
errors before continuing.

Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 drivers/firmware/efi/arm-runtime.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 3167cab62014..7ef29cd0bfb7 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -55,7 +55,8 @@ static bool __init efi_virtmap_init(void)
 
 	efi_mm.pgd = pgd_alloc(&efi_mm);
 	mm_init_cpumask(&efi_mm);
-	init_new_context(NULL, &efi_mm);
+	if (init_new_context(NULL, &efi_mm))
+		return false;
 
 	for_each_efi_memory_desc(md) {
 		phys_addr_t phys = md->phys_addr;
-- 
2.43.0

