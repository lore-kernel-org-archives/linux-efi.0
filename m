Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7543D4756D4;
	Fri, 21 Aug 2026 10:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787306829; cv=none; b=hCzo23xQxYa1ezZsBd0todCwrlaGDo3BrfXA1iysS3sRkk5bib6dN2keF0vX3jyLOOB7pdqSW4tv64GgquMjCVH7vRLK0KaHSaVMVZuZD3jshSOn+NaRzH014Ya2+mzkSLJ/4k3vwFVqE0Hu/DEH0qD5JxzS6iZhz3MRIAbrWps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787306829; c=relaxed/simple;
	bh=zsnCaEJjr4WDYRVIG0kIJ3bs7R9uvNp2xzudAoWoA6U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=o/PUIDLRM7Wg1rs2XrB000/2xWee4gT6KqmK+XEUILm7uMrg/CqOR8eRwdB4HRy3OYlXB5lpjzV1yOxg18JBKuamptCiG/xEOCSkCCrw5QJP1TpG+A4/gt+p8mBiL59zjAEkl0uJ9c5D2jfPODOO8fgSkrGmtEWmZz7H1pwKWOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=JpgEkXdv; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="JpgEkXdv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=uSbfStPdbr5U0zykVDsBNKewNVAMS5oNdmlQT4Yzkm4=; b=JpgEkXdvDryDyqfLO0w6yqBV2Y
	po9ZYmBcuuqI6K+8Bngw5grb44nVueQqJqyMib3N12wBXWSTP3kfjJpViJ/KqsWS10+pKLtQXroux
	3zs72OdNSfraFY5tvnzRIMOPasTACbKrv7irFHssTWRMwqkrZqxqF0MgtrFDskCuCuzMiWDGyv6n9
	11trmB9cEpvrFyXbSHx4T5gRUqghgL+4kERDaojynRBBe69+Mh5YZDRTMfp6hEMJx1f42y+Cp4faK
	Ve9zBMAX0DYXQaEPNx1lahDGe0fDgiLNriggWzRHsW40wDi10ol3DFJsI0eC7vYI9TeACJDS9Xezb
	OgZtd8zg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxM8p-00BGBE-2w;
	Fri, 21 Aug 2026 10:06:28 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 21 Aug 2026 03:06:01 -0700
Subject: [PATCH v2 1/6] efi/libstub: add a helper for the top of usable RAM
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-hwpoison-kho-v2-1-5743791e48e6@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3412; i=leitao@debian.org;
 h=from:subject:message-id; bh=zsnCaEJjr4WDYRVIG0kIJ3bs7R9uvNp2xzudAoWoA6U=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqiCMa+W8jcyD0u0SyGOn1kbwZALutc1lA3Zhhy
 qAmTakDK4KJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaogjGgAKCRA1o5Of/Hh3
 bT35D/9SVn4DqMGqAj5kaAZRL6R7KVMcpYT4xdA1bnQ36xXLRr6PlPIy3/U/Avm8oLzAWW8h0/T
 dSpko6t2GqNkpZYSY8IuELnOGbhlzMtTySVLrEXxcH4gCWWYdxgetVxBTgtJj+9bAiLd3dUhji0
 hg7W+VVaskZGhLAenosUqpF3/mwgIO8JWuf55/DrJj9ZY05EBcaU/eWyyZqDvRNX9ENWezAHfYW
 gDXz2Ib7cyRJSknqb1J0FAFM+xUaiV2P0X0wq2+jyk0COyMd5wWOAMGUc764hQXhmEV2MlVr+Qi
 LXWEpp9encGy7VnT7uDYRXg8kWsAK/19ivwcBlYO+tuXOmRb7RiB+OkURRv2nqb7Azd0XmlItJn
 CvbWlmSOoS06/vNZhmzAIFuJ5yf8tZaJEmEkuRa1q7MMcNJtIdA0YDceKm2kt/bbf+hoDgqJz2K
 qNYqHn1BWMoR4VIbM+ZrpSSTAr3OCpuXF2le6KrbP0PHb+SG1MPSGJTPKIr5TMJAUR+/jrX04xV
 9WUeW4FasYe5O9C/izHkbKCql1JrHv2/q2cUPN4rCwjPhPW9QA6eVgETQ/8hXeAf7V/YxYojrlY
 GkMu0GuBk6f3sfjOtJfAKfXRyVu6l4ljhLKWQ3v54aBtxVD8PKnUSLn91ZD6FH6E6PwfWdVKIYu
 kW1eajB8O7w2lFg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

The stub has no way to ask how far RAM reaches, which is useful to
create a bitmap that covers the whole memory.

max_pfn answers that for the kernel, but it is only set in
setup_arch(), long after the stub has handed off, so, unfortunately we
cannot use it here..

Add efi_get_ram_top(), which returns the highest address reached by the
entry types that become usable RAM. Unaccepted memory is counted as
well, as suggested by Kiryl.

Memory the firmware hot-adds later is *not* in the memory map, so it is
not covered; that matches max_pfn, which is likewise the top of the
memory present at boot.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/libstub/efistub.h |  2 ++
 drivers/firmware/efi/libstub/mem.c     | 53 ++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index fd91fc15ec810..77ba576779aca 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1094,6 +1094,8 @@ char *efi_convert_cmdline(efi_loaded_image_t *image);
 efi_status_t efi_get_memory_map(struct efi_boot_memmap **map,
 				bool install_cfg_tbl);
 
+efi_status_t efi_get_ram_top(u64 *top);
+
 efi_status_t efi_allocate_pages(unsigned long size, unsigned long *addr,
 				unsigned long max);
 
diff --git a/drivers/firmware/efi/libstub/mem.c b/drivers/firmware/efi/libstub/mem.c
index 59f3f83de50c2..777f1f180c66e 100644
--- a/drivers/firmware/efi/libstub/mem.c
+++ b/drivers/firmware/efi/libstub/mem.c
@@ -64,6 +64,59 @@ efi_status_t efi_get_memory_map(struct efi_boot_memmap **map,
 	return EFI_SUCCESS;
 }
 
+/**
+ * efi_get_ram_top() - find the top of usable RAM
+ * @top:	on return, the end of the highest memory map entry that becomes
+ *		usable RAM
+ *
+ * Walk the UEFI memory map for the entry types that become usable RAM, the set
+ * setup_e820() maps to E820_TYPE_RAM, and return the highest address any of
+ * them reaches. Memory a confidential guest has not accepted yet counts as
+ * well, since it becomes RAM once accepted. This is what the stub has in place
+ * of max_pfn, which is only set once the kernel proper is up.
+ *
+ * Memory the firmware hot-adds later is not described by the memory map and so
+ * is not accounted for here.
+ *
+ * Return:	status code
+ */
+efi_status_t efi_get_ram_top(u64 *top)
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
 /**
  * efi_allocate_pages() - Allocate memory pages
  * @size:	minimum number of bytes to allocate

-- 
2.53.0-Meta

