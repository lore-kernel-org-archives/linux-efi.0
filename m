Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1E03F9F4C
	for <linux-efi@vger.kernel.org>; Fri,  7 Aug 2026 10:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786099092; cv=none; b=TLxFIQwutM2I4c2RGJ75LTIVfkq3xtogWfHW8Btw4PPw5yy2NfHdEA5obBBK4X6TI4Gb5eY4Rc6WmyoZ56RaYKUsz5/Q7TYmQEnf13908vj3VPa8v/Skfzf07a0B0J+KNMVc8Tcx3ei69K3rIAladpUig5JTVX8JmNarZeBS4T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786099092; c=relaxed/simple;
	bh=M0AMxb+cVwP+atxrSkKPR5Z4+wp0xXh/yRjnQIRVMmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ot4I87OmuUrwL7i1jfiYJJkCqZdvTTttqhOb4bS/jI7pSKBNP5J96UTZAwf2NTB+x1ggbwRaE40vhWK5IcHC/TCJ0zKpW4sgMTWAD8FqchsxggnHsg3deQUYC8iZOM27A/gwaxcZDeS8Eg1Cfk84mGEAhQ9TEboRUEV8SIhWX0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nUqGglQE; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nUqGglQE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786099088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8MnGA2XpLaKtX7cmmtolKrMtU3s+BumW1DYNOt54uYU=;
	b=nUqGglQEFSiDP4w9XvLdasgzgUzCQg3EnaBt8s3qJmMZ9muZcSGKjRgCCxC6fluOTVKSvm
	ouR+zIBF+Rfk3GovmnF0OOku9DgEgMRJniWkjd5Hmv1wpvfO38bX97LZBO5HGVKAJB1uoZ
	i51ax670tcY7f0PpRSNY+JBndvEY7kY=
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	shuah@kernel.org,
	ardb@kernel.org
Cc: guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v4 1/4] efi: add a KHO configuration table GUID
Date: Fri,  7 Aug 2026 18:37:11 +0800
Message-ID: <20260807103714.33074-2-dongtai.guo@linux.dev>
In-Reply-To: <20260807103714.33074-1-dongtai.guo@linux.dev>
References: <20260807103714.33074-1-dongtai.guo@linux.dev>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: George Guo <guodongtai@kylinos.cn>

Kexec Handover (KHO) passes the address of its state FDT and of its
scratch area from the current kernel to the next one.  On architectures
that boot with a device tree, the current kernel writes the
linux,kho-fdt and linux,kho-scratch properties into /chosen, and the next
kernel reads them back in early_init_dt_check_kho().

Architectures that boot through EFI without a device tree have no such
channel.  LoongArch is one of them: its efistub passes the EFI system
table and the command line to the core kernel directly and never creates
an FDT.  x86 has the same problem and carries the state out of band
instead, in a struct kho_data in the setup_data chain of its boot
protocol.

Add an out-of-band channel for EFI: a LINUX_EFI_KHO_TABLE_GUID
configuration table entry, under a randomly generated GUID, pointing at a
struct linux_efi_kho_data.  The
current kernel loads the structure and an extended configuration table as
kexec segments, then switches the EFI system table to the new table
before jumping.  The next kernel finds the entry by GUID and calls
kho_populate().

The structure carries no version field.  An incompatible change to the
layout must use a new GUID, which is the usual rule for EFI configuration
tables.  The handover payload itself is versioned separately, by the
compatible string of the KHO state FDT that kho_populate() checks.

This patch adds the definitions only.  LoongArch is the first user; any
other EFI architecture without a boot FDT can use the same channel.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 include/linux/efi.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index ccbc35479684..789ab9e4312a 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -422,6 +422,7 @@ void efi_native_runtime_setup(void);
 #define LINUX_EFI_COCO_SECRET_AREA_GUID		EFI_GUID(0xadf956ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
 #define LINUX_EFI_BOOT_MEMMAP_GUID		EFI_GUID(0x800f683f, 0xd08b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
 #define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID	EFI_GUID(0xd5d1de3c, 0x105c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
+#define LINUX_EFI_KHO_TABLE_GUID		EFI_GUID(0xc941b6c7, 0x7b3f, 0x4af6,  0x9e, 0x50, 0xfc, 0xb3, 0xa8, 0x86, 0x8a, 0x17)
 
 #define RISCV_EFI_BOOT_PROTOCOL_GUID		EFI_GUID(0xccd15fec, 0x6f73, 0x4eec,  0x83, 0x95, 0x3e, 0x69, 0xe4, 0xb9, 0x40, 0xbf)
 
@@ -1271,6 +1272,29 @@ struct linux_efi_memreserve {
 
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
 
+/*
+ * The LINUX_EFI_KHO_TABLE_GUID config table points to this structure.  It
+ * carries the kexec handover (KHO) state from the current kernel to the next
+ * one: the addresses of the KHO state FDT and of the scratch area.
+ *
+ * This is the handover channel for architectures that boot through EFI without
+ * a device tree, where the /chosen linux,kho-fdt and linux,kho-scratch
+ * properties read by early_init_dt_check_kho() are not available.  The current
+ * kernel loads the structure and an extended configuration table as kexec
+ * segments; the next kernel finds it by GUID and calls kho_populate().
+ *
+ * The layout is an ABI between the two kernels and is fixed.  It carries no
+ * version field: an incompatible change must use a new GUID, and the handover
+ * payload itself is versioned separately by the compatible string of the KHO
+ * state FDT, which kho_populate() checks.
+ */
+struct linux_efi_kho_data {
+	u64 fdt_addr;
+	u64 fdt_size;
+	u64 scratch_addr;
+	u64 scratch_size;
+} __packed;
+
 /*
  * The LINUX_EFI_MOK_VARIABLE_TABLE_GUID config table can be provided
  * to the kernel by an EFI boot loader. The table contains a packed
-- 
2.53.0

