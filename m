Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693830;
	b=e9+Xf0whChBJtZZOy2M+u/i9IJzbgelkdaR9wyhW7Yoe/Z4C6WGkMQkN02uDvICZTy3T
	 +/pBI9/d73x7X7niN+eCkAWtgg8uIuKQeXyjm2PL+recHMmhesV/JQtrq+9hLj8BGG0Vp
	 2aRzmweV79bfQTkbsMfiAvyq+GHP378pXpHYhg4hvrZeFJzodyrm7q40XBfgCbnmzZzAx
	 SRqB7Pqp56wMZ5TiTJ3UHmCEQMGDVgRyWI++E3R08uvz9otCVsLq/U2Is6cjHsd7HZWPw
	 LoAuEvJgPh8h8JNQ3lWlbhDNHEnWuAAqTmPy5lg5lbJmJYm0D6Gb+0c0IBf+fTvZ0iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693830;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=S/rDm9MSW0WTvPK5lT2NqtuJzmnuYBWQB0NK6jZGLPQ=;
	b=CcNgckxFEqTfsutxRi0ZdJjGdSvC164f6j8e7PyqFMYdsRKmCq1/jHbHMkqOoqo8xnP6
	 E10WuYs0BBRzLmNvM+7mF25jtzrZ70cDfmaEG+EH/0aZobuB02kezyOPkgoVH0OPUjE8X
	 PHSbCeLjntnaFSuDjYLW6kFlYlYU5WuEzr682lh1Kl29XfvbRxC3t7qM3tfdplRNYQMXv
	 wF9BB77Rs58bmbsQthFKCkyMEXafX1kVnILjn5AcB6QE7WdF6mCqNO4iiVm5KHJtC9kXM
	 G4edHvTUbst20Rnp2lqyrGug9eq43Ga1Ko95DZH1Yot6QsLlLAbKEW3TAS2LXTLm2Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=SVIV6EpM;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A005606A32C;
	Thu, 26 Nov 2026 11:50:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A005606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=SVIV6EpM
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E6CD1D13;
	Thu, 26 Nov 2026 03:50:26 -0800 (PST)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AB593F632;
	Thu, 26 Nov 2026 03:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795693829; bh=M6YJ067DYPpSDU4UXJ6oaiovDlaxST0eB8C0pfg04v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVIV6EpMIHaCeoj/be0YI77r6k/jNQxqGF3zQkn24yTuVZ5dChBpBA9mroGFuEkAw
	 TgDdRFjEjY+W54RiTdF6MTRTY7s8Y2jjLjWg3YvT9oB6Lm2/mIC6DSexpXWtWhdb+Z
	 YHsg8HB1e0Jflokm9UIlFBng2oYe3bsY26pMkLRM=
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
Subject: [RFC v2 06/13] ACPICA: Add TLBI table definition
Date: Thu, 26 Nov 2026 11:49:29 +0000
Message-ID: <20261126114936.864256-7-kristina.martsenko@arm.com>
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

Add the definition of the new Arm TLBI ACPI table.

NOTE: This patch is not yet part of ACPICA and should not be merged as
is. The TLBI table description is not yet public and may change. This
definition is just an initial proposal of how it will look.

Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 include/acpi/actbl2.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index 76e4a5bc79b4..98ef50b9bee1 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -61,6 +61,7 @@
 #define ACPI_SIG_SVKL           "SVKL"	/* Storage Volume Key Location Table */
 #define ACPI_SIG_SWFT           "SWFT"	/* SoundWire File Table */
 #define ACPI_SIG_TDEL           "TDEL"	/* TD Event Log Table */
+#define ACPI_SIG_TLBI           "TLBI"	/* TLB Invalidate Domain Table */
 
 /*
  * All tables must be byte-packed to match the ACPI specification, since
@@ -3708,6 +3709,37 @@ struct acpi_table_tdel {
 	u64 log_area_start_address;
 };
 
+/*******************************************************************************
+ *
+ * TLBI - TLBI Domain Table
+ *
+ ******************************************************************************/
+
+struct acpi_table_tlbi {
+	struct acpi_table_header header;
+	u32 domain_count;
+	u32 domains_offset;
+};
+
+struct acpi_tlbi_domain {
+	u32 length;
+	u32 id;
+	u32 descendant_count;
+	u32 descendants_offset;
+};
+
+struct acpi_tlbi_descendant {
+	u32 type;
+	u32 identifier;
+	u32 length;
+};
+
+enum acpi_tlbi_descendant_type {
+	ACPI_TLBI_DESCENDANT_DOMAIN = 0,
+	ACPI_TLBI_DESCENDANT_CPU = 1,
+	ACPI_TLBI_DESCENDANT_SMMU = 2,
+};
+
 /* Reset to default packing */
 
 #pragma pack()
-- 
2.43.0

