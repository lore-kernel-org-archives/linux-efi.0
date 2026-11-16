Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839245;
	b=Bcrp3JEe9vcu0CYqq9CMXsv3f+xJdLq56vjZCaqsK2cKLkb7Xs2iZQWaIrFqlylWPJ/D
	 xpBKeetTet9OJlDm5NHjvYxyvq1OL2GWj5rkA2G6XzEdBjaFKBUCRoanBInlF7Cair02o
	 FpaBFl/Ezunqet/6y/RXzVVjsE/jBJ9sshU5cfXxbTHF1GFJz12IPIpDKu/wfkmC8iolE
	 ZOOkX0v5BdLV+ch7aIrIzGc0IgINvC2peHqA83TA3Qg3M9WxHStiQPolPGIoS+Baf180x
	 UhzRcMMOMVAqKWvVc3HFvLM4jk0Uw6ht0mQWcuP2RHJQwFPqN+mKFjGNx4Y0fsFpOlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839245;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=w8vSAc39ER+wnwr2gp4YhB3zm+gD/NXMJnzExZ+aCSw=;
	b=V9V6KXSYIqwunVlYAnk/0wlDzB3nx16NxqmfTtO/P8/w9Oraqqb9shWai683/xEjiCbq
	 G/kA868W080LJa4IoV374KpN0OsOXch3jrvvxNx3k5WJzsThgrBcx+HWXevvkRK+TKG2b
	 p+X9gFzHZRGlmRdDS+fnX6q3C467wXmS2PKXQIXTWYYuySNUIA8ALtaXIpEX2L4qs2GKI
	 n1rM8jlSBaWq+cAyIyW+W+F+GrR+iRB1vZEAKLo9U6URts7yYt+Im5nN8+xiFJDrf6aAE
	 vfpfDPitoPFBrGYJLmHY51dXUp0C0eaVidbxc+vB2khuJk9KX99QCK3HIpRTTduZiIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fIGSOl95;
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74EB606A339
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:27:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E74EB606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fIGSOl95
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a359c7f47bso28538775e9.2
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 06:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839243; x=1795444043; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w8vSAc39ER+wnwr2gp4YhB3zm+gD/NXMJnzExZ+aCSw=;
        b=fIGSOl95PiN4UbD33Q/AfPlHmRkd6cYq55BHhvMrm7jG4e+W2R+HAv4/JC0YBXm37I
         8stoGhDt9Vmu3cqFTnRNMpQ/fPU0ttbnEi9W8EZfYSnSG5yk7F+OW2XP3eWPbV5uNo/M
         tcgjKVRxr2ZBPIh/uczVvwXBLiEDg00CgL3x3AWHXtqyJexVx3I6nqAO8qYDyZsMhuIl
         p+iay6aWvy3koKrRs8f/OM0cZSbGJQIk7qxCoDmktb5lrqhaO+yL8toQg0plvfVPAhTT
         p+rJuez7HivP4mFk4V64HhUOz9a0EMHRVkffDJX46zI837H+GgMrlr6HPySLplrVsFDY
         azMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839243; x=1795444043;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w8vSAc39ER+wnwr2gp4YhB3zm+gD/NXMJnzExZ+aCSw=;
        b=Iywcn/9MEqZ8g8A7Ip/5oS8Ad5lgyb3W/VxuoU4XIhvuXnKj0uARq1tE/AWXEHvMyY
         1t0HugStgBQVKXF0hyFPJVbVt2hLBQPt1tE9caykYe2sr8kwvZcZL4EH4g74sSujuKdx
         LxBSouj8doO2uqFCb/G13lN5CxQYnX7m9f2htTR+jNv7f0Xgos4vJXbdIYpnYSjnkYYg
         i5qEzja5ty+NMeOr9qeYXPjDOiuE9H0mWGpmtwHWMlBJtLYWCXF3hVEE60AL23IayGf3
         ifPRKpwzHHfEwo507jnBADVq30qGkUas05Eptscdwe1bVU0qFEKm9AJgQhhCOuFRvgZU
         uZHA==
X-Gm-Message-State: APuU4Z8rOnfIkQ6V31FtBXOefC4aEsCXH9yaDuyXFPtgtNybocTVNIIu
	hzCsAPATqtYep1uw666qrDdB5WvAmq286naT7JqqbG6+HJn8sxlNK2BGeCU70h51oeKuaxPlDip
	Fc/T6QsfmviK/EijTM9Ek65P5D/05uyVRWR7fRab9+GhfGyYvDRN4cKT6LInxgsAuczipP0QpoS
	kiLnJ0oHlOn6C/q24dR56ZOycILywmAg==
X-Received: from wmpg36.prod.google.com ([2002:a05:600c:4ca4:b0:4b0:ea12:73b5])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:512:b0:4a2:a9:ed87
 with SMTP id 5b1f17b1804b1-4bb55a5aa47mr175069505e9.19.1794839243177; Mon, 16
 Nov 2026 06:27:23 -0800 (PST)
Date: Mon, 16 Nov 2026 15:26:28 +0100
In-Reply-To: <20261116142618.1687025-17-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261116142618.1687025-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3178; i=ardb@kernel.org;
 h=from:subject; bh=PPz+dYtwyOs5yZuXn+AMtMiBmooJTq56sYarw+f+hSw=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu30IwHpVlVR4803rbOaLfv3H21/5iIJ9MT7es9jpXBP
 vtWTzjXUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACbivJPhn35CwPFN1+7eUHwQ
 v7VX7ZxafXcy76ZPxznZ9xapPhVyvsrIcGPC8WaTQ8oFzrZzsh1PsH8LkAlh7NO8en+l8bLHW7V YuAE=
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116142618.1687025-26-ardb+git@google.com>
Subject: [PATCH v3 09/15] efi/libstub: loongarch: Use struct efi_image_info to
 access image properties
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Instead of exposing individual symbols to the EFI stub explicitly via
the linker script, use the generic struct efi_image_info, which accesses
the original symbols via PC-relative references from the stub itself.

This improves code reuse across architectures, and makes it easier to
add new references in a generic manner.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/loongarch/kernel/image-vars.h            | 4 ----
 drivers/firmware/efi/libstub/loongarch-stub.c | 8 --------
 drivers/firmware/efi/libstub/loongarch.c      | 9 +--------
 3 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/loongarch/kernel/image-vars.h b/arch/loongarch/kernel/image-vars.h
index e557ebd46c2b..b01022ce6bb8 100644
--- a/arch/loongarch/kernel/image-vars.h
+++ b/arch/loongarch/kernel/image-vars.h
@@ -8,12 +8,8 @@
 #ifdef CONFIG_EFI_STUB
 
 __efistub_strcmp		= strcmp;
-__efistub_kernel_entry		= kernel_entry;
 __efistub_kernel_asize		= kernel_asize;
 __efistub_kernel_fsize		= kernel_fsize;
-#if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
-__efistub_sysfb_primary_display	= sysfb_primary_display;
-#endif
 
 #endif
 
diff --git a/drivers/firmware/efi/libstub/loongarch-stub.c b/drivers/firmware/efi/libstub/loongarch-stub.c
index d57e3d3557a5..6126b05e99fb 100644
--- a/drivers/firmware/efi/libstub/loongarch-stub.c
+++ b/drivers/firmware/efi/libstub/loongarch-stub.c
@@ -116,11 +116,3 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	*(unsigned long *)image_info += *image_addr - (unsigned long)image->image_base;
 	return status;
 }
-
-unsigned long kernel_entry_address(unsigned long kernel_addr,
-		efi_loaded_image_t *image)
-{
-	unsigned long base = (unsigned long)image->image_base;
-
-	return (unsigned long)&kernel_entry - base + kernel_addr;
-}
diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/efi/libstub/loongarch.c
index 7f21e79384d3..dd4bdf4b08cc 100644
--- a/drivers/firmware/efi/libstub/loongarch.c
+++ b/drivers/firmware/efi/libstub/loongarch.c
@@ -59,16 +59,9 @@ static efi_status_t exit_boot_func(struct efi_boot_memmap *map, void *priv)
 	return EFI_SUCCESS;
 }
 
-unsigned long __weak kernel_entry_address(unsigned long kernel_addr,
-		efi_loaded_image_t *image)
-{
-	return *(unsigned long *)(kernel_addr + 8) - PHYSADDR(VMLINUX_LOAD_ADDRESS) + kernel_addr;
-}
-
 efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
 			     const struct efi_image_info *image_info, char *cmdline_ptr)
 {
-	unsigned long kernel_addr = efistub_kernel_base(image_info);
 	kernel_entry_t real_kernel_entry;
 	struct exit_boot_struct priv;
 	unsigned long desc_size;
@@ -99,7 +92,7 @@ efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
 	csr_write(CSR_DMW2_INIT, LOONGARCH_CSR_DMWIN2);
 	csr_write(CSR_DMW3_INIT, LOONGARCH_CSR_DMWIN3);
 
-	real_kernel_entry = (void *)kernel_entry_address(kernel_addr, image);
+	real_kernel_entry = efistub_kernel_entry(image_info);
 
 	real_kernel_entry(true, (unsigned long)cmdline_ptr,
 			  (unsigned long)efi_system_table);
-- 
2.56.0.611.g1030f0b940-goog

