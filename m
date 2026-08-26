Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AB53B27C3;
	Wed, 26 Aug 2026 12:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787745890; cv=none; b=dpsPSNPNF5w8pGv2qoRWwH2RV1x35BT/tTEI9VgCs++bqbCZy0o/vTJ2OH9l0QT+YniPvL0+dC21qciyTVuEK9bRDYPFQAeLnPM7xJ8JgtkazXkxTW5vTlwcQYRiO3aeF+QStc9X3wqktp8HpbY4AfkozwL1JK/FUd/hMQL7a2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787745890; c=relaxed/simple;
	bh=Z8b00DBJDYmFMxDESa/wECCjyj43cNByhLt+GnEMGjE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JRyX4x6hlFlkvGzo6ftyXaS/R3LxFgktLIXyfsvkaopXYur52fkZ39+/SbyGJ3awcy/5TnrZzgS2EnXQPF0+nlDRuXOCRNpB2P/pVGMaTz3+P3QWbAoy4DAVCEPukHOcyjLJa1rDqWlP2sKtYF21yqc59XPlGYc1W+gX8SX3NuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=cZ0z3oge; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="cZ0z3oge"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=SbhxHAltudSE0Y7J28CXSXgoY/4tm3ypaV92q+OPD6w=; b=cZ0z3ogevdcXQzQ5GhLC05zUwp
	M+5wDzf9EsLcy4LYngVhl89EkZq1EaPRSYy1/U9V6MJLBPspg93eLTBCnN54vrNDP0bMvrcKYj4f5
	Sl8ZQ7M8kJWInXTLznOQczUcDhXA5l1BwxJa/ZvKLde36p/XJZOjP1cGZDCeS6BlUcn7eVfLE4gdl
	WNhHwWRoaX1J5zzCjfFMOSa2brMeTYTBUVv4SNpy9ittK9K3X7h7Eyuc/IKpUTQ3vy0VIZghn+aTg
	k+9mYbvHt2vWGPdOI6fadMm3BqnmI91y9Va1A1FkVHqwZhoAlUDlz1S18zY/62HgnxSyHkpc4Z2m0
	GuhUaVSQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wzCN2-00FCX7-0W;
	Wed, 26 Aug 2026 12:04:44 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 26 Aug 2026 05:03:53 -0700
Subject: [PATCH v3 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-hwpoison-kho-v3-2-6f79c4b605bc@debian.org>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
In-Reply-To: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=6932; i=leitao@debian.org;
 h=from:subject:message-id; bh=Z8b00DBJDYmFMxDESa/wECCjyj43cNByhLt+GnEMGjE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqjtZKCfXr+dnXUwLgGGNeFWUmXAQhZ+kSTWYJA
 Hzxms8X/JCJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCao7WSgAKCRA1o5Of/Hh3
 be/zEACHP8bvz1QjTQwWBaPet8gNeZG1+KYIya8WM1+MgshAC5+ey7drOS8BCpNxrysa3F5fkf4
 LdifpMwKwcvWpCS/sfge65xHAa0pXw0HuZSfRZRYs3W0aJiecqi8VnSBcnvWqZMC4YmzL4pSAJT
 eJtIV9KPHpkSosP5uWNVt5zUmoRkPkW0xabbHeT6a58/EhrWCHbMECL9h1FQe8cgi9i2SFOO01w
 YoWawYBXm5yHibTA51AdSYv0ECDNBkkkWCcYq2+8fCYdT8NvJlvZN+mf+qvdKIuHimuY1gIhXnn
 JHxcL7ydriKL0s+iG0TjR28UUFtue+27taHs0LTcdyzshGXFcUIqEHC5SUz3s9R800igEJ+qruo
 AwPLy1ksEHFiSMx3WAYfzlZaJwCbB6E12NF53/lSm9egtUvOaC6M8HQeDYM9gUhWuAIa8CeXucH
 suA1ZOmv2IWK2/81u53OpinphIrC6lgjyYQHhQhrUazMBCI89Wc2K56zZn5IYQLVbyaHGnlQ+sw
 /8TmSweReLtzOhr4C4HA63UGKykv3+ToyEmgSmCUqBnA6DPqSzcyJIMn6IfLY7lEEfbxGS3IV1F
 BYM/epE4dzBB/KYas4VRhdb6sNDzNs8yI7msKFbFckPofKxc6p63TY6maeu/1pTNWjZahl2o0fo
 38kI/QCzNEBAGEw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

A EFI config table can only be installed while boot services are still
up, so the stub has to create it; the running kernel can only flip bits
in a table that already exists.

Size the bitmap from the top of usable RAM, which efi_get_ram_top()
works out by walking the UEFI memory map, since the stub has no max_pfn.
Bit N covers unit N counting from address 0, so the table tracks
max_pfn. Memory the firmware hot-adds later sits above it and is not
carried across a kexec.

One table has to serve every architecture, so efi_get_ram_top() takes
the union of the memory types they turn into RAM: what setup_e820() maps
to E820_TYPE_RAM on x86, plus the EFI_ACPI_RECLAIM_MEMORY and
EFI_PERSISTENT_MEMORY that is_usable_memory() accepts on arm64. Sizing
wide only costs bitmap bytes; sizing narrow silently drops the records
for every frame above the top.

At one bit per 2M that is 64K per TiB, and 256M at the 4PB x86
architectural maximum. The 2M granule is called "unit" here, and the
table carries it so the granule can change later without breaking the
kernels already reading it.

Allocate it as EFI_ACPI_RECLAIM_MEMORY so the next kernel does not take
it for free RAM, and install it empty.

A table installed by an earlier boot rides the system table across kexec
and is reused as-is.

x86 does not go through efi_stub_common(), so the generic stub and the
x86 stub each need the call; on x86 it has to come before exit_boot(),
which is the last point a configuration table can be installed.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 106 +++++++++++++++++++++++++
 drivers/firmware/efi/libstub/efi-stub.c        |   1 +
 drivers/firmware/efi/libstub/efistub.h         |   6 ++
 drivers/firmware/efi/libstub/x86-stub.c        |   2 +
 4 files changed, 115 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index f27f2e1f00199..b8b80846239d0 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -774,3 +774,109 @@ void efi_remap_image(unsigned long image_base, unsigned alloc_size,
 			efi_warn("Failed to remap data region non-executable\n");
 	}
 }
+
+#ifdef CONFIG_EFI_POISONED_MEMORY
+/* Erring wide only costs bitmap bytes, so the type list is permissive. */
+static efi_status_t efi_get_ram_top(u64 *top)
+{
+	struct efi_boot_memmap *map __free(efi_pool) = NULL;
+	efi_status_t status;
+	u64 ram_top = 0;
+	int i, nr_desc;
+
+	status = efi_get_memory_map(&map, false);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	nr_desc = map->map_size / map->desc_size;
+	for (i = 0; i < nr_desc; i++) {
+		efi_memory_desc_t *d;
+
+		d = efi_memdesc_ptr((unsigned long)map->map, map->desc_size, i);
+		switch (d->type) {
+		case EFI_LOADER_CODE:
+		case EFI_LOADER_DATA:
+		case EFI_BOOT_SERVICES_CODE:
+		case EFI_BOOT_SERVICES_DATA:
+		case EFI_CONVENTIONAL_MEMORY:
+		case EFI_UNACCEPTED_MEMORY:
+		case EFI_ACPI_RECLAIM_MEMORY:
+		case EFI_PERSISTENT_MEMORY:
+			ram_top = max(ram_top,
+				      d->phys_addr + d->num_pages * EFI_PAGE_SIZE);
+			break;
+		default:
+			break;
+		}
+	}
+	if (!ram_top)
+		return EFI_NOT_FOUND;
+
+	*top = ram_top;
+	return EFI_SUCCESS;
+}
+
+/* Whole words: the kernel reaches the bitmap with set_bit(). */
+static u64 efi_poison_bitmap_size(u64 ram_top)
+{
+	u64 bytes = DIV_ROUND_UP(DIV_ROUND_UP(ram_top, EFI_POISON_UNIT_SIZE),
+				 BITS_PER_BYTE);
+
+	return round_up(bytes, sizeof(unsigned long));
+}
+
+/* ACPI reclaim memory, so the next kernel does not treat it as free RAM. */
+static struct linux_efi_poisoned_memory *efi_poison_alloc(u64 bitmap_size)
+{
+	struct linux_efi_poisoned_memory *pm;
+	efi_status_t status;
+
+	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
+			     sizeof(*pm) + bitmap_size, (void **)&pm);
+	if (status != EFI_SUCCESS)
+		return NULL;
+
+	pm->version = 1;
+	pm->unit_size = EFI_POISON_UNIT_SIZE;
+	pm->size = bitmap_size;
+	memset(pm->bitmap, 0, bitmap_size);
+
+	return pm;
+}
+
+void install_poisoned_memory_table(void)
+{
+	efi_guid_t poisoned_memory_table_guid = LINUX_EFI_POISONED_MEMORY_TABLE_GUID;
+	struct linux_efi_poisoned_memory *pm;
+	u64 ram_top, bitmap_size;
+	efi_status_t status;
+
+	/* A table installed by an earlier boot rides the system table across kexec. */
+	pm = get_efi_config_table(poisoned_memory_table_guid);
+	if (pm) {
+		if (pm->version != 1)
+			efi_err("Unknown version of poisoned-memory table\n");
+		return;
+	}
+
+	if (efi_get_ram_top(&ram_top) != EFI_SUCCESS) {
+		efi_err("Failed to size the poisoned-memory table!\n");
+		return;
+	}
+
+	bitmap_size = efi_poison_bitmap_size(ram_top);
+
+	pm = efi_poison_alloc(bitmap_size);
+	if (!pm) {
+		efi_err("Failed to allocate poisoned-memory table!\n");
+		return;
+	}
+
+	status = efi_bs_call(install_configuration_table,
+			     &poisoned_memory_table_guid, pm);
+	if (status != EFI_SUCCESS) {
+		efi_bs_call(free_pool, pm);
+		efi_err("Failed to install poisoned-memory config table!\n");
+	}
+}
+#endif
diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 42d6073bcd062..008635eb5027a 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -179,6 +179,7 @@ efi_status_t efi_stub_common(efi_handle_t handle,
 			 EFI_RT_SUPPORTED_SET_VIRTUAL_ADDRESS_MAP);
 
 	install_memreserve_table();
+	install_poisoned_memory_table();
 
 	status = efi_boot_kernel(handle, image, image_addr, cmdline_ptr);
 
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index fd91fc15ec810..44436869c4efe 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1169,6 +1169,12 @@ efi_enable_reset_attack_mitigation(void) { }
 
 void efi_retrieve_eventlog(void);
 
+#ifdef CONFIG_EFI_POISONED_MEMORY
+void install_poisoned_memory_table(void);
+#else
+static inline void install_poisoned_memory_table(void) { }
+#endif
+
 struct sysfb_display_info *alloc_primary_display(void);
 struct sysfb_display_info *__alloc_primary_display(void);
 void free_primary_display(struct sysfb_display_info *dpy);
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index cef32e2c82d8f..f90de11bc8855 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -1023,6 +1023,8 @@ void __noreturn efi_stub_entry(efi_handle_t handle,
 
 	setup_unaccepted_memory();
 
+	install_poisoned_memory_table();
+
 	status = exit_boot(boot_params, handle);
 	if (status != EFI_SUCCESS) {
 		efi_err("exit_boot() failed!\n");

-- 
2.53.0-Meta

