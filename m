Received: from mta1.migadu.com (out-121.mta1.migadu.com [95.215.58.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2714570F9
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 10:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516653; cv=none; b=pHb6dKNq9UkZ8ZLk9TZBcfmRVUpiXAoPuCi+CUKo6y1ZWfVPD6C7leaAolKH6H34YTaQQPB6JcDtwEOTuNiaqz6ZmVigmbENlu/R3IVPXkaXFZhTvNAs7QngZ9gwexJAvoPPGczf+wU/YuIOyfpc17W7n0W7q/BfaDrIaMfbMf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516653; c=relaxed/simple;
	bh=3cPgANBsAN0TCTPt7lj+YGACHJ2FHFsC3fuQuOraQMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmbaV/ev8FJVr/s7E0svV8oxd4lhsb3A/sqwXqsMf9Swlgvy/LJxf5LVFvsRFl/zvsV6P9eMj0xMXt6o8frwuO5bT0mjd4hcs2+DhFUghITG9uUbRkXHdSG4ePZIGwzYAuHxqui/ZqjSLL/5ye/hSpU1UUDYOmWXLLuGAdxivJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jOYuemRc; arc=none smtp.client-ip=95.215.58.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jOYuemRc"
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3cPgANBsAN0TCTPt7lj+YGACHJ2FHFsC3fuQuOraQMA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788516636; v=1; x=1789121436;
 b=jOYuemRcWo5KL+QgZmCOv9MMIDTecQV4sy4qKJZoKBEmf5d3iNXBGG9bnLcIf1/rcI4GcegT
 fTUoHhog/yvL5xoVRmK1vLBPfhssLCgKuA5gqPNvAsN6NJaLVLdygn8180W+R8x0Ym3nDkEmxor
 QWjA6/7/PTIMc6MQxWL3/CAY=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 031a72623a973772;
	Fri, 04 Sep 2026 10:10:35 +0000
X-Mizu-Trace-ID: 031a72623a973772
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org
Cc: ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v5 4/5] LoongArch: enable kexec handover (KHO)
Date: Fri,  4 Sep 2026 18:08:51 +0800
Message-ID: <20260904100852.26006-5-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260904100852.26006-1-dongtai.guo@linux.dev>
References: <20260904100852.26006-1-dongtai.guo@linux.dev>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: George Guo <guodongtai@kylinos.cn>

Enable ARCH_SUPPORTS_KEXEC_HANDOVER for 64-bit LoongArch.  It selects
EFI_KHO whenever KEXEC_HANDOVER is enabled, so LoongArch uses the
architecture-agnostic EFI configuration table channel
(LINUX_EFI_KEXEC_HANDOVER_GUID) introduced by this series to carry the
KHO state across kexec.

LoongArch boots through EFI without a device tree, so it cannot use the
/chosen FDT path that arm64 and riscv use; the EFI configuration table
channel is its handover transport.  No arch-specific setup.c reader or
machine_kexec_file.c writer is needed -- both live in the generic EFI
code.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 arch/loongarch/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index a21f51e5815e..5eaa65578d58 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -685,6 +685,10 @@ config ARCH_SUPPORTS_KEXEC
 config ARCH_SUPPORTS_KEXEC_FILE
 	def_bool 64BIT
 
+config ARCH_SUPPORTS_KEXEC_HANDOVER
+	def_bool 64BIT && EFI_STUB
+	select EFI_KHO if KEXEC_HANDOVER
+
 config ARCH_SELECTS_KEXEC_FILE
 	def_bool 64BIT
 	depends on KEXEC_FILE
-- 
2.53.0

