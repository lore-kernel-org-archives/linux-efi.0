Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF103F8EDC
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 21:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879704; cv=none; b=dZOOtmaxb8x8XHLcefhgvLte6LDC+7D1vRViUC+cu8gLh60acv0qI1CpGO/WCrDOQCiVe6Ei6INmRg3xWiHfcmwQ9+rN1AWh+QxNsr3l+J/azmJazStmT3y90Mr8sTZ6R4e9P7A09ZLK0KHkMvIqfdhJLqBR+J1brSx1fbi2jN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879704; c=relaxed/simple;
	bh=xWoPwNVeSnywWpOcGvmELTRW5jlGxq+dKcjO5PNtRQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgKI9gKc5ZaAb4Uk9pSA0F4nNKyTim6ZF8Ndaz3V8DPBG6gRqmxpMiikDZU/cdEjWkPPwzly2B4qn+lItocM1sxECotvOnsRAk+XAE7ua2hk7+DyDxk04zIWhCkJXtccVB0Q2XtMmCQV1OKu3B+rqjX8yFluQgWc3HqlMj410iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TML1/Alw; arc=none smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TML1/Alw"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2f00a567cfaso833148eec.0
        for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 14:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879701; x=1779484501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7H5BBOQhcOIL9Ie2ph8fKyZbD41fSwoTWiLEU5gST9s=;
        b=TML1/Alwf1J56nZnmLFnC6Z6dFQkcWs7FNQt/kRXfq+GMkjZIzhDPeefJNOyk30PoW
         cPck8KvGhJhoXhg9Enm/bD4+2l7LVKHTEUULH2y5HuBl60luRGlQjfwzodYujzjbCZ85
         kgunYYQ0YcAC8j3iiERH2Ph5cpRst++49kNCmwq0kqFuSxCWfc7EERACLpo+hGMVxIoq
         lQ60lbyGss/jKaGWpOQEq83fgcF5abfULfrofm5AboQ0qSc2VtTviw5d8HDaTU3SVzNq
         KE9j4qUnU/VmduXBPIZo9x7f2P4E89g/HvB3s3l0xySd/aUJ+fK+LIJBraYJ0mDxVo02
         /G3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879701; x=1779484501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7H5BBOQhcOIL9Ie2ph8fKyZbD41fSwoTWiLEU5gST9s=;
        b=kgEpYsf5uYmE625sQAC/gKbolSmT48H63vFS/V9pnqN3gwfFJzaU3JSbliXR3vRK3I
         o4Drt8YFaeIrl5PUBvcKVDQ69BZwgAbC5Z2FUzWxEB6pBq8IBKjH0jGrrla93ujH9zEb
         rUeaHeKD6xLbPYEI9vlIX71lWAZ0wk4hcagnRc6HdSXzE6uWpNMNYQKCej9SIxIJ5imz
         vDYs74BpWVicSw7Ki/vYo0HLQQsTS+QSQGllPzjiW+nvPdorAfQPXe1uLdnPVaTmyFmP
         jYCzO6/xqRg0ZQmqF8bBjepU/U2NRY6fx87wWO0ndtjgVu3Su9bIuGyL7gyLbOXxfRtk
         BmxQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Y3ivbexAwbFBs+qto9OOeOsuSsTzyX6EPMB/QtUGi71rp6tcBrOCqG3AQfng8hHVMPXhyuYCBz9o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxetrwqh3rBs6Xat9qmym9NF0bAyb8nl9nWrgt7qir5mVRjHBQW
	IZ65re+ahgrV3bl79AZuv8aURPB+S0aPtWpNFxGjKLZLk9cgyfVEb+i+
X-Gm-Gg: Acq92OFLAbCQltSr1FZnryzkeiwdtBN+QfrHKoiDETMvmcyTpN6yQXw/+bS1PRuW5oJ
	k/yfmTnmHBN4HRvvV7Gcpo+BkXpszxhuoGm8X2lfwOf2ukwEJP/hxotgjGhJSGvegUu9Bn/VkZk
	KngcSb48wdWn9mv+3fGUoXOfrXFOqxIR+QDKo8nWzIEaoZMhE+AozN/f3GwlPvgwyjISRzVHmHx
	B1lcqlpvXSmXElSSWlF+ra5nuT32GIJd2ZUgBPyq2PKQfWgoQ94oEu6fY8FkgdZYFlh46oAUuQt
	NaQjW2Gxg2e314gVRhkXaP568V2cCcx/fafiu+QxgmUC6BOmiqUSBegNWgAzhIKxxXtL8QtDkJE
	iHajOV2MFDeKfSD8u/RWvXND/r1uGRCfIegszsWzg5Rxd8Gdv+y9UXC8EExiY0l0oEuR+Pohl0Z
	d+ZeLx4UGeF80M0jea2pRcYqgzeKmo4jia3L3x8Atlsw==
X-Received: by 2002:a05:7301:644b:b0:2d9:db50:c6ce with SMTP id 5a478bee46e88-3039785c4f8mr2519307eec.3.1778879701272;
        Fri, 15 May 2026 14:15:01 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302978b1a79sm8049096eec.28.2026.05.15.14.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:15:00 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-efi@vger.kernel.org,
	iommu@lists.linux.dev
Cc: ross.philipson@gmail.com,
	dpsmith@apertussolutions.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	dave.hansen@linux.intel.com,
	ardb@kernel.org,
	mjg59@srcf.ucam.org,
	James.Bottomley@hansenpartnership.com,
	peterhuewe@gmx.de,
	jarkko@kernel.org,
	jgg@ziepe.ca,
	luto@amacapital.net,
	nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	ebiederm@xmission.com,
	dwmw2@infradead.org,
	baolu.lu@linux.intel.com,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v16 17/38] x86: Secure Launch Resource Table header file
Date: Fri, 15 May 2026 14:13:49 -0700
Message-ID: <20260515211410.31440-18-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515211410.31440-1-ross.philipson@gmail.com>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Secure Launch Specification is an architecture agnostic,
software neutral API/ABI maintained by the TrenchBoot project.
Its function is to allow any compliant boot loader to communicate
the pre-launch configuration to any compliant post-launch kernel.
The Secure Launch Resource Table, defined in the specification,
presents the programmatic interface for this API/ABI.

The specification can be found here:
https://github.com/TrenchBoot/documentation/blob/master/specifications/secure-launch-specification.rst

Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 include/linux/slr_table.h | 339 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 339 insertions(+)
 create mode 100644 include/linux/slr_table.h

diff --git a/include/linux/slr_table.h b/include/linux/slr_table.h
new file mode 100644
index 000000000000..2cc542121414
--- /dev/null
+++ b/include/linux/slr_table.h
@@ -0,0 +1,339 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * TrenchBoot Secure Launch Resource Table
+ *
+ * The Secure Launch Resource Table (SLRT) is a TrenchBoot project defined
+ * specification to provide a cross-platform interface/ABI between
+ * the Secure Launch components. While most of the table is platform
+ * agnostic, platform or architecture specific entries can be added.
+ *
+ * See TrenchBoot Secure Launch kernel documentation for details.
+ *
+ * Copyright (c) 2026 Apertus Solutions, LLC
+ * Copyright (c) 2026, Oracle and/or its affiliates.
+ */
+
+#ifndef _LINUX_SLR_TABLE_H
+#define _LINUX_SLR_TABLE_H
+
+/* SLR table header values */
+#define SLR_TABLE_MAGIC		0x4452544d
+#define SLR_TABLE_REVISION	1
+
+/* Current revisions for the policy and UEFI config */
+#define SLR_POLICY_REVISION		1
+#define SLR_UEFI_CONFIG_REVISION	1
+
+/* SLR defined architectures */
+#define SLR_INTEL_TXT		1
+#define SLR_AMD_SKINIT		2
+
+/* SLR defined bootloaders */
+#define SLR_BOOTLOADER_INVALID	0
+#define SLR_BOOTLOADER_GRUB	1
+
+/* Log formats */
+#define SLR_DRTM_TPM12_LOG	1
+#define SLR_DRTM_TPM20_LOG	2
+
+/* DRTM Policy Entry Flags */
+#define SLR_POLICY_FLAG_MEASURED	0x1
+#define SLR_POLICY_IMPLICIT_SIZE	0x2
+
+/* Array Lengths */
+#define TPM_EVENT_INFO_LENGTH		32
+#define TXT_VARIABLE_MTRRS_LENGTH	32
+
+/* Tags */
+#define SLR_ENTRY_INVALID	0x0000
+#define SLR_ENTRY_DL_INFO	0x0001
+#define SLR_ENTRY_LOG_INFO	0x0002
+#define SLR_ENTRY_ENTRY_POLICY	0x0003
+#define SLR_ENTRY_INTEL_INFO	0x0004
+#define SLR_ENTRY_AMD_INFO	0x0005
+#define SLR_ENTRY_ARM_INFO	0x0006
+#define SLR_ENTRY_UEFI_INFO	0x0007
+#define SLR_ENTRY_UEFI_CONFIG	0x0008
+#define SLR_ENTRY_END		0xffff
+
+/* Entity Types */
+#define SLR_ET_UNSPECIFIED	0x0000
+#define SLR_ET_SLRT		0x0001
+#define SLR_ET_BOOT_PARAMS	0x0002
+#define SLR_ET_SETUP_DATA	0x0003
+#define SLR_ET_CMDLINE		0x0004
+#define SLR_ET_UEFI_MEMMAP	0x0005
+#define SLR_ET_RAMDISK		0x0006
+#define SLR_ET_TXT_OS2MLE	0x0010
+#define SLR_ET_UNUSED		0xffff
+
+#ifndef __ASSEMBLER__
+
+/*
+ * Standard Secure Launch DLME header.
+ *
+ * All capable DRTM kernels must have an instance of this header.
+ * This header was derived from the Intel TXT Measured Launch
+ * Environment header and uses the predefined UUID:
+ *
+ * {5aac8290-6f47-a774-0f5c-55a2cb51b642}
+ */
+struct slr_dlme_header {
+	u32 uuid0; /* 9082AC5A */
+	u32 uuid1; /* 74A7476F */
+	u32 uuid2; /* A2555C0F */
+	u32 uuid3; /* 42B651CB */
+	u32 header_len;
+	u32 version;
+	u32 entry_point;
+	u32 first_valid_page;
+	u32 start;
+	u32 end;
+	u32 capabilities;
+	u32 cmdline_start;
+	u32 cmdline_end;
+} __packed;
+
+/*
+ * Primary Secure Launch Resource Table header
+ */
+struct slr_table {
+	u32 magic;
+	u16 revision;
+	u16 architecture;
+	u32 size;
+	u32 max_size;
+	/* table entries */
+} __packed;
+
+/*
+ * Common SLRT entry header
+ */
+struct slr_entry_hdr {
+	u32 tag;
+	u32 size;
+} __packed;
+
+/*
+ * Boot loader context and DLME setup
+ */
+struct slr_bl_context {
+	u16 bootloader;
+	u16 reserved[3];
+	u64 context;
+} __packed;
+
+struct slr_setup_dlme {
+	u64 dlme_base;
+	u64 dlme_header_offset;
+	u64 dlme_table;
+} __packed;
+
+/*
+ * Dynamic Launch Callback Function
+ */
+typedef void (*dl_launch_func)(struct slr_bl_context *bl_context,
+			       struct slr_setup_dlme *setup_dlme);
+
+/*
+ * DRTM Dynamic Launch Configuration
+ */
+struct slr_entry_dl_info {
+	struct slr_entry_hdr hdr;
+	u64 dce_size;
+	u64 dce_base;
+	u64 dlme_size;
+	u64 dlme_base;
+	u64 dlme_entry;
+	u64 dlme_header_offset;
+	u64 dlme_config_table;
+	struct slr_bl_context bl_context;
+	u64 dl_launch;
+} __packed;
+
+/*
+ * TPM Log Information
+ */
+struct slr_entry_log_info {
+	struct slr_entry_hdr hdr;
+	u16 format;
+	u16 reserved;
+	u32 size;
+	u64 addr;
+} __packed;
+
+/*
+ * DRTM Measurement Entry
+ */
+struct slr_policy_entry {
+	u16 pcr;
+	u16 entity_type;
+	u16 flags;
+	u16 reserved;
+	u64 size;
+	u64 entity;
+	char evt_info[TPM_EVENT_INFO_LENGTH];
+} __packed;
+
+/*
+ * DRTM Measurement Policy
+ */
+struct slr_entry_policy {
+	struct slr_entry_hdr hdr;
+	u16 reserved[2];
+	u16 revision;
+	u16 nr_entries;
+	struct slr_policy_entry policy_entries[];
+} __packed;
+
+/*
+ * Secure Launch defined MTRR saving structures
+ */
+struct slr_txt_mtrr_pair {
+	u64 mtrr_physbase;
+	u64 mtrr_physmask;
+} __packed;
+
+struct slr_txt_mtrr_state {
+	u64 default_mem_type;
+	u64 mtrr_vcnt;
+	struct slr_txt_mtrr_pair mtrr_pair[TXT_VARIABLE_MTRRS_LENGTH];
+} __packed;
+
+/*
+ * Intel TXT Info table
+ */
+struct slr_entry_intel_info {
+	struct slr_entry_hdr hdr;
+	u64 boot_params_addr;
+	u64 txt_heap;
+	u64 saved_misc_enable_msr;
+	struct slr_txt_mtrr_state saved_bsp_mtrrs;
+} __packed;
+
+/*
+ * UEFI config measurement entry
+ */
+struct slr_uefi_cfg_entry {
+	u16 pcr;
+	u16 reserved;
+	u32 size;
+	u64 cfg; /* address or value */
+	char evt_info[TPM_EVENT_INFO_LENGTH];
+} __packed;
+
+/*
+ * UEFI config measurements
+ */
+struct slr_entry_uefi_config {
+	struct slr_entry_hdr hdr;
+	u16 reserved[2];
+	u16 revision;
+	u16 nr_entries;
+	struct slr_uefi_cfg_entry uefi_cfg_entries[];
+} __packed;
+
+/*
+ * The SLRT is laid out as a Tag-Length-Value (TLV) data structure
+ * allowing a flexible number of entries in the table. An instance
+ * of the slr_table structure is present as a header at the beginning.
+ *
+ * The following functions help to manipulate the SLRT structure
+ * and contents.
+ */
+
+/*
+ * Return the address of the end of the SLRT past the final entry.
+ */
+static inline void *slr_end_of_entries(struct slr_table *table)
+{
+	return (void *)table + table->size;
+}
+
+/*
+ * Return the next entry in the SLRT given the current entry passed
+ * to the function. NULL is returned if there are no entries to return.
+ */
+static inline void *
+slr_next_entry(struct slr_table *table,
+	       struct slr_entry_hdr *curr)
+{
+	struct slr_entry_hdr *next = (struct slr_entry_hdr *)((u8 *)curr + curr->size);
+
+	if ((void *)next >= slr_end_of_entries(table))
+		return NULL;
+	if (next->tag == SLR_ENTRY_END)
+		return NULL;
+
+	return next;
+}
+
+/*
+ * Return the next entry with the given tag in the SLRT starting at the
+ * current entry. If entry is NULL, the search begins at the beginning of
+ * table.
+ */
+static inline void *
+slr_next_entry_by_tag(struct slr_table *table,
+		      struct slr_entry_hdr *entry,
+		      u16 tag)
+{
+	if (!entry) /* Start from the beginning */
+		entry = (struct slr_entry_hdr *)(((u8 *)table) + sizeof(*table));
+
+	for ( ; ; ) {
+		if (entry->tag == tag)
+			return entry;
+
+		entry = slr_next_entry(table, entry);
+		if (!entry)
+			return NULL;
+	}
+
+	return NULL;
+}
+
+/*
+ * Add an entry to the SLRT. Entries are placed at the end.
+ */
+static inline int
+slr_add_entry(struct slr_table *table,
+	      struct slr_entry_hdr *entry)
+{
+	struct slr_entry_hdr *end;
+
+	if ((table->size + entry->size) > table->max_size)
+		return -1;
+
+	memcpy((u8 *)table + table->size - sizeof(*end), entry, entry->size);
+	table->size += entry->size;
+
+	end = (struct slr_entry_hdr *)((u8 *)table + table->size - sizeof(*end));
+	end->tag = SLR_ENTRY_END;
+	end->size = sizeof(*end);
+
+	return 0;
+}
+
+/*
+ * Initialize the SLRT for use. This prepares the meta-data in the SLRT
+ * header section of the table and table end entry.
+ */
+static inline void
+slr_init_table(struct slr_table *slrt, u16 architecture, u32 max_size)
+{
+	struct slr_entry_hdr *end;
+
+	slrt->magic = SLR_TABLE_MAGIC;
+	slrt->revision = SLR_TABLE_REVISION;
+	slrt->architecture = architecture;
+	slrt->size = sizeof(*slrt) + sizeof(*end);
+	slrt->max_size = max_size;
+	end = (struct slr_entry_hdr *)((u8 *)slrt + sizeof(*slrt));
+	end->tag = SLR_ENTRY_END;
+	end->size = sizeof(*end);
+}
+
+#endif /* !__ASSEMBLER__ */
+
+#endif /* _LINUX_SLR_TABLE_H */
-- 
2.47.3

