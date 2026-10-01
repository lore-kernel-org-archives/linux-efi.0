Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60027472F89;
	Thu,  1 Oct 2026 11:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790852873; cv=none; b=GfzGxSJgg9si6eoJKuAfUxgoynL9dygvKqBPQWtdzrPFXAMCVjZFPuDYtTx0OMgOq+kzhvDZAAH32i2BqcgcRQdMVszu1OL6ncPGCu9VJEtTDOFiQRb1J7EMHYrwjU0yq9i5CHGln09NGJrCEFmlE6OR20awGviSOsGV2Nc48Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790852873; c=relaxed/simple;
	bh=Qk5IJujYZUc2jm8+jqWTC4B1XTGYa/7JaWdPp0hSORw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pCks2UK7cjEtbO/CTwgoIdKTuHQFP8LUGpO80brbar6WHa5mnmNKtesB4SE/3Bf4O4HOYSpmFuAZGNq0Mm91g/VL1ByMyTkjcD8nzAmYQvtkdWrbDiVJRsayNU2SLLrfz/ouYYm6DdIvAuQ2avrL24jPQEKIAiHmV8yuuX5t2CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SQAFoqrF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SQAFoqrF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59D2C143D;
	Thu,  1 Oct 2026 04:07:47 -0700 (PDT)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 308D43F86F;
	Thu,  1 Oct 2026 04:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790852870; bh=Qk5IJujYZUc2jm8+jqWTC4B1XTGYa/7JaWdPp0hSORw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQAFoqrFHrQKbKwbu4m8oGmKnvVXF5bswGciLizz0R8EANR9XPsp1s9GIYXliTDWd
	 7qTzjX2r4c6tsGKXU6P8/8EYUM3VETddBEJmBnrpm+2p3reVLMQ+UV3GsIgiXdGqc5
	 Y3W0g93lxeZxU5YgGMT2hKN6aZlFyebMch1VkVok=
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
Subject: [RFC 05/12] ACPICA: Add TLBI table definition
Date: Thu,  1 Oct 2026 12:06:48 +0100
Message-ID: <20261001110655.461473-6-kristina.martsenko@arm.com>
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

Add the definition of the new Arm TLBI ACPI table.

NOTE: This patch is not yet part of ACPICA and should not be merged as
is. The TLBI table description is not yet public and may change. This
definition is just an initial proposal of how it will look.

Assisted-by: LLM
Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 include/acpi/actbl2.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index baef525367b5..68849c9f7cf6 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -61,6 +61,7 @@
 #define ACPI_SIG_SVKL           "SVKL"	/* Storage Volume Key Location Table */
 #define ACPI_SIG_SWFT           "SWFT"	/* SoundWire File Table */
 #define ACPI_SIG_TDEL           "TDEL"	/* TD Event Log Table */
+#define ACPI_SIG_TLBI           "TLBI"	/* TLB Invalidate Domain Table */
 
 /*
  * All tables must be byte-packed to match the ACPI specification, since
@@ -3701,6 +3702,37 @@ struct acpi_table_tdel {
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

