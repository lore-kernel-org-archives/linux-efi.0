Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7B73B0AD0
	for <linux-efi@vger.kernel.org>; Wed,  7 Oct 2026 15:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791388319; cv=none; b=JtpeKx14K83p94msklIiezorvpluvny7InQWXsuQl5NQ6i8n/8CNcl6Ajug19eNO0CPPS85uWCYp7x4MzG+h6UqzEnpn3SWfxMuSkFxNH6cFbctUSHRPHLS1B3TdddSlatHIW0ZcimWiI/IMK6fSg57jBvEuao+eO3Mp1oDAI8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791388319; c=relaxed/simple;
	bh=0QvwrHmtY1bT7Sj4nc5v0Fr/Uwi/3NWgcRb8TqGS9xI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LDplHBE/Rn/iAqR/TgA5q9w9jKF5M7UbmDhfiNuBOnwV4qs9oA+aeWT3gcPw5UDbTjvNcYD0XemFFD/ShFljiL55+ROBVHM1bU4JVx3eZC0eDYVnJug92slGKWqmDcq8LW2i+LqeokJORcMrMaPUJoosGLarz8HDsG7i4N6Uvz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=omQ6XJEo; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="omQ6XJEo"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a16dc2323cso32570515e9.3
        for <linux-efi@vger.kernel.org>; Wed, 07 Oct 2026 08:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791388316; x=1791993116; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/VN6OColaIjJBJsVDlcT5thoRApK+kp/gfO0shyen4Y=;
        b=omQ6XJEo9vpP1uwM8rP/W5dnU4yGReyOcXXJ1PrIjvfJGFFUGuFdtlC8iPUxTcJa19
         qt9Rq64uG7zGFU2vgPF6r8bBYdwZpb3nRyTWfqKvw3SzyeVIZdyEPD2DdxaUSOu6HG/Z
         DfRFIEWGgV3fi4TpVmC6yFYelawB0uFOXdydljyV6q9J0gJL9nU8677E1bjmkI3tiYOa
         2csB+i/A9iiZi7XyZYasvDmADa3YLEt77zPH4YM7w2qLp92rHWOSp60URQngBrVD1wZN
         IB954kw++hrzECqN+yJtMoZHqiiQtgslWfczckwhSrONywh3/LM8O87bdycBJ3HCI1rH
         fVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791388316; x=1791993116;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/VN6OColaIjJBJsVDlcT5thoRApK+kp/gfO0shyen4Y=;
        b=XxqzvCf9IMjoL7tCDsUrnFJYKqx7kl7aXVNJjwgIL2+3DdP53yUPomfHFGLrrGBHB1
         UJtF5BmiH0UY/WZj4NzbmsjnQ57Udg0ZJUEmmvlGnpt2ir5YMgzPfwosJJhrsO+irVZE
         XT9cXv8i/zXDozXba8Ai5LqT+j1iic/av7G4cqwD+8uMz6SD/TV8DbKr+MeTVv4PB5Rk
         eYKzgvd2Cvv7Y+YKdPPYzMOLBAamRJwbAZ9Aaqcw4h4nDyBTfTRVVFJBq6qDyf+ygFf2
         puICmepaFl+BrULbYMQzVIH7GE/cTfSDp1xCta7ldodTFwLhwzbxeX2ytYS/1/VCxHz9
         WOJw==
X-Gm-Message-State: AFuF++mpjyImsu5jiekb0aLx5aP2X1qM0sS28sNBUCi0Hrz3v+0dlIhQ
	WPfKVU45m4k/T94Hjptxjq/sDh2eY8BwVsIQaol4mS9s7XDL84Bwh+e69DM3WuuBmAgC0/jG5Fq
	IVOEh6/nfOIH7oxlvVsETfqK8bYNct7iZBJnRlf1qUZnPwGNYFgYLx51wshqkFMAT7TKTE4Rj/z
	3J91O1EuLstuz6sukFle6Ra8BgUqmtyg==
X-Received: from wmpl35.prod.google.com ([2002:a05:600c:8a3:b0:4a1:7a28:e547])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b99:b0:4a0:1c10:1372
 with SMTP id 5b1f17b1804b1-4a1806501eamr54767885e9.27.1791388314433; Wed, 07
 Oct 2026 08:51:54 -0700 (PDT)
Date: Wed,  7 Oct 2026 17:51:31 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.360.g66cac248cb-goog
Message-ID: <20261007155130.2112665-2-ardb+git@google.com>
Subject: [PATCH] efi: Constify sysfs attributes
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
 arch/x86/platform/efi/efi.c | 11 ++++---
 drivers/firmware/efi/efi.c  | 34 +++++++++++---------
 include/linux/efi.h         |  3 +-
 3 files changed, 27 insertions(+), 21 deletions(-)

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
index e08ce813a3d4..93d6ffd9bc0d 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -155,21 +155,21 @@ static ssize_t systab_show(struct kobject *kobj,
 	return str - buf;
 }
=20
-static struct kobj_attribute efi_attr_systab =3D __ATTR_RO_MODE(systab, 04=
00);
+static const struct kobj_attribute efi_attr_systab =3D __ATTR_RO_MODE(syst=
ab, 0400);
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

