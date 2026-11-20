Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795180718;
	b=SZG6AKgLsXCy16yTjmVqYd0huEEIBjoBOMvFretUXhb+zRfztSSXQGefKOKH3eTsUDem
	 jTRmGYlhjjBt1IneaNM+SZbhA/SzRR/CDjupvgq3bHM8XanYKo/b8Wpbplt0nTQNSRYJ5
	 Pi5nZq02P4lNFzgvpXyOPVAMvEyugNb5veV70WRXgHguSLgKPRFqaUZLaFxem4K9SHJZS
	 On6ucmRhFDlsmx1Rl6PPOSQEdhHY+OwvInU5hCN05nFIo84TftkzCM0ogVMLGqibmQFjv
	 iVOSTUYIDmzOZCaYnhnx2WYSD3dLTPYsKuEBoab0DkNvTRDsXhzxwW6x7UAyfXCofSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795180718;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=CxtRBUB9nzgPmsZSG6Nm9chCm2jqQcG/+x7MHTyrCD4=;
	b=fGscojg3Anb39gIAbagOm8RF2AbGJMHtGHSDfRD0+oKk6BynaeHaIYF7IgT0cAy2OSI4
	 fl4S7n1CdpOQvK4F6pYg5JhJQRXS4iTswmj+Rw1nbrPAH6exFwaVCUHOnwNnydx3bvL4L
	 IChF6vctEp3I7GzBF1A/q9AAX2GzeH0nnh1WUX+vFEf6FooufVYzWiF7tZ4EperqLIuxV
	 KVqA5YQ0hKI1qipkEVIcqmCOZlHvmDtSzKyLNu7Eska6D6fUkGg386yCkxYU9mm0SEjmk
	 hLmQcqwfn+DNH2atNfarQajRyRUBovn8Q8PNBUI4E6zmRBqTJ5oprERp0XdHMhBz4OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Cl8/lE33";
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E97606A320
	for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 13:18:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1E97606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Cl8/lE33
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4ba01393800so5739225e9.1
        for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 05:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795180716; x=1795785516; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CxtRBUB9nzgPmsZSG6Nm9chCm2jqQcG/+x7MHTyrCD4=;
        b=Cl8/lE33OOepLMceb+HSoR9/Vqa8tEb2JAuBBOh1bzBTAHkcahKCPqgNa8bgn3RypM
         Zc8mWkV+BOurkDyW8ssLJYvcEv1A1rdzrHEDSkBkzUiAYygSTu9z2AcD98ZJzwWGNFfi
         bV3GoG2WIWEwlL2mwzP94SUUpFuY5Zl1qZiby1UaBHO87z3jDrpqOU5fMiCXchXqtctu
         32SKC102sm4aBXzxRGkxmVHyR5qsky199VXB5EfS5uwxD09SECjGj7yX1FdkuL23M53u
         Ki0Ab1bENl8zsWjnGeHYUB2C4l3AyBlBb/yyrw6EEgaf2mk96LJCQiYLBgBBn78yr8EU
         z8Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795180716; x=1795785516;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CxtRBUB9nzgPmsZSG6Nm9chCm2jqQcG/+x7MHTyrCD4=;
        b=pJZ2pvf4ndzIAEXARbKuZrM3GGvfiC4qkpyh63/31t4J0bQA0rKCOhG4jSq/kcLrSw
         j6gmpD66OaZg2N1bqQVJI6VNRury+BLsNZloUk3ZX3M2ZvryLZYA7ceXsQUQatwZL8g4
         Y7bAe19mphTKudSslb2xMK2D96gaOpQ9QQyVNwl++CV9hnKYoaZe5+5x7i7zvvha0arr
         ZZw3U50J/vBXwPSu7MqpGEoKX6dfdoTuucmyxliKTJ9Ous0uN/z7KE7xi58AGtF3iiRS
         NyII/ObSdc5iAFGznXgto7/EcQxjLTy5ilF1DhhwQbZNQDwrXYx1WeI3KqAtQ0y0nXH2
         AzfA==
X-Gm-Message-State: APuU4Z9wVa+q9UwIp92Rimzh9XB7cMDoRERuROF8C6E+fg0kpc7+XpYo
	4/bjprIwuuNJh6b6NFCZgjKydG6l+x+fuC8PSOvOHRVKVJHUl1PzlnnZLL7BhEdSJ+H7pZNKR7d
	bQc6jM2/kNbV55oJ+n8FB4pbnEoA/kgniVso+Z/SrSTNgfn/n7oBvf40cJvv9i48BWuJhTAYqdu
	pI+KvOgRHXW7AHc0IPzXh1dgmCnrQqAQ==
X-Received: from wmla23.prod.google.com ([2002:a05:600d:2397:b0:4a2:1459:4ee8])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3113:b0:4bb:693e:4c8e
 with SMTP id 5b1f17b1804b1-4bb88816a53mr70018765e9.21.1795180716014; Fri, 20
 Nov 2026 05:18:36 -0800 (PST)
Date: Fri, 20 Nov 2026 14:18:30 +0100
In-Reply-To: <20261120131827.480055-4-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261120131827.480055-4-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4558; i=ardb@kernel.org;
 h=from:subject; bh=8fkvQC0HFYb0dM7SaNPDfEDbZeSoQ3GOviNL8OcV9zs=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZvBY1nKx8qtJ/49Wlxl/0vk1tTMtMNijNXmnDst/4prT
 ajaMEm3o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzkkDIjw4s1SjVrXgcc/fvW
 cuYsn6fFJw2VffKUhE3zVrRdaP6adoGR4U38F76ojXuSHqpObhVze624duJxs8SAG+3S7k6PlqX K8QEA
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261120131827.480055-6-ardb+git@google.com>
Subject: [PATCH 2/2] efi: pstore: Convert into a platform driver for 'efivars'
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

efi-pstore already carries MODULE_ALIAS("platform:efivars") to match the
"efivars" platform device registered by efisubsys_init(), but never
registered an actual platform_driver for it.

Convert efi-pstore into a proper platform_driver, and only register the
"efivars" platform device when EFI_RT_SUPPORTED_SET_VARIABLE is
advertised so udev does not auto-load efi-pstore on platforms with
read-only runtime variable services.

When pstore_disable is set (via CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
or efi_pstore.pstore_disable=Y), skip the initial automatic probe while
keeping the platform driver registered. This allows userspace to enable
or disable efi-pstore at runtime without rebooting via the standard
driver model sysfs interface:

  echo efivars.0 > /sys/bus/platform/drivers/efi-pstore/bind
  echo efivars.0 > /sys/bus/platform/drivers/efi-pstore/unbind

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi-pstore.c | 51 ++++++++++++++++----
 drivers/firmware/efi/efi.c        |  3 +-
 2 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 19a7e4fe5b52..44571fa1dd88 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0+
 
 #include <linux/efi.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/pstore.h>
 #include <linux/slab.h>
 #include <linux/ucs2_string.h>
@@ -21,6 +23,7 @@ MODULE_PARM_DESC(record_size, "size of each pstore UEFI var (in bytes, min/defau
 
 static bool efivars_pstore_disable =
 	IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
+static bool efivars_pstore_autoprobe_disable;
 
 module_param_named(pstore_disable, efivars_pstore_disable, bool, 0444);
 
@@ -228,13 +231,17 @@ static struct pstore_info efi_pstore_info = {
 	.erase		= efi_pstore_erase,
 };
 
-static __init int efivars_pstore_init(void)
+static int efi_pstore_probe(struct platform_device *pdev)
 {
+	int ret;
+
 	if (!efivar_supports_writes())
-		return 0;
+		return -ENODEV;
 
-	if (efivars_pstore_disable)
-		return 0;
+	if (efivars_pstore_autoprobe_disable) {
+		efivars_pstore_autoprobe_disable = false;
+		return -ENODEV;
+	}
 
 	/*
 	 * Notice that 1024 is the minimum here to prevent issues with
@@ -251,29 +258,53 @@ static __init int efivars_pstore_init(void)
 
 	efi_pstore_info.bufsize = record_size;
 
-	if (pstore_register(&efi_pstore_info)) {
+	ret = pstore_register(&efi_pstore_info);
+	if (ret) {
 		kfree(efi_pstore_info.buf);
 		efi_pstore_info.buf = NULL;
 		efi_pstore_info.bufsize = 0;
+		return ret;
 	}
 
 	return 0;
 }
 
-static __exit void efivars_pstore_exit(void)
+static void efi_pstore_remove(struct platform_device *pdev)
 {
-	if (!efi_pstore_info.bufsize)
-		return;
-
 	pstore_unregister(&efi_pstore_info);
 	kfree(efi_pstore_info.buf);
 	efi_pstore_info.buf = NULL;
 	efi_pstore_info.bufsize = 0;
 }
 
+static const struct platform_device_id efi_pstore_ids[] = {
+	{ "efivars", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, efi_pstore_ids);
+
+static struct platform_driver efi_pstore_driver = {
+	.probe		= efi_pstore_probe,
+	.remove		= efi_pstore_remove,
+	.id_table	= efi_pstore_ids,
+	.driver		= {
+		.name	= "efi-pstore",
+	},
+};
+
+static __init int efivars_pstore_init(void)
+{
+	efivars_pstore_autoprobe_disable = efivars_pstore_disable;
+	return platform_driver_register(&efi_pstore_driver);
+}
+
+static __exit void efivars_pstore_exit(void)
+{
+	platform_driver_unregister(&efi_pstore_driver);
+}
+
 module_init(efivars_pstore_init);
 module_exit(efivars_pstore_exit);
 
 MODULE_DESCRIPTION("EFI variable backend for pstore");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:efivars");
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9bc22de0d67e..e98436a9bb9b 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -483,7 +483,8 @@ static int __init efisubsys_init(void)
 		error = efivar_ssdt_load();
 		if (error)
 			pr_err("efi: failed to load SSDT, error %d.\n", error);
-		platform_device_register_simple("efivars", 0, NULL, 0);
+		if (efi_rt_services_supported(EFI_RT_SUPPORTED_SET_VARIABLE))
+			platform_device_register_simple("efivars", 0, NULL, 0);
 	}
 
 	BLOCKING_INIT_NOTIFIER_HEAD(&efivar_ops_nh);
-- 
2.56.1.750.gf70dc682cf-goog

