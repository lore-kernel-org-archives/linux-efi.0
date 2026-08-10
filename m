Received: from outbound.mr.icloud.com (mr-2001f-snip4-11.eps.apple.com [57.103.68.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63F33AEF43
	for <linux-efi@vger.kernel.org>; Mon, 10 Aug 2026 10:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.68.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786357372; cv=none; b=B/NycU1qHFnv/xDGPJ0Gkx77UQfCH84gIGJyIUcq2pY69ot7qGGut5+Wy8XwtVvYxkQ+eTzwFM/Sj67bfMVxLoPr/PhEYtt5mGULUEarECDuDtdp5Uj0ndKEAP43E15wSGtL3SqQDrKGbgjv8YqWh7j64T1kyYLzDShOfVIbdPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786357372; c=relaxed/simple;
	bh=3LOEJNXtjFEiOOH8294GIrC1UQolDXX0nU0bk6m0bCE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SDuaLq2vCpuJ3mKmzttWjW6vqrOcdGI6UQobW1NLDeWj/6+CmqXV8c9/20No8IUmTHpN2axkkedMeZkXXEQLDyuoGyhXP+9BBPjdGOTXtiWd2YK49lNP6Ppc9FBBF0dNKxA4/yuuCLBvZNYShZqGzZQQyaQ4u0SaK8vDnEQwq44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=jiaKgkLW; arc=none smtp.client-ip=57.103.68.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="jiaKgkLW"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-6 (Postfix) with ESMTPS id B99AF1800170;
	Mon, 10 Aug 2026 10:22:48 +0000 (UTC)
X-ICL-RepId: 019feb32-477c-7ecf-888e-8458d8777f30
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1PHVwPUxxGClYCVAFLVxQEHUAFVgpcQglLAi1eCF4fTBwdDlgGEhZdRVoOWwRHFBcbXAAXGVFNCEkTBVIHXU1WDUcPWB5cFBcVQUNeCF4fTBwdDlgGEgBNCg42BlkFXglWA0MFNhIUXUVaDlsERxQXG1wAFwZbFAREAV0FXQJICEgCXQVZAUcXSgJbAFMFQhRJHghEA1MRV0oDXgYrWxNVF0YJGQhdHQdYRxRHDg8ZWhRcGFM=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1786357370; x=1788949370; bh=pCDaUqi75J+60IGlSuOZ0Z5KyC1+rrvU9UrfvESnsMg=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=jiaKgkLWyqZ0PPa5x0rxnQV4gMhAwxGc8Dfm/J8UA2NNaWizOsydQ262lAxi0OsZNCzI5qVNryv+I6iUNo1y89/CxARKw47BmWtg/0VI3mMHQ8Mnb2CcCBwU0sa4lxqtXzjMTr9bQ0gta/197wpVh88HU77OXIPxzRNlRKoX5RspUrUAhDKiHL2OA28fZriiXdWrZ5yD7CUlNc1Z6czqhYh3JT0GapXT0gR3AFqv/z3NVTz39cs7scxGLK7SUwtxHgfJrdUXAcLFu897dFSb+c5Uld1o2PHj4sO6Ifbutxm9v7Fo1/ezIiMKW5CZyQ0UyjgVgjhg1dDNtufXoHxzbQ==
Received: from machine (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-6 (Postfix) with ESMTPSA id A636518000B8;
	Mon, 10 Aug 2026 10:22:47 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: ardb@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org
Cc: ilias.apalodimas@linaro.org,
	hpa@zytor.com,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH] x86/efi: Handle errors for efi_map_region_fixed()
Date: Mon, 10 Aug 2026 05:22:37 -0500
Message-ID: <20260810102237.2167872-1-eshaan2031@icloud.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Info-Out: v=2.4 cv=H4/WAuYi c=1 sm=1 tr=0 ts=6a79a679
 cx=c_apl:c_pps:t_out a=9OgfyREA4BUYbbCgc0Y0oA==:117
 a=9OgfyREA4BUYbbCgc0Y0oA==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=plAyUd4ex9BnA7TlT6sA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDA5MCBTYWx0ZWRfXzONqG1igsY6d
 fSO6tUl92gwZYGh4H9yiQoaGpdJFR7/85CV+l9AxmkLDypg5ouIPkzonFNvv+Wlj/TSIG+IPzvC
 2AIZFxAC9LpUS9/44F4nbmriQ5/2QTFbLMP+Elv86D2DFuH73+7joV7/k0dqEl3DS4WEy1ylgxQ
 CDpyK19+bIbpx8HCLbJES1it7zv8dXkNTvPtK2APvrtYARjrbH6PCrRRpjNMSq9wHoQwSwicwh8
 f33ekJQfuCybYiK7CSDu+JIHwaD3xXSWkKFBvUpa1NwC8SJ9aD4rWfKZypIXk29nhworRImj89v
 oOspFKvl1bcYj9jtRDv4HiwMLlI4kGlKCpdNFYU122eQNDQ/tNCuifueZWu3pY=
X-Proofpoint-GUID: sdTPgo80LpwdzcV63QNvusWkRep5U657
X-Proofpoint-ORIG-GUID: sdTPgo80LpwdzcV63QNvusWkRep5U657

The function efi_map_region_fixed() ignores the errors returned from
kernel_map_pages_in_pgd(). If mapping failes, this can cause page
faults. Update __map_region() and efi_map_region_fixed() to return the
error code from kernel_map_pages_in_pgd(). If there is an error,
efi_map_region_fixed() logs an error message using pr_err(), disables
EFI runtime services, and returns.

Signed-off-by: Eshaan Deshmukh <eshaan2031@icloud.com>
---
 arch/x86/include/asm/efi.h     |  2 +-
 arch/x86/platform/efi/efi.c    | 10 ++++++++--
 arch/x86/platform/efi/efi_32.c |  6 +++++-
 arch/x86/platform/efi/efi_64.c | 20 ++++++++++++++------
 4 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index be58b7f5c..04952e064 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -128,7 +128,7 @@ extern bool efi_disable_ibt_for_runtime;
 extern int __init efi_memblock_x86_reserve_range(void);
 extern void __init efi_print_memmap(void);
 extern void __init efi_map_region(efi_memory_desc_t *md);
-extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
+extern int __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
 extern int __init efi_alloc_page_tables(void);
 extern int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0c39adb96..4b875843a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -735,8 +735,14 @@ static void __init kexec_enter_virtual_mode(void)
 	* Map efi regions which were passed via setup_data. The virt_addr is a
 	* fixed addr which was used in first kernel of a kexec boot.
 	*/
-	for_each_efi_memory_desc(md)
-		efi_map_region_fixed(md); /* FIXME: add error handling */
+	for_each_efi_memory_desc(md) {
+		if (efi_map_region_fixed(md)) {
+			pr_err("Failed to map fixed EFI region\n");
+			clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+			return;
+		}
+
+	}
 
 	/*
 	 * Unregister the early EFI memmap from efi_init() and install
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index b2cc7b455..9307999b9 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -84,7 +84,11 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	return 0;
 }
 
-void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
+int __init efi_map_region_fixed(efi_memory_desc_t *md)
+{
+	return 0;
+}
+
 void __init parse_efi_setup(u64 phys_addr, u32 data_len) {}
 
 efi_status_t efi_call_svam(efi_runtime_services_t * const *,
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 5861008ea..05f1df6ca 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -269,12 +269,12 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	return 0;
 }
 
-static void __init __map_region(efi_memory_desc_t *md, u64 va)
+static int __init __map_region(efi_memory_desc_t *md, u64 va)
 {
 	unsigned long flags = _PAGE_RW;
 	unsigned long pfn;
 	pgd_t *pgd = efi_mm.pgd;
-
+	int error;
 	/*
 	 * EFI_RUNTIME_SERVICES_CODE regions typically cover PE/COFF
 	 * executable images in memory that consist of both R-X and
@@ -299,9 +299,11 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
 		flags |= _PAGE_ENC;
 
 	pfn = md->phys_addr >> PAGE_SHIFT;
-	if (kernel_map_pages_in_pgd(pgd, pfn, va, md->num_pages, flags))
+	error = kernel_map_pages_in_pgd(pgd, pfn, va, md->num_pages, flags);
+	if (error)
 		pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
 			   md->phys_addr, va);
+	return error;
 }
 
 void __init efi_map_region(efi_memory_desc_t *md)
@@ -357,10 +359,16 @@ void __init efi_map_region(efi_memory_desc_t *md)
  * md->virt_addr is the original virtual address which had been mapped in kexec
  * 1st kernel.
  */
-void __init efi_map_region_fixed(efi_memory_desc_t *md)
+int __init efi_map_region_fixed(efi_memory_desc_t *md)
 {
-	__map_region(md, md->phys_addr);
-	__map_region(md, md->virt_addr);
+	int error;
+
+	error = __map_region(md, md->phys_addr);
+
+	if (error)
+		return error;
+
+	return __map_region(md, md->virt_addr);
 }
 
 void __init parse_efi_setup(u64 phys_addr, u32 data_len)
-- 
2.55.0

