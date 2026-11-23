Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795436656;
	b=oI2P4EyEi16mCWJZ3ZtmLK/CpICKntKk3D2fBnm4cxic8US3apUY3P3Jz6mE+qCXSiqR
	 PvCawDZQ60VIxn8qkDc6+7cw5liVdrYicTcFKMgvKzSWVVyyVbQThkgsTqt7z4lMD8pvk
	 kfS3NLRFZ1ctm7OTBJV5cAURwPVKoMoXxClQuMDbRcVihJT7T0d1CsOnA8rHbUNLp5cyZ
	 krJbflJoH6GEwM4sjkRc849UWowDmgf1Zq0j5eePnRkyIVGRKh9f5YFb3/i2+J4tnK95J
	 lOL/CASerU851cNkDo8rimry9yib7VyqMCzai1gEPYgJOGr9lxRpysYBR0Bq7Qod5QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795436656;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=vvFYMhcipZRfHLtib7yUjESVcO3O52Y/OdaCRiNT46k=;
	b=g/fMblqWeHSYU0dAgY9BPejOe9riK4hkPLSLDSJXh5toWSTvrntzIJ8M4eP4cBt3MChf
	 FJcbkhn0s/oWcGU9Yp49veefvzh1K4YOuX6Jdxxm1b14tVmTERBgtwipLyY23EMWGViOx
	 Q/CLEQMKBY0r6IsF9Dj+CDjf29AM3IX6hs6W5tKM6CaG5PjKkuMwBbbPEVwixF29UMcZV
	 2RCSfic8xVuoXn0cFApxPsT0ALpy8QlC4NhDkWrV2cKknXScMwAjqVmZCt9vFxrSQz/+T
	 MlD0F7V3p4D9QgYrBDEB73+uLeTgA8hpfgJxuoIJKjVNr/5FqikAV3++JstMzFodXTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=biMgNKNT;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2A3606A31E
	for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 12:24:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF2A3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=biMgNKNT
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a359b714f8so19504165e9.2
        for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 04:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795436654; x=1796041454; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vvFYMhcipZRfHLtib7yUjESVcO3O52Y/OdaCRiNT46k=;
        b=biMgNKNTUUBFU46AoSIrrp3hDdfJCCW7+ml5wp1IjYnZgAOomZyBgdhJ6OQYrnhiqh
         3WOYkJz/7D7fYOsOme1Sxf0cjNujGwLoRXBASNFVQjp3JALSdqz/QKe5b3FRmz+o8qQF
         y/V52hnkfiXcbA4f3fmyPRn/FzujAnQgLSCFFTrQZG8VL0ZrgUBw+9dyLByXFAvuTXfY
         ynbYQONsl3RPZ2op6IvOEH7afXrfJfIJMAnGiwS7Af1q6zjAju7Oh/TSsaG9JzgkyJxe
         Q1yJjy4EKxuPpZdmh+hlYGvKVlZaRk+XjWvG80utK1a+SkIj5RN9qIDBrfCFmEmLXpae
         q/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795436654; x=1796041454;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vvFYMhcipZRfHLtib7yUjESVcO3O52Y/OdaCRiNT46k=;
        b=b7t+pSFNisfWw4yqhALLafSfqKS3P7tEgwMQ61G1IVmIrMWcc8rjvZ9EVSWZufi7SH
         n95Tk2kxNIg0v1TXQVdBvtJGWNwdDFMifr9p12o/rGXSdKAflYvayk8LgYiK8tf86ida
         bHVcxYiUl/cvBfLAlIQmOahwbA94LdIM4ydaoW9IndZnvzdhM6kVTHdsvou/T8U8544Y
         JyrGoNqXiTqocjUUuzTPY5G9qrsuy7nVWnvFDBNtbhJTpJ1DD+sKlujyJ0LAcDxchs0Z
         3LW0cE6/tWVDUP7PsQk3DkUYQlY76UZc592Z4u+RIuzhcvqAgcGWow1wsnz7wySiJkPj
         IKTA==
X-Gm-Message-State: APuU4Z8bqLVJgCY8ZQQQ/UjwUNa8rWGOOR+AMlGQDmBQstjKAW7p8mis
	7QOR2dB0ZCBO4ZnuUWL5uw9J/gigiRhnV8HxLQmkAHFBS2tF/+/h8oMHvwYoRu4PO397zpSpbj6
	/i4CQmYAc8UhI8Zl3SRV242k5xK/lKgltS2DM4aso+mld+suyp5CCcTA0siEHh24tGYqtRLsfdY
	uoOHcWtogjetSdLD5/Q3fb5T364Akl2A==
X-Received: from wmog17.prod.google.com ([2002:a05:600c:3111:b0:4b2:3c81:ca])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3113:b0:4bb:693e:4c8e
 with SMTP id 5b1f17b1804b1-4bb88816a53mr249467885e9.21.1795436653451; Mon, 23
 Nov 2026 04:24:13 -0800 (PST)
Date: Mon, 23 Nov 2026 13:24:10 +0100
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3002; i=ardb@kernel.org;
 h=from:subject; bh=ADX6/7qiHXaaP4T7APWmqHlT/XNvSonvZES5AEK83ig=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZvFIKtyI9PElyrRlhfNdCtybes9ZzfMWPL0TKj/D9N7b
 x6Wr/HuKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPZO4WR4fzpt00f+/w233Lf
 YF/yl8NGZ9Yqwye3Wt81uJ1SzHe4UsrwTy1zYYL0Xu/rNq8zmArj7fw/P+S4vn75zcINHPJH/lR 84wMA
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261123122409.1096621-2-ardb+git@google.com>
Subject: [PATCH] efi: Avoid weak references to arch-specific objects
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

There are two cases where generic EFI code in the kernel proper uses
weak references to refer to data objects that an architecture might not
define at all.

Unlike weak definitions, which guarantee that a definition will
ultimately exist, and where the weak attribute only decides which one
takes precedence, weak references are permitted to remain unsatisfied.
Given that PC relative symbol references in relocatable code cannot
reliably produce NULL, this forces the compiler to use a GOT slot when
the access is from code.

For data references (i.e., statically initialized global pointer
variables), it forces the use of a 24 byte RELA entry rather than a
single RELR bit for similar reasons.

Given that in both cases, only a single architecture does define the
symbols, and this is unlikely to change going forward, just replace the
weak references with Kconfig #ifdefs.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi-init.c | 5 +++--
 drivers/firmware/efi/efi.c      | 8 +++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/efi-init.c b/drivers/firmware/efi/efi-init.c
index 9f09b0d2daa0..58acb5d25adf 100644
--- a/drivers/firmware/efi/efi-init.c
+++ b/drivers/firmware/efi/efi-init.c
@@ -54,7 +54,7 @@ static phys_addr_t __init efi_to_phys(unsigned long addr)
 	return addr;
 }
 
-extern __weak const efi_config_table_type_t efi_arch_tables[];
+extern const efi_config_table_type_t efi_arch_tables[];
 
 /*
  * x86 defines its own instance of sysfb_primary_display and uses
@@ -123,7 +123,8 @@ static int __init uefi_init(u64 efi_system_table)
 		goto out;
 	}
 	retval = efi_config_parse_tables(config_tables, systab->nr_tables,
-					 efi_arch_tables);
+					 IS_ENABLED(CONFIG_ARM) ? efi_arch_tables
+								: NULL);
 
 	early_memunmap(config_tables, table_size);
 out:
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9bc22de0d67e..9d73aa5ebf92 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -157,18 +157,20 @@ static ssize_t fw_platform_size_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%d\n", efi_enabled(EFI_64BIT) ? 64 : 32);
 }
 
-extern __weak const struct kobj_attribute efi_attr_fw_vendor;
-extern __weak const struct kobj_attribute efi_attr_runtime;
-extern __weak const struct kobj_attribute efi_attr_config_table;
+extern const struct kobj_attribute efi_attr_fw_vendor;
+extern const struct kobj_attribute efi_attr_runtime;
+extern const struct kobj_attribute efi_attr_config_table;
 static const struct kobj_attribute efi_attr_fw_platform_size =
 	__KOBJ_ATTR_RO(fw_platform_size);
 
 static const struct attribute *const efi_subsys_attrs[] = {
 	&efi_attr_systab.attr,
 	&efi_attr_fw_platform_size.attr,
+#ifdef CONFIG_X86
 	&efi_attr_fw_vendor.attr,
 	&efi_attr_runtime.attr,
 	&efi_attr_config_table.attr,
+#endif
 	NULL,
 };
 
-- 
2.56.1.750.gf70dc682cf-goog

