Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795426961;
	b=MruD9GyOftcAEErZZc41Kw31IhlBzW2TdA66TmTXRDry+TjDIZwuvE5rORJgJBhhrQ+x
	 pPuu1kEit/ul4W8rtL6D1KvBeo0HYzrVXk+2vBvuWnwS5kheg20Xubx2hQsgBSfoneg2e
	 rACXKVXOZixb3frU21FrE7BYe2nrN2oSRJJb+4kNoB4fOVjfKBJ9VPTF9kXw8CuKQxp9m
	 Z+xAiJ5klWHdg5rozTE0+aOWs1gIAI/n23W0wZ0PLAwQLCYDXpWTZ2MkheMxGOm3/aCKF
	 PPqiSSymr+Yx6ve3YYWazJgi8w5mqN7Tzr4BTbYSTnm+tMlycq0ZSL4BgYnnZ+qf5pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795426961;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=m0G/OIDphCmJ+9PUfV8KKg0ofQUhcoNHIFrdri+NSHI=;
	b=UIMuA7sY01Cb3duNt2L3Hf28MJrgzmZdKN2+BV/Z4hnujrvEZU1XbQiQ7g2AFVadZFOP
	 miWlv7Lm31WMxz6xEZcJP33dqhpgWAviib4y46bQJm/uKlotGynJVwgOdMWn+bVk741GM
	 3SwAU9miz4MS7gHYCqSraKyDIZCerG5/qI3aA73x50iyDVptDjrkkdK4F6EuRz2otltCU
	 xblN8XLN6Iu8kzRmQsfulpbfTOXrqIQsvLYiPqw/A7ALJ6dmi5d+jW8gEjxKVOFp5vGki
	 mDyN2rpHmilvUCYkjlYkcfbBzfdDVwwkTtW69vt65jqwYVt2aXMTPNtovAWeLpvjsug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dXJtODMx;
	arc=none smtp.remote-ip=209.85.208.69
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C172A606A31F
	for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 09:42:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C172A606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dXJtODMx
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b5654ad27fso2138119a12.1
        for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 01:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795426958; x=1796031758; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m0G/OIDphCmJ+9PUfV8KKg0ofQUhcoNHIFrdri+NSHI=;
        b=dXJtODMxsrWN16EsV6DpStGuxx9Kv/XzGQJsqZQD0hrjC++OXV3Em64yKb/qwQOkmm
         BR1iF79ZqJVknaI47e6oYgIXMgFUlFvsd/BCb34/7URAhnQmdcADEJc08INJDtCSVAx2
         NabJZZv/copqXCD7k5/wnMxVSEj4NeDmmX1THwcM6oBu83jqBuSNVOtp/zyhEqkyhS8d
         GFWgE7REskcsZDVlFBPU0wIJt0nHjpsj5I8C3mpPQdZYQfr3Ihp4/dxuXAQEj9EnFlNn
         yrfXn5qhfNrKsQEfjaJeVjiCZEkwQXm7dC50A9P3WZQi03plDIzTadIq0JV0L66gStCh
         1m4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795426958; x=1796031758;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m0G/OIDphCmJ+9PUfV8KKg0ofQUhcoNHIFrdri+NSHI=;
        b=UgoKxI7EWcnjTVMMkY02lAyhm2vK96TzRvQmM8ylYCZcI+BZg9OHGBIYYPV9t+ESQp
         Ou3o3ue9HqLDGvezBNyPdwkUfY0yEdm4bb09TIPQ6zMV4Y9c7VH8Rb0YxA32yZWci2oQ
         RZVWgoPirzV7bT2WftYSQzSMIwaKzO08GwgzQ9Skf6coLbCVUWLWt7cSDVGODczVCj/D
         SPp9SzWkbvn2Gzzmff2Sm9gOZNYGw/U4U8SNQlWk6ZMskFYjwQq/52bc6V+ukrCsai2J
         hf3BUcEMufHOAmb1CZnwS8+KwqV/ooS1Sg/E455aOXQd6GmAlkjwUeZl8Zv2IOHeC6sj
         042A==
X-Gm-Message-State: APuU4Z+ynuvff/h02kMuhxsODDhuy4AupsHEzDeoBgqyPRGxbrA4I0sS
	23nmf16+evkWYjhyxQW0/4Q+adMGdJEtk3LzsEAyWl1PD4TBk6CBBdyj3o13FF2PQWVMwwZbiXb
	o+pgjUpMMEVrlkv+kE2+ie+nJUHA3aJBjX3xPeoaUxCnHP8W/8etmaKXCgXWTdK/wtAZC0s/QDA
	pyLgMA7gucn4P3JKCa/WRi+ghn0pYOQw==
X-Received: from edtg7.prod.google.com ([2002:aa7:c847:0:b0:6b8:98f6:dcc5])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3645:b0:6b8:7ec0:7506
 with SMTP id 4fb4d7f45d1cf-6ba37e95796mr7149951a12.25.1795426957704; Mon, 23
 Nov 2026 01:42:37 -0800 (PST)
Date: Mon, 23 Nov 2026 10:42:30 +0100
In-Reply-To: <20261123094228.466164-4-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261123094228.466164-4-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6238; i=ardb@kernel.org;
 h=from:subject; bh=2K1xzHHDca/Q7/XhQnLx7OcNRqjzifvQ9zWs6mpo5F4=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZuFq33uPTZN5yZFV67ihz9t5jhwdc/uXtvlE+Qr66twu
 T09Y1NHKQuDGBeDrJgii8Dsv+92np4oVes8SxZmDisTyBAGLk4BmEgNO8P/RH/jv/ntX32MY8+G
 3ku5/cBWetVHoefP76Tu3fVmc3OLHsNfAf24ayK+wc0BIZ02J1ifF5SuqzffkbMqfJ7nEdYcgRI GAA==
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261123094228.466164-5-ardb+git@google.com>
Subject: [PATCH 1/2] x86/efi: Disregard the INITRD and MEMATTR config tables
 after kexec
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jasmeet (Jazz) Bhatia" <jasmeet.bhatia.us@gmail.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

When the EFI stub loads the initrd itself, it describes its location and
size to the core kernel via a LINUX_EFI_INITRD_MEDIA_GUID configuration
table, which is allocated from EFI loader data, just like the initrd.
On x86, the stub passes the same information via boot_params as well,
which takes precedence, but the core kernel will fall back to the INITRD
config table if boot_params does not describe an initrd.

The EFI configuration table array is passed on to kexec'd kernels as-is,
and so a kexec'd kernel that is booted without an initrd will pick up
the INITRD config table that was installed during the original boot, and
use the initrd it describes, which no longer exists at that point.

Commit 6e62d1c6f2c7 ("efi: Wipe INITRD config table from memory after
consumption") mitigated this by wiping the base and size fields of the
table once it has been consumed. However, the memory holding the table
is released to the page allocator as well, and so it may have been
reused by the time the kexec occurs, in which case the kexec'd kernel
will interpret whatever happens to be stored there as the base and size
of the initrd, e.g.,

  [    0.000000] efi: ... INITRD=0x7c41cc18 ...
  [    0.000000] RAMDISK: [mem 0x9090909090909090-0xd1e7d1e68aaeafff]
  [    0.000000] Kernel panic - not syncing: Cannot find place for new RAMDISK of size 4708303772963442675

Crash kernels will find the stale table as well, and wipe it again, i.e.,
write to the memory of the crashed kernel that they are supposed to
capture.

Both kexec_file_load() and kexec-tools pass a SETUP_EFI setup_data entry
to the next kernel when EFI is enabled, which the x86 EFI code already
relies on to detect that it was booted via kexec. Such kernels are
entered directly, bypassing the EFI stub, and so any INITRD config table
they encounter is necessarily stale. So wire up
efi_config_table_is_usable() for x86, and use it to disregard the INITRD
config table when a SETUP_EFI setup_data entry is present.

While at it, use the same mechanism to disregard the Memory Attributes
table after kexec, which is currently achieved by overwriting its address
in the firmware's config table array with EFI_INVALID_TABLE_ADDR in
efi_reuse_config(). This only happens on 64-bit firmware, and only if
the SETUP_EFI entry carries the address of an SMBIOS table, which
kexec-tools does not provide on systems that only expose an SMBIOS3
entry point. In that case, the kexec'd kernel will parse the table, which
may be stale as well, given that EDK2 based firmware allocates it from
EFI boot services data, which is released to the page allocator after
boot too, e.g.,

  [    0.000000] efi: memattr: Unexpected EFI Memory Attributes table version -1958647317

Fixes: f4dc7fffa987 ("efi: libstub: unify initrd loading between architectures")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c    | 26 ++++++++++++++++++++++++++
 arch/x86/platform/efi/quirks.c |  4 ----
 include/linux/efi.h            |  3 +++
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 5eb96c17883e..c2817c7415ce 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -432,6 +432,32 @@ static int __init efi_systab_init(unsigned long phys)
 	return 0;
 }
 
+/*
+ * kexec passes the firmware's config table array on to the next kernel as-is,
+ * but some of the tables it describes must be disregarded when booting via
+ * kexec, which is indicated by the presence of a SETUP_EFI setup_data entry:
+ *
+ * - The INITRD table is installed by the EFI stub to describe the initrd that
+ *   it loaded. Both the table and the initrd are allocated from EFI loader
+ *   data, which is released to the page allocator once the kernel is up and
+ *   running, and so the table is stale by the time kexec boots the next kernel.
+ *
+ * - The Memory Attributes table may reside in EFI boot services data, which is
+ *   released to the page allocator as well. Even if it is still intact, the
+ *   sanity check in efi_memattr_init() may fail spuriously, given that only
+ *   the runtime regions of the EFI memory map are passed on via kexec. Applying
+ *   the permissions it describes is not critical, so just ignore it.
+ */
+bool __init x86_efi_config_table_is_usable(const efi_guid_t *guid,
+					   unsigned long table)
+{
+	if (!efi_setup)
+		return true;
+
+	return efi_guidcmp(*guid, LINUX_EFI_INITRD_MEDIA_GUID) &&
+	       efi_guidcmp(*guid, EFI_MEMORY_ATTRIBUTES_TABLE_GUID);
+}
+
 static int __init efi_config_init(const efi_config_table_type_t *arch_tables)
 {
 	void *config_tables;
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 02c56a02eb9b..d6d34dfa19e6 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -611,10 +611,6 @@ int __init efi_reuse_config(u64 tables, int nr_tables)
 		if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID))
 			((efi_config_table_64_t *)p)->table = data->smbios;
 
-		/* Do not bother to play with mem attr table across kexec */
-		if (!efi_guidcmp(guid, EFI_MEMORY_ATTRIBUTES_TABLE_GUID))
-			((efi_config_table_64_t *)p)->table = EFI_INVALID_TABLE_ADDR;
-
 		p += sz;
 	}
 	early_memunmap(tablep, nr_tables * sz);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index cc1df1577d5f..1bdb4639acef 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1355,10 +1355,13 @@ struct linux_efi_initrd {
 #define EFI_SECRET_TABLE_HEADER_GUID	EFI_GUID(0x1e74f542, 0x71dd, 0x4d66,  0x96, 0x3e, 0xef, 0x42, 0x87, 0xff, 0x17, 0x3b)
 
 bool xen_efi_config_table_is_usable(const efi_guid_t *guid, unsigned long table);
+bool x86_efi_config_table_is_usable(const efi_guid_t *guid, unsigned long table);
 
 static __always_inline
 bool efi_config_table_is_usable(const efi_guid_t *guid, unsigned long table)
 {
+	if (IS_ENABLED(CONFIG_X86) && !x86_efi_config_table_is_usable(guid, table))
+		return false;
 	if (!IS_ENABLED(CONFIG_XEN_EFI))
 		return true;
 	return xen_efi_config_table_is_usable(guid, table);
-- 
2.56.1.750.gf70dc682cf-goog

