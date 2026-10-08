Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCF03BE165
	for <linux-efi@vger.kernel.org>; Thu,  8 Oct 2026 08:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791447208; cv=none; b=ZbdUHQBZIn1NQa5Z1XlTd5oxZ+EHn4kXS+fHOHFn+gFSTaqms9vN3BdiLm+UI+xKQpW2agsoRWIa8LtghnODGxcubeqg4UQAc00VevkwfEDbSsm1almqUPBzGiD1M578TmW3uWN32EpqWDeKtMRXJBPpv+7fqay91nBIcx3cXvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791447208; c=relaxed/simple;
	bh=T3SS59beZ6pbjrZz8fc/YZ1KYEIgWyFEBGfcKhtRkk0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rNndwzA8E4dnvwAc/A1vUpnyt3hwKouTksbQDmXYydgcWjb0Yq8bx4qt5x+zsUC2w1Uc8jrpxD4lHet+t1CWBRNQNhomFV4taFnvO0yrUwP10Sja4Fc9P51+49zxLxBzcyQLy5Qb/9GiGALPCKfIPrN4Pdgvr9s7HCnqq4a4xLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s+9Md9X8; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s+9Md9X8"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a16faefac0so28961525e9.0
        for <linux-efi@vger.kernel.org>; Thu, 08 Oct 2026 01:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791447205; x=1792052005; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6QnaHjobrjbgCGcInm2hAbotWL+igzdI8B+gwpDVujE=;
        b=s+9Md9X8/nlwbwVpFGvLq0ZYsKCeJmpipfuTjipemSZ5AYUIjEvt8ufBXOj51waSTT
         ct2zlN+pYq45hzGZP3fqU+IbhKWRqc1EG4rg7J4h1UGRMeD0sfpFSbCGawNYDNZeJn6X
         FyOUYSKIbCqNvlHVgpsnUtaPSBJyQF5X4QVFAHugJKgnmqUXn9ET9LHj5OFsDjgVH51b
         rhnd5qdkZQBgR3S3c8Cy5Nyd1D+Bblai5iqzPd5RxZDllys8yd/cx8gJRm1YGFoddhWy
         qn15w5t2lNBLO2LlNlfzX3T4ogq6QJAPtd4sik9zFLhqJh1Volk5+Al47Xxv4YvjPVaQ
         jbIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791447205; x=1792052005;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6QnaHjobrjbgCGcInm2hAbotWL+igzdI8B+gwpDVujE=;
        b=1WDlpe4LOkWmM7vvwrhlyioXeUGwAzgOmzovI6OR30gLpTrIrIRNi0o7yKnal3GxdC
         6LPV0MBuWFudM9hx3MNNqTPqxXMz+v/r84cgUVui6spoUH+ZE53Rf8bN1H8VOjhjQjzK
         X8ebU1sK1RCgzeLmLOGZPYXwr8mPgivbOOkB8Ic/WdMhECl7M1pjX0fC3R3etFEF9xbW
         x7bPEIVd2SohWKvxN4F9F5RTDQAxVs/B3QwAWpT48C39rxG08mxk9dKW+lgUKhy32A5U
         K+ZeWeA1I9LCfjMzBCCSdI1626oGALbnbA/csgdpQN797PRVQbrxCho8DqXw0HqRjGok
         WBFQ==
X-Gm-Message-State: AFuF++lAjMFbFQbzof9GPvvPoYpzcgrN90d/f0vBZAyAcv93tOIeV8uL
	ucDt+DMzjVh2v2Fm2zB7ZlDotMeccK/rhj5bXSy2vb3otHa+7NE9i3BOi1mPJL0uab3lqwaRFPi
	bzhtiQKcxa9vJ4gWm2ITXb5y/nvaYd1eeoCUnTJ46eGLZGwjcBx7uTAuudohTfDLUeFpMMbCUdG
	q1dtpk5dMWF9i62XYHDMAfS93e/OrGyA==
X-Received: from wmpj35.prod.google.com ([2002:a05:600c:48a3:b0:4a1:7ed9:2608])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c0dc:b0:4a0:2375:dc1a
 with SMTP id 5b1f17b1804b1-4a18043bc32mr60025935e9.21.1791447204560; Thu, 08
 Oct 2026 01:13:24 -0700 (PDT)
Date: Thu,  8 Oct 2026 10:13:19 +0200
In-Reply-To: <20261008081317.2602565-4-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261008081317.2602565-4-ardb+git@google.com>
X-Mailer: git-send-email 2.56.0.360.g66cac248cb-goog
Message-ID: <20261008081317.2602565-5-ardb+git@google.com>
Subject: [PATCH v2 1/2] efi: Constify sysfs attributes
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	"=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?=" <linux@weissschuh.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Ard Biesheuvel <ardb@kernel.org>

Implement Thomas's suggestions to constify sysfs kobject attributes.

Cc: Thomas Wei=C3=9Fschuh <linux@weissschuh.net>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c | 11 +++---
 drivers/firmware/efi/efi.c  | 36 +++++++++++---------
 include/linux/efi.h         |  3 +-
 3 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0c39adb96b91..d8fe93770c2a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -891,7 +891,7 @@ bool efi_is_table_address(unsigned long phys_addr)
=20
 #define EFI_ATTR_SHOW(name) \
 static ssize_t name##_show(struct kobject *kobj, \
-				struct kobj_attribute *attr, char *buf) \
+			   const struct kobj_attribute *attr, char *buf) \
 { \
 	return sprintf(buf, "0x%lx\n", EFI_FIELD(name)); \
 }
@@ -900,11 +900,12 @@ EFI_ATTR_SHOW(fw_vendor);
 EFI_ATTR_SHOW(runtime);
 EFI_ATTR_SHOW(config_table);
=20
-struct kobj_attribute efi_attr_fw_vendor =3D __ATTR_RO(fw_vendor);
-struct kobj_attribute efi_attr_runtime =3D __ATTR_RO(runtime);
-struct kobj_attribute efi_attr_config_table =3D __ATTR_RO(config_table);
+const struct kobj_attribute efi_attr_fw_vendor =3D __KOBJ_ATTR_RO(fw_vendo=
r);
+const struct kobj_attribute efi_attr_runtime =3D __KOBJ_ATTR_RO(runtime);
+const struct kobj_attribute efi_attr_config_table =3D __KOBJ_ATTR_RO(confi=
g_table);
=20
-umode_t efi_attr_is_visible(struct kobject *kobj, struct attribute *attr, =
int n)
+umode_t efi_attr_is_visible(struct kobject *kobj, const struct attribute *=
attr,
+			    int n)
 {
 	if (attr =3D=3D &efi_attr_fw_vendor.attr) {
 		if (efi_enabled(EFI_PARAVIRT) ||
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index e08ce813a3d4..8026264d4990 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -131,7 +131,7 @@ struct kobject *efi_kobj;
  * one value per file rule!
  */
 static ssize_t systab_show(struct kobject *kobj,
-			   struct kobj_attribute *attr, char *buf)
+			   const struct kobj_attribute *attr, char *buf)
 {
 	char *str =3D buf;
=20
@@ -155,21 +155,21 @@ static ssize_t systab_show(struct kobject *kobj,
 	return str - buf;
 }
=20
-static struct kobj_attribute efi_attr_systab =3D __ATTR_RO_MODE(systab, 04=
00);
+static const struct kobj_attribute efi_attr_systab =3D __KOBJ_ATTR_RO_MODE=
(systab, 0400);
=20
 static ssize_t fw_platform_size_show(struct kobject *kobj,
-				     struct kobj_attribute *attr, char *buf)
+				     const struct kobj_attribute *attr, char *buf)
 {
 	return sprintf(buf, "%d\n", efi_enabled(EFI_64BIT) ? 64 : 32);
 }
=20
-extern __weak struct kobj_attribute efi_attr_fw_vendor;
-extern __weak struct kobj_attribute efi_attr_runtime;
-extern __weak struct kobj_attribute efi_attr_config_table;
-static struct kobj_attribute efi_attr_fw_platform_size =3D
-	__ATTR_RO(fw_platform_size);
+extern __weak const struct kobj_attribute efi_attr_fw_vendor;
+extern __weak const struct kobj_attribute efi_attr_runtime;
+extern __weak const struct kobj_attribute efi_attr_config_table;
+static const struct kobj_attribute efi_attr_fw_platform_size =3D
+	__KOBJ_ATTR_RO(fw_platform_size);
=20
-static struct attribute *efi_subsys_attrs[] =3D {
+static const struct attribute *const efi_subsys_attrs[] =3D {
 	&efi_attr_systab.attr,
 	&efi_attr_fw_platform_size.attr,
 	&efi_attr_fw_vendor.attr,
@@ -178,15 +178,16 @@ static struct attribute *efi_subsys_attrs[] =3D {
 	NULL,
 };
=20
-umode_t __weak efi_attr_is_visible(struct kobject *kobj, struct attribute =
*attr,
+umode_t __weak efi_attr_is_visible(struct kobject *kobj,
+				   const struct attribute *attr,
 				   int n)
 {
 	return attr->mode;
 }
=20
 static const struct attribute_group efi_subsys_attr_group =3D {
-	.attrs =3D efi_subsys_attrs,
-	.is_visible =3D efi_attr_is_visible,
+	.attrs_const =3D efi_subsys_attrs,
+	.is_visible_const =3D efi_attr_is_visible,
 };
=20
 struct blocking_notifier_head efivar_ops_nh;
@@ -401,12 +402,15 @@ static void __init efi_debugfs_init(void)
 static inline void efi_debugfs_init(void) {}
 #endif
=20
-static ssize_t efi_runtime_show(struct kobject *kobj, struct kobj_attribut=
e *attr, char *buf)
+static ssize_t efi_runtime_show(struct kobject *kobj,
+				const struct kobj_attribute *attr,
+				char *buf)
 {
 	return sprintf(buf, "%d\n", efi_enabled(EFI_RUNTIME_SERVICES));
 }
=20
-static ssize_t efi_runtime_store(struct kobject *kobj, struct kobj_attribu=
te *attr,
+static ssize_t efi_runtime_store(struct kobject *kobj,
+				 const struct kobj_attribute *attr,
 				 const char *buf, size_t count)
 {
 	int ret;
@@ -424,8 +428,8 @@ static ssize_t efi_runtime_store(struct kobject *kobj, =
struct kobj_attribute *at
 	return count;
 }
=20
-static struct kobj_attribute efi_runtime_attr =3D
-	__ATTR(runtime_enable, 0644, efi_runtime_show, efi_runtime_store);
+static const struct kobj_attribute efi_runtime_attr =3D
+	__KOBJ_ATTR(runtime_enable, 0644, efi_runtime_show, efi_runtime_store);
=20
 static int __init efipostcore_init(void)
 {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ecb34be37a87..fda81d7c4850 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1353,7 +1353,8 @@ bool efi_config_table_is_usable(const efi_guid_t *gui=
d, unsigned long table)
 	return xen_efi_config_table_is_usable(guid, table);
 }
=20
-umode_t efi_attr_is_visible(struct kobject *kobj, struct attribute *attr, =
int n);
+umode_t efi_attr_is_visible(struct kobject *kobj, const struct attribute *=
attr,
+			    int n);
=20
 int ovmf_log_probe(unsigned long ovmf_debug_log_table);
=20
--=20
2.56.0.360.g66cac248cb-goog

