Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7093E443C0F
	for <linux-efi@vger.kernel.org>; Thu,  8 Oct 2026 08:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791447208; cv=none; b=q+d/1epFE+muSjtReS82Shd0j3jIbHYOfL+qG80EsKehVJXsTbfITmtINO7VO+N/dJYlQcTZhgW99VmOfa3wq9A6a82p/gzH0eDPpxTGGjlz0Yn7SDTfrLd6nFyWwOyF8jNfFeQctDUYgJEl7PfKZCnol7EIOTxvVRX8k9leAZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791447208; c=relaxed/simple;
	bh=sAZmrQfFRnvX1r8inqgJzOXyhociMrhtZR2BILeJs6Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pe9JqhygjYRvs4wNkiy3n2YccWmG5YcDyQWRRwYs8NW3Hs5V1YFJ1CxR2B85DFD9Y7sQQhpRgrrzKfxVlez2aSnM/Ut3Ke5KcFfaKZ6nsJ5IR2zrQjKoiELbcvUKLjUNSNBSNy3pnmc6il6BcWf9zg8g/a5qN92XwsvLevoCKxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WPbM41nT; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WPbM41nT"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a1813fea7dso20064835e9.2
        for <linux-efi@vger.kernel.org>; Thu, 08 Oct 2026 01:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791447206; x=1792052006; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=16FkECH/P3PnGGILReivsLQaUXwzid4+SEzG39QlygM=;
        b=WPbM41nTf27eiRSsgss0+tPoElHtnM8tCzDy+FTQBoPB2MxFOOLsex+FyAfZO9rkOu
         0nIWp1LxK38Qwx4IWDzDFL4WfdRhvI9hzt3QCZsfrwbqm8Visdb6zGDKMUHR2qpF61U6
         hcGziRIeqPY3nTeujsKUSNn467B+uaTx7OR+mn4lPtSl6+4/Hu1USqZSkZ2lKrOcPfy0
         MTGbd+qqt+eF3yVJLMILBd/d4Z89rnd5zhF0jOUY/rU9ZWKscl/OSw7CQQ/fly/N6GuY
         D09fcxP25Jwvpu9X0frNubGMOyQ9nCtZoSafYZ0mZI3xLJIlGnyrVF4TcaMpqCDq8N5i
         7OQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791447206; x=1792052006;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=16FkECH/P3PnGGILReivsLQaUXwzid4+SEzG39QlygM=;
        b=w55Kx24ly3rcYwVSHEXjL5mtIjZbCSJMJbZEg+4cEhEDdOGz5fnxCYf7omZLEAiaLd
         ytTaTTrFjpiBzEN9ex/gFdEOaik5i7hVGgpPv0gaTEfLywNC8lHZmTUjrL0s9C/s4yQp
         VrVrVEGJrIDLRbMjwCPRwjspSTxzTBQ6O5iyNa022YA3krj8aipDmJtL2SPBGujEFEU0
         ix7+F6nkSrIVlfYq2JvZP6Efy7LM28vy+oyphw1qwgr0HyZTycCcaeNriWrfjXH4TNJk
         EEGIG3V+j2cFYRx42rsY2ykDNTxTDFrOvl81njz5Tp0ZVtAXuluxcLUgk1vNW2xCooCw
         7bFA==
X-Gm-Message-State: AFuF++keSUhxB0Dip6dKA7CBHfBJrRg50HqfdrsWq7lZ5B500RbqTjj3
	rooPDtxho116t7SAUnQv01zvOYo7m161p0H0+qc5l3lbpaiawK6oCVVAgGDcG/IMQLlcJikmlQd
	GrtMTy350hxUD9GSoMsWG3NOnx63ABAg5JQi4O6ZhboQWoAqsFwSyyGNxmn4yUjF8SuxaJWtV/9
	yM1nyoEpaoZOgqo8a7v8TiH7QMIEtrKA==
X-Received: from wmgb18.prod.google.com ([2002:a05:600c:1512:b0:4a0:1976:e6a3])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e87:b0:49f:bd3c:bc18
 with SMTP id 5b1f17b1804b1-4a18045565cmr81178025e9.19.1791447205382; Thu, 08
 Oct 2026 01:13:25 -0700 (PDT)
Date: Thu,  8 Oct 2026 10:13:20 +0200
In-Reply-To: <20261008081317.2602565-4-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261008081317.2602565-4-ardb+git@google.com>
X-Mailer: git-send-email 2.56.0.360.g66cac248cb-goog
Message-ID: <20261008081317.2602565-6-ardb+git@google.com>
Subject: [PATCH v2 2/2] efi: Use sysfs_emit() not sprintf() to generate sysfs
 file contents
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	"=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?=" <linux@weissschuh.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Ard Biesheuvel <ardb@kernel.org>

Use sysfs_emit() where appropriate to generate the contents of EFI
related sysfs nodes. This is a more robust wrapper around sprintf()
designed for this purpose.

Reported-by: Thomas Wei=C3=9Fschuh <linux@weissschuh.net>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/platform/efi/efi.c |  2 +-
 drivers/firmware/efi/efi.c  | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index d8fe93770c2a..5eb96c17883e 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -893,7 +893,7 @@ bool efi_is_table_address(unsigned long phys_addr)
 static ssize_t name##_show(struct kobject *kobj, \
 			   const struct kobj_attribute *attr, char *buf) \
 { \
-	return sprintf(buf, "0x%lx\n", EFI_FIELD(name)); \
+	return sysfs_emit(buf, "0x%lx\n", EFI_FIELD(name)); \
 }
=20
 EFI_ATTR_SHOW(fw_vendor);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 8026264d4990..b4504542cb2c 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -133,26 +133,26 @@ struct kobject *efi_kobj;
 static ssize_t systab_show(struct kobject *kobj,
 			   const struct kobj_attribute *attr, char *buf)
 {
-	char *str =3D buf;
+	int offset =3D 0;
=20
 	if (!kobj || !buf)
 		return -EINVAL;
=20
 	if (efi.acpi20 !=3D EFI_INVALID_TABLE_ADDR)
-		str +=3D sprintf(str, "ACPI20=3D0x%lx\n", efi.acpi20);
+		offset =3D sysfs_emit(buf, "ACPI20=3D0x%lx\n", efi.acpi20);
 	if (efi.acpi !=3D EFI_INVALID_TABLE_ADDR)
-		str +=3D sprintf(str, "ACPI=3D0x%lx\n", efi.acpi);
+		offset +=3D sysfs_emit_at(buf, offset, "ACPI=3D0x%lx\n", efi.acpi);
 	/*
 	 * If both SMBIOS and SMBIOS3 entry points are implemented, the
 	 * SMBIOS3 entry point shall be preferred, so we list it first to
 	 * let applications stop parsing after the first match.
 	 */
 	if (efi.smbios3 !=3D EFI_INVALID_TABLE_ADDR)
-		str +=3D sprintf(str, "SMBIOS3=3D0x%lx\n", efi.smbios3);
+		offset +=3D sysfs_emit_at(buf, offset, "SMBIOS3=3D0x%lx\n", efi.smbios3)=
;
 	if (efi.smbios !=3D EFI_INVALID_TABLE_ADDR)
-		str +=3D sprintf(str, "SMBIOS=3D0x%lx\n", efi.smbios);
+		offset +=3D sysfs_emit_at(buf, offset, "SMBIOS=3D0x%lx\n", efi.smbios);
=20
-	return str - buf;
+	return offset;
 }
=20
 static const struct kobj_attribute efi_attr_systab =3D __KOBJ_ATTR_RO_MODE=
(systab, 0400);
@@ -160,7 +160,7 @@ static const struct kobj_attribute efi_attr_systab =3D =
__KOBJ_ATTR_RO_MODE(systab,
 static ssize_t fw_platform_size_show(struct kobject *kobj,
 				     const struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", efi_enabled(EFI_64BIT) ? 64 : 32);
+	return sysfs_emit(buf, "%d\n", efi_enabled(EFI_64BIT) ? 64 : 32);
 }
=20
 extern __weak const struct kobj_attribute efi_attr_fw_vendor;
@@ -406,7 +406,7 @@ static ssize_t efi_runtime_show(struct kobject *kobj,
 				const struct kobj_attribute *attr,
 				char *buf)
 {
-	return sprintf(buf, "%d\n", efi_enabled(EFI_RUNTIME_SERVICES));
+	return sysfs_emit(buf, "%d\n", efi_enabled(EFI_RUNTIME_SERVICES));
 }
=20
 static ssize_t efi_runtime_store(struct kobject *kobj,
--=20
2.56.0.360.g66cac248cb-goog

