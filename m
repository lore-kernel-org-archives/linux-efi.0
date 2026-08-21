Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72747472F9B;
	Fri, 21 Aug 2026 10:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787306826; cv=none; b=E6Sj38oFftAMiXZerUT+JGqVEfD5W7q78d7Khb/oSMi0IK71E/IojPZunYuxP3ISpVm/nVz1aYNlm+qY+lxdEDG34b+WjjFAiMKYS9HA+7Y3GC1QE0R82XZ1YM1rsYu9e+YMJPA+0ZPYULEQY17IER+IBEEB0hQnzMLRzfihzak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787306826; c=relaxed/simple;
	bh=Z/vnT9K1G8JkfMrXbm/2Q9zXt1siFCixL2PK45FYBZE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ebtabbN+idt3IhLXQuqMa0lSlQTgK9MxOxtybkdnPgQOmhLdtAbmiratUakTDpcD5kHKEFWsYrJlU6afOB3MNDM7b7o1SE/Hy65zTiYdvfx6hFiD3833cZPjvZOJKRS0qtLBjfWhqI9PJcBIcE6E+J0zRqSDfc/I6npiwnVcb1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=iGManAEd; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="iGManAEd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=GijpPHV/MlnALkvostyEz/qvgq+mkhNTyT2lnEH+3cc=; b=iGManAEdaf1RslOR2kQtj60Uau
	2cPekOu/rvVOIMx+a/RdULWoQqOizOXh9q2ResBctGch27Ylb26QCtMYYfgmdE0XpZOAsBFzMamnL
	6BFmHMrcpmbyp1X293U+Dzi56na2S7mreb8TCnLeDRv7lIvfYUztITa+wd8S28EnULOIjsdp6zCz2
	ygwkTFKI7KZ1LE+ByVAiwUyKRgo+NDY87YkDiTYcgxtzTT7FUH1OThNQG2yKJFvJORcEbRjnbmn6T
	jH/d5KqWpDiJzP6Q6SQwrbQbOOIDievRHSFNWQHnRifdGuRIe3jS17kLLO4AF8VTd6MJ3x+TDNTWS
	DjHeOyLw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxM8u-00BGBG-16;
	Fri, 21 Aug 2026 10:06:32 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 21 Aug 2026 03:06:02 -0700
Subject: [PATCH v2 2/6] efi: add the LINUX_EFI_POISONED_MEMORY
 configuration table
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-hwpoison-kho-v2-2-5743791e48e6@debian.org>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
In-Reply-To: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, kas@kernel.org, riel@surriel.com, 
 kexec@lists.infradead.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=4479; i=leitao@debian.org;
 h=from:subject:message-id; bh=Z/vnT9K1G8JkfMrXbm/2Q9zXt1siFCixL2PK45FYBZE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqiCMaQOgra0AgIH7Fhhk615ZgT/EKbr1P24x+f
 vcF/X/ROlaJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaogjGgAKCRA1o5Of/Hh3
 bbwQD/9xKGVGX5YWvlXXOMyaxbNwxB6OkudoXxGeuMi480JxdrtEbNG9MKwYTTv+hBls5nFsxOs
 PCOU1GsJSwPEqeByAAOJUv9WCo/izqKh7nERh7ft/ZdZSwd8SroxpkL/5ZQ8U8HRRq7D6leBHUp
 eK7J1vgRdboT7WVSt4sU8iG9psRa35T4D++40LNwoH9WrlHsw94+tRils2g6fS2DmaRBbitQGDG
 0BVBo1RFRhYRxH8Fmjcb6Ll633456uZzbvD5KmUrH1bJRfvJeLHBn7cu345txlsZHRwWj4640bS
 R47Ayqj5pV/UCuBoUskVSeud8qf2bIr0Q3KWKxc92biz9d4tBTZOZ4O4JvX+r0OQ8qCu1q1bpe7
 GAf9iuKPhgjSHvozRIKj0k+qvmdowhOOt9gYieCf4WvuYp396iJ6xIOUptwyRURhZg1Ys7w5Yyj
 TPIwogIuh8fVqZQO6LaBQMcxVGvpkZSaOzw2kMwDFMRV2YXibFj9jUlZzTaGJBkso/dIe5AijRh
 yciexX3E9NOeG/eY9g3FHxM0vcg4JvyTaNdkxw/GR6S9LvTgDVlolK4TUmkFrbv/JmgJRkntw08
 2lznEos9GOe4K1+6lmLvcIlLKXZaGAmxi4tCyMoLhzdbwpne9cjplDV+9h0qLABHoxqIvOvpXu7
 5eFmHY2Z6fn+Eaw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Hardware-poisoned page frames are tracked only in the running kernel's
data structures, so a kexec loses them and the next kernel doesn't have
this information, thus, tripping into them again.

Add an EFI configuration table to carry that information across kexec.

It is a bitmap with one bit per EFI_POISON_UNIT_SIZE (2MiB) of physical
memory, modeled on the LINUX_EFI_UNACCEPTED_MEMORY table, and it rides
the EFI system table to every kernel in the chain.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/Kconfig | 10 ++++++++++
 drivers/firmware/efi/efi.c   |  6 ++++++
 include/linux/efi.h          | 13 +++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 29e0729299f5b..69c0dc02bc112 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -263,6 +263,16 @@ config EFI_COCO_SECRET
 	  virt/coco/efi_secret module to access the secrets, which in turn
 	  allows userspace programs to access the injected secrets.
 
+config EFI_POISONED_MEMORY
+	bool "Carry hardware-poisoned pages across kexec"
+	depends on EFI_STUB && MEMORY_FAILURE && 64BIT
+	help
+	  Record page frames that are hardware-poisoned while this kernel runs
+	  into an EFI configuration table, and honor that table early on the
+	  next kernel so a kexec does not hand known-bad RAM back out.
+
+	  If unsure, say N.
+
 config OVMF_DEBUG_LOG
 	bool "Expose OVMF firmware debug log via sysfs"
 	depends on EFI
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 0327a39d31fa5..111e60479211a 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -55,6 +55,9 @@ struct efi __read_mostly efi = {
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	.unaccepted		= EFI_INVALID_TABLE_ADDR,
 #endif
+#ifdef CONFIG_EFI_POISONED_MEMORY
+	.poisoned_memory	= EFI_INVALID_TABLE_ADDR,
+#endif
 };
 EXPORT_SYMBOL(efi);
 
@@ -646,6 +649,9 @@ static const efi_config_table_type_t common_tables[] __initconst = {
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	{LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID,	&efi.unaccepted,	"Unaccepted"	},
 #endif
+#ifdef CONFIG_EFI_POISONED_MEMORY
+	{LINUX_EFI_POISONED_MEMORY_TABLE_GUID,	&efi.poisoned_memory,	"POISON"	},
+#endif
 #ifdef CONFIG_EFI_GENERIC_STUB
 	{LINUX_EFI_PRIMARY_DISPLAY_TABLE_GUID,	&primary_display_table			},
 #endif
diff --git a/include/linux/efi.h b/include/linux/efi.h
index b3c83516593d1..ce0980a5bb81b 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -23,6 +23,7 @@
 #include <linux/pstore.h>
 #include <linux/range.h>
 #include <linux/reboot.h>
+#include <linux/sizes.h>
 #include <linux/uuid.h>
 
 #include <asm/page.h>
@@ -422,6 +423,7 @@ void efi_native_runtime_setup(void);
 #define LINUX_EFI_COCO_SECRET_AREA_GUID		EFI_GUID(0xadf956ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
 #define LINUX_EFI_BOOT_MEMMAP_GUID		EFI_GUID(0x800f683f, 0xd08b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
 #define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID	EFI_GUID(0xd5d1de3c, 0x105c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
+#define LINUX_EFI_POISONED_MEMORY_TABLE_GUID	EFI_GUID(0x78a5bf07, 0x7d2a, 0x2889,  0x16, 0x31, 0x63, 0xd4, 0x56, 0xf2, 0x83, 0x50)
 
 #define RISCV_EFI_BOOT_PROTOCOL_GUID		EFI_GUID(0xccd15fec, 0x6f73, 0x4eec,  0x83, 0x95, 0x3e, 0x69, 0xe4, 0xb9, 0x40, 0xbf)
 
@@ -650,6 +652,7 @@ extern struct efi {
 	unsigned long			mokvar_table;		/* MOK variable config table */
 	unsigned long			coco_secret;		/* Confidential computing secret table */
 	unsigned long			unaccepted;		/* Unaccepted memory table */
+	unsigned long			poisoned_memory;	/* Hardware-poisoned memory table */
 
 	efi_get_time_t			*get_time;
 	efi_set_time_t			*set_time;
@@ -1271,6 +1274,16 @@ struct linux_efi_memreserve {
 #define EFI_MEMRESERVE_COUNT(size) (((size) - sizeof(struct linux_efi_memreserve)) \
 	/ sizeof_field(struct linux_efi_memreserve, entry[0]))
 
+struct linux_efi_poisoned_memory {
+	u32		version;
+	u32		unit_size;	/* bytes of phys space per bitmap bit */
+	u64		phys_base;	/* phys address covered by bit 0 */
+	u64		size;		/* bitmap size in bytes */
+	unsigned long	bitmap[];
+};
+
+#define EFI_POISON_UNIT_SIZE	SZ_2M
+
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
 
 /*

-- 
2.53.0-Meta

