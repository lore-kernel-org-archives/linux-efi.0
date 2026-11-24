Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541882;
	b=RG4AC0vWy0xi1lbEsiOE7V0md4iQfW1qB72ZU00gEQfOy+h6oCfsSMyNQTAm28/PaWp8
	 8ZDdzJxp8+YkV4ncyGQntoBI+AEe+sNXztpVh2OejO4yUwZXh6hnbJR8nMisDd43wRveb
	 XE8XjopJdNPKKvENhl+8F7vhwFi1YVzOmC8UxicuOiOJRZo6iaiaLLrI+Mcjd6o0OCyPB
	 Ma2vyVtMIaOyLUTcbKzmxdmLCooyzUIUsdr3zy+rQHWqxK/5smkudCYKXknLT3m8xKGB5
	 h8Z9XcNHZNJ10Kre7OlI8S//QDxSEgXD0pX2+cZ/ckmvF/3gF4AVz+0cYqO2ISME+HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541882;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=ypusVVpmU/3rJRrKHlkHfAY/w6hRmv149yPNDnUar5c=;
	b=2rtB6eZ+b6MKr3mBilsa90EK3M/Ave3YpIPgCqHzq90ujqi+VLOS2chndtKjIpmFIZxa
	 ubFhjWXGReFJHo51Vphv9mSU8/0EEIEy7I3wmhzYY0XEt1oAkmwyZX88yk27Y45AdLiEx
	 XqAah8TPnpJVTCiTQCZz5dzHkTVASVQ0ii8YFG1Ov04+1jEUceN4O2ETn6X1PJKqGLmsw
	 5wATAe3ans/8e9JudpZYA7P9W74tIUtNyDlXEDn8PaWqjnMEGZ1XGNQUfE12bBIeoAcp6
	 nClLPxdsv07zObUGADUdZO16hlje50Psq8Wlv1bfdlvN4fXUP8i7dazJqG7CWxQ/+ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Vy+vWIzA;
	arc=none smtp.remote-ip=209.85.221.72
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D37606A31E
	for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 17:38:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56D37606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Vy+vWIzA
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-49034831bb3so2971394f8f.1
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 09:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795541881; x=1796146681; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ypusVVpmU/3rJRrKHlkHfAY/w6hRmv149yPNDnUar5c=;
        b=Vy+vWIzARzdM1L0MEV1erqkcXbgsoceY97Gm7yRL6WbybnuRhWfU0WIZt/Q6oe9Ddy
         KFOKHtG1g2Uhob/YbVntDw5YDI4vFlenFPmcb2++7CITRVo+EaK0U9EALcY7evJGmETt
         CJPsaW/9uM6MbkjsXF2hM9UL6eRijrkMW2Vu/e6qYpVSZxewucdrKmlfXuhUXZ/U4OX6
         g0R0+eqQZO/VfRUilprUpyqwUzxLV/EZ5/2S6mjAMQkPltPovOmFUZS30wCEwOGAwBKo
         35Yzv7MPvou7Py22BUxxNGoFqTO4aqW/+inqkv7vdA097XanLsfYNST6Nww2BUKw8vGS
         u6sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795541881; x=1796146681;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ypusVVpmU/3rJRrKHlkHfAY/w6hRmv149yPNDnUar5c=;
        b=Z9J1DDcwkyCnS28AzF+UF5Lw4u2mVxWR59ktPmvNcYp7RUpMZLFkfGeXNl1aUW9Auo
         6M7hPjzuZZQTFWu47Vpo0L069ltSmsntFpkbZg9/uP+Ydq4mU5tVcxry/HHRui8NvNIf
         3LQpxI04Ibc/G9tSnnGIkxT2FBN0RMTIE8ecZbfzEmskoABrcx6t2eV4XImAwhkNvTLC
         mc05b+B2HzPigrWqYj78ZySqzkLKO3UsgPFYe/enWUEIvOksflElec5hlGydw1c1TP9c
         VHttnZZuK8rO9aBN/g3kr4vx4eAWvvCZtCdm3ezQq5aCIPoBdl9X3EWnwKXOoOp2ujwc
         aZ2A==
X-Gm-Message-State: APuU4Z81Hhv8FD0ZINp92+iUYneT3kFRXj3Eso1DgFpAN+kh6P7UwR3d
	2iQw9pRxbNUpFz8qWtJJ6Hfyua/fkki7S8lENW2zxzHNF5/txnlH55o4nKseXrc5gVSn0JTGYFO
	Lwo1RhPYrLR15O3Q5i4bcHb6CeRyqQnwccDZYGp0T8IKetSOJvqS0+z9bZLQ8lUROpTxsGX5xVH
	k92HFhB3xJAKoWOoS/i+3mJsJ8V9sdPg==
X-Received: from wrxm14.prod.google.com ([2002:a05:6000:8e:b0:48e:2686:9fd1])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4812:b0:4a7:b8ab:df86
 with SMTP id ffacd0b85a97d-4abb5db73bcmr27812400f8f.38.1795541880062; Tue, 24
 Nov 2026 09:38:00 -0800 (PST)
Date: Tue, 24 Nov 2026 18:28:15 +0100
In-Reply-To: <20261124172811.2580784-7-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261124172811.2580784-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=9086; i=ardb@kernel.org;
 h=from:subject; bh=HWeNb4qVpapqGTO4mF9cB4F/+iu1wgw4/DdP6QHOeWc=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZv1pPGSzYZhq9ocI56HlDOd/Hndf2/Gaynnrrl8z2d/b
 vvxzVupo5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEykyIiR4fmBq3dOa8Xviauz
 j00wnqezm/m+6hd9VuPinl1F/akSPxn+yhRLu87yv9Wof65nU0YAc9zPND9BUdcwXjF+93kc9+7 wAAA=
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261124172811.2580784-12-ardb+git@google.com>
Subject: [PATCH v2 5/5] efi: pstore: Convert into a platform driver for 'efivars'
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>, 
	"=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=" <u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

efi-pstore already carries MODULE_ALIAS("platform:efivars") to match the
"efivars" platform device, but never registered an actual platform_driver
for it. As a result, it stays registered with pstore even after the
"efivars" device goes away, e.g., when tee_stmm_efi replaces the generic
efivars ops.

Convert efi-pstore into a proper platform_driver, so that its pstore
backend lifetime follows that of the "efivars" device. The EFI core
registers that device only while the generic, EFI runtime services based
efivars ops are in use and support SetVariable().

efi_pstore_info is a singleton, so only bind to the device named
"efivars" that carries struct efivars_pdev_data. This rejects devices
whose driver_override has been set to "efi-pstore" via sysfs: binding to
one of those would race with the "efivars" device under a different
device_lock and clobber efi_pstore_info.buf while it is registered.

When pstore_disable is set (via CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
or efi_pstore.pstore_disable=Y), refuse the probes that the driver core
performs automatically during platform_driver_register() and during
registration of the "efivars" device, while keeping the driver
registered. Each window is tracked by a flag: a module-local one for
driver registration, and efivars_pdev_data::registering, which the EFI
core sets while registering the device. With PROBE_FORCE_SYNCHRONOUS,
the automatic probes complete within these windows. This lets userspace
enable or disable efi-pstore at runtime without rebooting, via the
standard driver model sysfs interface:

  echo efivars.0 > /sys/bus/platform/drivers/efi-pstore/bind
  echo efivars.0 > /sys/bus/platform/drivers/efi-pstore/unbind

An explicit bind that races with either registration window is refused.
A manual binding does not carry over if the "efivars" device is
re-registered, e.g., when tee_stmm_efi is unbound and the generic ops are
restored; the new device is again subject to pstore_disable.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi-pstore.c | 87 +++++++++++++++++---
 drivers/firmware/efi/efi.c        | 25 ++++--
 include/linux/efi.h               | 11 +++
 3 files changed, 107 insertions(+), 16 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 19a7e4fe5b52..93c5e18f33b5 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -2,8 +2,10 @@
 
 #include <linux/efi.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/pstore.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/ucs2_string.h>
 
 MODULE_IMPORT_NS("EFIVAR");
@@ -21,6 +23,7 @@ MODULE_PARM_DESC(record_size, "size of each pstore UEFI var (in bytes, min/defau
 
 static bool efivars_pstore_disable =
 	IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
+static bool efi_pstore_driver_registering;
 
 module_param_named(pstore_disable, efivars_pstore_disable, bool, 0444);
 
@@ -228,13 +231,42 @@ static struct pstore_info efi_pstore_info = {
 	.erase		= efi_pstore_erase,
 };
 
-static __init int efivars_pstore_init(void)
+static int efi_pstore_probe(struct platform_device *pdev)
 {
+	const struct efivars_pdev_data *pdata = dev_get_platdata(&pdev->dev);
+	int ret;
+
+	/*
+	 * efi_pstore_info is a singleton, so only bind to the "efivars" device
+	 * registered by the EFI core, of which at most one exists at any given
+	 * time, and whose probe and remove are serialized by its device_lock.
+	 * This also rejects other devices whose driver_override was set to
+	 * "efi-pstore" via sysfs, which platform_match() honours before
+	 * consulting the id table.
+	 */
+	if (!pdata || strcmp(pdev->name, EFIVARS_PDEV_NAME))
+		return -ENODEV;
+
 	if (!efivar_supports_writes())
-		return 0;
+		return -ENODEV;
 
-	if (efivars_pstore_disable)
-		return 0;
+	/*
+	 * If efi-pstore is disabled, only permit binding it explicitly via
+	 * sysfs, by refusing the probes that the driver core performs
+	 * automatically when the driver or the "efivars" device is
+	 * registered. As the driver uses PROBE_FORCE_SYNCHRONOUS, such probes
+	 * always complete before platform_driver_register() or
+	 * platform_device_register_data() return, and therefore before the
+	 * respective flag is cleared again. (This also means that an explicit
+	 * bind that races with either registration is refused.)
+	 *
+	 * The flags may be cleared concurrently by another CPU, without
+	 * holding this device's device_lock, hence the READ_ONCE()s.
+	 */
+	if (efivars_pstore_disable &&
+	    (READ_ONCE(efi_pstore_driver_registering) ||
+	     READ_ONCE(pdata->registering)))
+		return -ENODEV;
 
 	/*
 	 * Notice that 1024 is the minimum here to prevent issues with
@@ -251,29 +283,62 @@ static __init int efivars_pstore_init(void)
 
 	efi_pstore_info.bufsize = record_size;
 
-	if (pstore_register(&efi_pstore_info)) {
+	ret = pstore_register(&efi_pstore_info);
+	if (ret) {
 		kfree(efi_pstore_info.buf);
 		efi_pstore_info.buf = NULL;
 		efi_pstore_info.bufsize = 0;
 	}
 
-	return 0;
+	return ret;
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
+	{ .name = EFIVARS_PDEV_NAME, },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, efi_pstore_ids);
+
+static struct platform_driver efi_pstore_driver = {
+	.probe		= efi_pstore_probe,
+	.remove		= efi_pstore_remove,
+	.id_table	= efi_pstore_ids,
+	.driver		= {
+		.name		= "efi-pstore",
+		.probe_type	= PROBE_FORCE_SYNCHRONOUS,
+	},
+};
+
+static __init int efivars_pstore_init(void)
+{
+	int ret;
+
+	/*
+	 * efi_pstore_driver becomes visible on the platform bus and in sysfs
+	 * before platform_driver_register() returns, so a concurrent probe on
+	 * another CPU may read the flag while it is being cleared.
+	 */
+	WRITE_ONCE(efi_pstore_driver_registering, true);
+	ret = platform_driver_register(&efi_pstore_driver);
+	WRITE_ONCE(efi_pstore_driver_registering, false);
+	return ret;
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
index a9508595740b..5b47e3073256 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -226,6 +226,8 @@ static bool generic_ops_supported(void)
 
 static int generic_ops_register(void)
 {
+	struct efivars_pdev_data pdata = { .registering = true };
+	struct efivars_pdev_data *pdev_data;
 	struct platform_device *pdev;
 	int ret;
 
@@ -251,14 +253,27 @@ static int generic_ops_register(void)
 	/*
 	 * Register the platform device only after efivars_register() has
 	 * returned, so that a consumer probing synchronously from
-	 * platform_device_register_simple() can take efivars_lock.
+	 * platform_device_register_data() can take efivars_lock.
 	 */
-	pdev = platform_device_register_simple("efivars", 0, NULL, 0);
-	if (IS_ERR(pdev))
+	pdev = platform_device_register_data(NULL, EFIVARS_PDEV_NAME, 0,
+					     &pdata, sizeof(pdata));
+	if (IS_ERR(pdev)) {
 		pr_warn("efi: failed to register efivars platform device: %pe\n",
 			pdev);
-	else
-		efivars_pdev = pdev;
+		return 0;
+	}
+
+	/*
+	 * Any probe performed automatically by the driver core as part of
+	 * registering the device has completed by now (for drivers that
+	 * probe synchronously). Clear the flag so that consumers can tell
+	 * such probes apart from later ones, e.g., explicit binds via sysfs.
+	 * The device is already visible in sysfs, so a concurrent probe on
+	 * another CPU may read the flag without serialization.
+	 */
+	pdev_data = dev_get_platdata(&pdev->dev);
+	WRITE_ONCE(pdev_data->registering, false);
+	efivars_pdev = pdev;
 
 	return 0;
 }
diff --git a/include/linux/efi.h b/include/linux/efi.h
index cc1df1577d5f..c58ff1c1e206 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1069,6 +1069,17 @@ struct efivars {
 	const struct efivar_operations *ops;
 };
 
+/*
+ * The "efivars" platform device is registered while the generic, EFI runtime
+ * services based efivars ops are registered and support SetVariable().
+ */
+#define EFIVARS_PDEV_NAME	"efivars"
+
+struct efivars_pdev_data {
+	/* true only while platform_device_register_data() is in progress */
+	bool registering;
+};
+
 #ifdef CONFIG_X86
 u64 __attribute_const__ efivar_reserved_space(void);
 #else
-- 
2.56.1.831.g720f3f5937-goog

