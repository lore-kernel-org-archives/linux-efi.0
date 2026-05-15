Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A153B40244C
	for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 21:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879709; cv=none; b=XOl7kMHS4zn3VEkVJWN6Z7m8XN+0Xkcyquz2JqlztW00pGOBggi12BERpEgmdSEmJqdhzCo3A8G+7S0W+Yd3GxmOmK44uh21vsezCGGr684kH6+uQSfeuPi3nyS9hUyvauv9qO3agcg2MUir1tx7Y2gIkTmnU55cxHYeB305rLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879709; c=relaxed/simple;
	bh=Tu9t8Jkh6fC+t56oYQneuDB8ZEA9SNOFnZ6DDoMFzQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BzGf/EANTo1syxFTFFzQISy7BjydoxjpInQCRQlTsE9SUQD9z8+1QUd1Xtu3ZRHARzOc1Ocp+5iKfFmd0L8AyfKLjz1Fa0fDxFiHMkjxDjgPM94dZWsTusK/peWnN1ob6kZ7Akp5GuGh/UV6ZW6Ovb+CvJPvyhZVUYIPQ+hl+oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q8RTMCDB; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q8RTMCDB"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-30246cfd41aso1511953eec.1
        for <linux-efi@vger.kernel.org>; Fri, 15 May 2026 14:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879707; x=1779484507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=riwrj5pQHn0ODreltS6IigjzckrdFiF16wrIV559GfE=;
        b=q8RTMCDBQNNpp+1B7uaytrz6bOhnFKw6mChy6QThpgUaMWY1wt6/G0aq4fmg1Z6w+N
         G9jsVnr6GYZvuTDjaQL7ES/cYyQ85ywKrNVJneolqmkLPYrDiEYWlaso2k1bQsb+1pqk
         F5wNhOU9xpBLmYHuGVk5baepwXbZByjWxp8AcqIEyz4z/VFqsxsYFYlWzhKfZJKurvSG
         GWh3HbqCJJoIFKTbH88tVNGVwLHaCh+kXTAtwSIGkNCwt1c4o/5uD61gn8mw7Fgad1Qy
         2KUyCFh0Mfb65sG6B9GJj+RZLE44kIpBOlpLnjJirFpjA5J8OIAws76GMve/NAfNq7dF
         WxBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879707; x=1779484507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=riwrj5pQHn0ODreltS6IigjzckrdFiF16wrIV559GfE=;
        b=UgRECeg+3a95VaeEmBAduOzBOKr9QxIlSh2ctY1bjQ3x2VssSXODiVlw5jP+m5p7+0
         4Zw4Bhj8qswPijBpjXjWpJedBt9kVg2OdQJSgzCK1wQ/vRCcvSwRgtiR/GArGU+soki8
         dGubEmEIzdRFYpajf9fc8aUheSK8ZCO/F7Zp7jtPfUDHbEIXFzBX8Px3tI19dd6BVOkJ
         zUtG8/D90gVupmL8cO4d5bprBB2Pgb2fKneY6PC2ijzIL83eZiy2hPP/OZtxrwckl9Lb
         rwRzrpzAnuoc2KCyFtKiZCmojBMJCD/wwVP2VITiWJItyPz/NkaWN/epKbI98mXncEND
         Ly+g==
X-Forwarded-Encrypted: i=1; AFNElJ9bSNyFGrKvyKRIJCZasyV2sjXX0vbr9rUFgf5XF64Gfly3buWlEjl6TSV9L82kMPvOLHtgktExv+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSBlxYbpx9tq717WrVEvwyHn7Z9viNLdhYjymkK7WTiZXuusqN
	ey4MXdPOfx63SRAb733iOWhtIXHrv8NTizc187azcFi0jdBd3KvqE3Wh
X-Gm-Gg: Acq92OE9B6hm5Dp+oFxPpT/OEBENC8F/ARK3+599ZRZAkAqFb067y6f8a7KEovGeT/o
	/Gxvsk/wiry5+6CdtHWQipdNpT7yNB3P8du4s+lzFrZ2r0f4Mp0VCWBTRYdLCfGujbWHkib7JUP
	+mP+FSAMd/+MXDs/h1egAcZRQfQ/OFzWqGR/co6atNkh3frIYVSysI1FB4Xx3BB8dLJMG5q3veg
	VFdxwX/uRwR9CnPk153TvrUiBrHfVkiKceG7hAJF1k9bEYHxX4LtiDP1MzXKTTndu8ttbFMPL5W
	Ty+ywThihkLaoZq+V/BDvPupG5jjF7EuRhheaa8+3Pi63TZyqCfCnmqHN2sQ3fXyhzZVyjMhYx7
	s//sBj8L3+eRwS2sXrYsk7bO6Yz6rZBUoCJwW5J/SaKxZH8oq6RlMi/zG2Xd57XaM/l5xyIL8xs
	nqRv+s1mfWCGp0v4EK2u4Y+m3aVZFMqCU=
X-Received: by 2002:a05:7022:1e11:b0:12d:de3f:d843 with SMTP id a92af1059eb24-1350494e25cmr2535293c88.38.1778879706757;
        Fri, 15 May 2026 14:15:06 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cc3490bcsm9740744c88.15.2026.05.15.14.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:15:06 -0700 (PDT)
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
Subject: [PATCH v16 19/38] x86: Secure Launch main header file
Date: Fri, 15 May 2026 14:13:51 -0700
Message-ID: <20260515211410.31440-20-ross.philipson@gmail.com>
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

Introduce the main Secure Launch header file. This header file
contains the platform neutral feature definitions:
 - Secure Launch error codes
 - DRTM TPM event logging definitions and helper functions
 - Other feature specific structures and definitions

Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 include/linux/slaunch.h | 262 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 262 insertions(+)
 create mode 100644 include/linux/slaunch.h

diff --git a/include/linux/slaunch.h b/include/linux/slaunch.h
new file mode 100644
index 000000000000..7874a49c27b5
--- /dev/null
+++ b/include/linux/slaunch.h
@@ -0,0 +1,262 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Main Secure Launch header file.
+ *
+ * Copyright (c) 2026 Apertus Solutions, LLC
+ * Copyright (c) 2026, Oracle and/or its affiliates.
+ */
+
+#ifndef _LINUX_SLAUNCH_H
+#define _LINUX_SLAUNCH_H
+
+#include <asm/txt.h>
+
+/*
+ * Secure Launch Defined State Flags
+ */
+#define SL_FLAG_ACTIVE		0x00000001
+#define SL_FLAG_ARCH_TXT	0x00000002
+
+/*
+ * Secure Launch CPU Type
+ */
+#define SL_CPU_INTEL	1
+
+#define __SL32_CS	0x0008
+#define __SL32_DS	0x0010
+#define __SL64_CS	0x0018
+
+/*
+ * Secure Launch Defined Error Codes used in MLE-initiated TXT resets.
+ *
+ * Intel Trusted Execution Technology (TXT) Software Development Guide
+ * Appendix I - ACM Error Codes
+ */
+#define SL_ERROR_GENERIC		0xc0008001
+#define SL_ERROR_TPM_INIT		0xc0008002
+#define SL_ERROR_TPM_INVALID_LOG20	0xc0008003
+#define SL_ERROR_TPM_LOGGING_FAILED	0xc0008004
+#define SL_ERROR_REGION_STRADDLE_4GB	0xc0008005
+#define SL_ERROR_TPM_EXTEND		0xc0008006
+#define SL_ERROR_MTRR_INV_VCNT		0xc0008007
+#define SL_ERROR_MTRR_INV_DEF_TYPE	0xc0008008
+#define SL_ERROR_MTRR_INV_BASE		0xc0008009
+#define SL_ERROR_MTRR_INV_MASK		0xc000800a
+#define SL_ERROR_MSR_INV_MISC_EN	0xc000800b
+#define SL_ERROR_INV_AP_INTERRUPT	0xc000800c
+#define SL_ERROR_INTEGER_OVERFLOW	0xc000800d
+#define SL_ERROR_HEAP_WALK		0xc000800e
+#define SL_ERROR_HEAP_MAP		0xc000800f
+#define SL_ERROR_REGION_ABOVE_4GB	0xc0008010
+#define SL_ERROR_HEAP_INVALID_DMAR	0xc0008011
+#define SL_ERROR_HEAP_DMAR_SIZE		0xc0008012
+#define SL_ERROR_HEAP_DMAR_MAP		0xc0008013
+#define SL_ERROR_HI_PMR_BASE		0xc0008014
+#define SL_ERROR_HI_PMR_SIZE		0xc0008015
+#define SL_ERROR_LO_PMR_BASE		0xc0008016
+#define SL_ERROR_LO_PMR_MLE		0xc0008017
+#define SL_ERROR_INITRD_TOO_BIG		0xc0008018
+#define SL_ERROR_HEAP_ZERO_OFFSET	0xc0008019
+#define SL_ERROR_WAKE_BLOCK_TOO_SMALL	0xc000801a
+#define SL_ERROR_MLE_BUFFER_OVERLAP	0xc000801b
+#define SL_ERROR_BUFFER_BEYOND_PMR	0xc000801c
+#define SL_ERROR_OS_SINIT_BAD_VERSION	0xc000801d
+#define SL_ERROR_EVENTLOG_MAP		0xc000801e
+#define SL_ERROR_TPM_INVALID_ALGS	0xc000801f
+#define SL_ERROR_TPM_EVENT_COUNT	0xc0008020
+#define SL_ERROR_TPM_INVALID_EVENT	0xc0008021
+#define SL_ERROR_INVALID_SLRT		0xc0008022
+#define SL_ERROR_SLRT_MISSING_ENTRY	0xc0008023
+#define SL_ERROR_SLRT_MAP		0xc0008024
+
+/*
+ * Secure Launch Defined Limits
+ */
+#define SL_MAX_CPUS		512
+#define SL_BOOT_STACK_SIZE	128
+
+/*
+ * Secure Launch event log entry type. The TXT specification defines the
+ * base event value as 0x400 for DRTM values.
+ *
+ * Intel Trusted Execution Technology (TXT) Software Development Guide
+ * Appendix F - TPM Event Log
+ */
+#define SL_EVTYPE_BASE			0x400
+#define SL_EVTYPE_SECURE_LAUNCH		(SL_EVTYPE_BASE + 0x102)
+
+/*
+ * MLE scratch area offsets within TXT OS-MLE SL defined portion of the heap.
+ */
+#define SL_SCRATCH_AP_EBX		0
+#define SL_SCRATCH_AP_JMP_OFFSET	4
+#define SL_SCRATCH_AP_STACKS_OFFSET	8
+
+#ifndef __ASSEMBLER__
+
+#include <linux/io.h>
+#include <linux/tpm_eventlog.h>
+
+/*
+ * Secure Launch AP stack and monitor block
+ */
+struct sl_ap_stack_and_monitor {
+	u32 monitor;
+	u32 cache_pad[15];
+	u32 stack_pad[15];
+	u32 apicid;
+} __packed;
+
+/*
+ * Secure Launch AP wakeup information fetched in SMP boot code.
+ */
+struct sl_ap_wake_info {
+	u32 ap_wake_block;
+	u32 ap_wake_block_size;
+	u32 ap_jmp_offset;
+	u32 ap_stacks_offset;
+};
+
+/*
+ * TXT Heap Map structure
+ */
+struct sl_txt_heap_info {
+	u64 size;
+	u64 offset;
+};
+
+/*
+ * Secure Launch defined OS/MLE TXT Heap table
+ *
+ * This table is defined at the top level by the TXT specification
+ * but the format of this structure is implementation specific.
+ *
+ * Intel Trusted Execution Technology (TXT) Software Development Guide
+ * Appendix C - Intel TXT Heap Memory
+ */
+struct txt_os_mle_data {
+	u32 version;
+	u32 reserved;
+	u64 slrt;
+	u64 txt_info;
+	u32 ap_wake_block;
+	u32 ap_wake_block_size;
+	u8 mle_scratch[64];
+} __packed;
+
+#ifdef CONFIG_SECURE_LAUNCH
+
+/*
+ * TPM event logging functions.
+ */
+
+/*
+ * Log a TPM v1 formatted event to the given DRTM event log.
+ */
+static inline int tpm_log_event(void *evtlog_base, u32 evtlog_size,
+				u32 event_size, void *event)
+{
+	struct tpm_event_log_header *evtlog =
+		(struct tpm_event_log_header *)evtlog_base;
+
+	if (memcmp(evtlog->signature, TPM_EVTLOG_SIGNATURE,
+		   sizeof(TPM_EVTLOG_SIGNATURE)))
+		return -EINVAL;
+
+	if (evtlog->container_size > evtlog_size)
+		return -EINVAL;
+
+	if (evtlog->next_event_offset + event_size > evtlog->container_size)
+		return -E2BIG;
+
+	memcpy(evtlog_base + evtlog->next_event_offset, event, event_size);
+	evtlog->next_event_offset += event_size;
+
+	return 0;
+}
+
+/*
+ * Log a TPM v2 formatted event to the given DRTM event log.
+ */
+static inline int tpm2_log_event(struct txt_heap_event_log_pointer2_1_element *elem,
+				 void *evtlog_base, u32 evtlog_size,
+				 u32 event_size, void *event)
+{
+	struct tcg_pcr_event *header =
+		(struct tcg_pcr_event *)evtlog_base;
+
+	/* Has to be at least big enough for the signature */
+	if (header->event_size < sizeof(TCG_SPECID_SIG))
+		return -EINVAL;
+
+	if (memcmp((u8 *)header + sizeof(struct tcg_pcr_event),
+		   TCG_SPECID_SIG, sizeof(TCG_SPECID_SIG)))
+		return -EINVAL;
+
+	if (elem->allocated_event_container_size > evtlog_size)
+		return -EINVAL;
+
+	if (elem->next_record_offset + event_size >
+	    elem->allocated_event_container_size)
+		return -E2BIG;
+
+	memcpy(evtlog_base + elem->next_record_offset, event, event_size);
+	elem->next_record_offset += event_size;
+
+	return 0;
+}
+
+/*
+ * External functions available in mainline kernel.
+ */
+void slaunch_setup(void);
+void slaunch_fixup_ap_wake_vector(void);
+u32 slaunch_get_flags(void);
+struct sl_txt_heap_info *slaunch_txt_get_heap_map(void);
+void *slaunch_txt_get_heap_table(void *heap, u8 index);
+struct sl_ap_wake_info *slaunch_get_ap_wake_info(void);
+struct acpi_table_header *slaunch_get_dmar_table(struct acpi_table_header *dmar);
+void __noreturn slaunch_reset(void *ctx, const char *msg, u64 error);
+void slaunch_finalize(int do_sexit);
+
+static inline bool slaunch_is_txt_launch(void)
+{
+	u32 mask = SL_FLAG_ACTIVE | SL_FLAG_ARCH_TXT;
+
+	return (slaunch_get_flags() & mask) == mask;
+}
+
+#else
+
+static inline void slaunch_setup(void)
+{
+}
+
+static inline void slaunch_fixup_ap_wake_vector(void)
+{
+}
+
+static inline u32 slaunch_get_flags(void)
+{
+	return 0;
+}
+
+static inline struct acpi_table_header *slaunch_get_dmar_table(struct acpi_table_header *dmar)
+{
+	return dmar;
+}
+
+static inline void slaunch_finalize(int do_sexit)
+{
+}
+
+static inline bool slaunch_is_txt_launch(void)
+{
+	return false;
+}
+
+#endif /* !CONFIG_SECURE_LAUNCH */
+
+#endif /* !__ASSEMBLER__ */
+
+#endif /* _LINUX_SLAUNCH_H */
-- 
2.47.3

