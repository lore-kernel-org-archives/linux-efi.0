Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C69485CC4;
	Tue,  1 Sep 2026 16:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281856; cv=none; b=Hya2gG0Mm15zcy7AxHY/eHpcVh+q2kXwP/mR3JsWYCdulqFqzT8niiT1pGPxecq/7h1LPhKwByZumKW6hYPRSVgXrNe2DABX8bKIPccsc+W0s2LG5PZkbV2v/7hjBI15sHVOo9CCH60+8L4GGybFQcsLmcdVj21Ufl9CDbsvGYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281856; c=relaxed/simple;
	bh=AqlGXiVXf37eh22vHSTx9JaWG/V6ubR35mhahPGPQBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCF6PWpQ+hXLyxM9d0y+zz7jBcqCgSSdUJvduHeUxhXfgK9btRrgp1p914uzbQm+sSlmHJCMvNsRJuCtoY6l1R0ItbS8iLw3LFuKAM7fUShO0/TPEdto2HpzbBqQ2M6AAVoQYrDeFqScc0ONcRqbe4vdEI7ffWDI32I9brz0aJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=WX8y3hoB; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="WX8y3hoB"
Received: by linux.microsoft.com (Postfix, from userid 1130)
	id 4E7F520B703B; Tue,  1 Sep 2026 09:56:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4E7F520B703B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788281815;
	bh=Pnx8Bj8E6wa9z9v4waAAekvlC25njxpIEY0WH/R0iXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WX8y3hoBoGyybXNeAFKK+e/bkxFiPQ1o+ld/V9sMIm3//6oWYQPfpsRuS0uCZwu+n
	 bE6V3bvgRkADF2qA0orsEWApO0QyM005HzYejVGds1mJji4i/k5ylIz4gKvfQzTh3w
	 Droee3zX8Sp0VncsDb586EPDsfebMXHZrvbBy3yU=
From: Thara Gopinath <tgopinath@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	ardb@kernel.org,
	ilias.apalodimas@linaro.org
Cc: James.Bottomley@HansenPartnership.com,
	"longli@microsoft.com--cc=tzimmermann"@suse.de, javierm@redhat.com,
	lszubowi@redhat.com, francescopompo2@gmail.com,
	tgopinath@microsoft.com, x86@kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Thara Gopinath <tgopinath@linux.microsoft.com>
Subject: [RFC PATCH 12/12] drivers: hv: hv_vsm_boot: Boot secondary processors in VTL1
Date: Tue,  1 Sep 2026 09:55:26 -0700
Message-ID: <20260901165647.3160413-13-tgopinath@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The next step after the primary CPU is running in VTL1 is to boot
the remaining CPUs in VTL1, so the secure kernel executes on every
VP rather than only VP0. Hyper-V does not drive this: VTL1 needs to
know which APs to expect, and each AP must issue its own vtlcall
from VTL0 to actually transition.

As on the boot CPU, VTL1 must be enabled at each VP and its initial
VP context (RIP, GDT, page tables, etc.) built before that VP can
enter VTL1. This can only be done from VTL1 for non boot CPus.
Introduce VSM_VTL_CALL_FUNC_ID_BOOT_APS, a vtlcall the boot cpu issues
from VTL0, which asks the secure kernel to enable VTL1 and set up the
initial VP context for each AP in the supplied online-CPU mask.
The mask is handed to VTL1 via a shared page whose PFN is passed in
the vtlcall arguments; VTL1 copies it synchronously so the page can be
freed as soon as the call returns.

Once VTL1 has prepared the APs, bring them into VTL1 one at a time
using a CPU-bound FIFO kthread and a completion. Serialising this
way keeps VTL1 entries ordered and lets a per-AP failure be
surfaced synchronously to the caller. Uniprocessor systems skip AP
bring-up entirely.

Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
---
 drivers/hv/hv_vsm.h      |   2 +
 drivers/hv/hv_vsm_boot.c | 125 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/hv_vsm.h b/drivers/hv/hv_vsm.h
index 88f099f88eeb4..679cb9dc9afda 100644
--- a/drivers/hv/hv_vsm.h
+++ b/drivers/hv/hv_vsm.h
@@ -12,6 +12,8 @@
 #include <linux/ioport.h>
 #include <linux/types.h>
 
+#define VSM_VTL_CALL_FUNC_ID_BOOT_APS		0x1FFE1
+
 extern struct resource sk_res;
 
 #endif /* _HV_VSM_H */
diff --git a/drivers/hv/hv_vsm_boot.c b/drivers/hv/hv_vsm_boot.c
index c4f15c42df1f6..ad161b2f56653 100644
--- a/drivers/hv/hv_vsm_boot.c
+++ b/drivers/hv/hv_vsm_boot.c
@@ -17,6 +17,7 @@
 #include <linux/namei.h>
 #include <linux/acpi.h>
 #include <linux/firmware.h>
+#include <linux/kthread.h>
 #include <hyperv/vsm.h>
 #include <asm/e820/types.h>
 #include <asm/mshyperv.h>
@@ -64,6 +65,20 @@ static int hv_vsm_get_register(u32 reg_name, u64 *result)
 	return 0;
 }
 
+static __init struct page *hv_vsm_alloc_shared_page(void)
+{
+	struct page *page;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page) {
+		pr_err("Unable to establish VTL0-VTL1 shared page\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	memset(page_address(page), 0, PAGE_SIZE);
+	return page;
+}
+
 static Elf64_Addr __init hv_vsm_elf_min_load_paddr(void *image)
 {
 	Elf64_Ehdr *ehdr = image;
@@ -326,6 +341,107 @@ static int __init hv_vsm_init_code_page_offsets(void)
 	return 0;
 }
 
+struct hv_vsm_ap_boot_ctx {
+	struct completion done;
+	int ret;
+};
+
+static int __init hv_vsm_boot_sec_vp_thread_fn(void *arg)
+{
+	struct hv_vsm_ap_boot_ctx *ctx = arg;
+	struct hv_vtlcall_param args = {0};
+	int cpu = smp_processor_id();
+	u16 vp_enabled_vtl_set = 0;
+	u8 active_mbec_enabled = 0;
+	s64 sk_status;
+	int ret = 0;
+
+	pr_info("cpu%d entering vtl1 boot thread\n", cpu);
+	sk_status = hv_vsm_vtlcall(&args);
+	if (sk_status)
+		pr_warn("VP%d VTL1 boot returned status %lld\n", cpu, sk_status);
+
+	ret = hv_vsm_get_vp_status(&vp_enabled_vtl_set, &active_mbec_enabled);
+	if (ret)
+		goto out;
+
+	if (!active_mbec_enabled) {
+		pr_err("Failed to enable MBEC for VP%d\n", cpu);
+		hv_vsm_mbec_enabled = false;
+	}
+out:
+	ctx->ret = ret;
+	complete(&ctx->done);
+	return 0;
+}
+
+static int __init hv_vsm_boot_one_ap(unsigned int cpu)
+{
+	struct hv_vsm_ap_boot_ctx ctx;
+	struct task_struct *t;
+
+	init_completion(&ctx.done);
+	ctx.ret = 0;
+
+	t = kthread_create(hv_vsm_boot_sec_vp_thread_fn, &ctx,
+			   "hv-vtl1-ap%u", cpu);
+	if (IS_ERR(t))
+		return PTR_ERR(t);
+
+	kthread_bind(t, cpu);
+	sched_set_fifo(t);
+	wake_up_process(t);
+
+	wait_for_completion(&ctx.done);
+	return ctx.ret;
+}
+
+static int __init hv_vsm_boot_ap_vtl(void)
+{
+	struct hv_vtlcall_param args = {0};
+	struct page *cpu_online_page;
+	unsigned int cpu, cur_cpu = smp_processor_id();
+	s64 sk_status;
+	int ret;
+
+	cpu_online_page = hv_vsm_alloc_shared_page();
+	if (IS_ERR(cpu_online_page))
+		return PTR_ERR(cpu_online_page);
+
+	cpumask_copy(page_address(cpu_online_page), cpu_online_mask);
+
+	/*
+	 * Hand VTL1 the set of APs to expect. VTL1 copies the mask
+	 * synchronously inside this vtlcall and does not reference the
+	 * page after it returns, so freeing it here is safe.
+	 */
+	args.a0 = VSM_VTL_CALL_FUNC_ID_BOOT_APS;
+	args.a1 = page_to_pfn(cpu_online_page);
+	sk_status = hv_vsm_vtlcall(&args);
+	__free_page(cpu_online_page);
+	if (sk_status) {
+		pr_err("VTL1 refused BOOT_APS: status %lld\n", sk_status);
+		return -EIO;
+	}
+
+	/*
+	 * Bring the APs into VTL1 one at a time. Each AP kthread issues
+	 * a single vtlcall on its bound CPU and signals completion; wait
+	 * for it to finish before starting the next so VTL1 entries stay
+	 * serialized.
+	 */
+	for_each_online_cpu(cpu) {
+		if (cpu == cur_cpu)
+			continue;
+		ret = hv_vsm_boot_one_ap(cpu);
+		if (ret) {
+			pr_err("Failed to boot VP%u into VTL1: %d\n", cpu, ret);
+			return ret;
+		}
+	}
+	return 0;
+}
+
 static int __init hv_vsm_boot_vtl1(void)
 {
 	struct hv_vtlcall_param args = {0};
@@ -430,7 +546,14 @@ static int __init hv_vsm_bootstrap_vtl(void)
 		return ret;
 
 	/* Boot primary virtual processor in VTL1 */
-	return hv_vsm_boot_vtl1();
+	ret = hv_vsm_boot_vtl1();
+	if (ret)
+		return ret;
+
+	if (num_present_cpus() == 1)
+		return 0;
+
+	return hv_vsm_boot_ap_vtl();
 }
 
 static void __init hv_vsm_get_sk_mem(void)
-- 
2.34.1

