Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795708232;
	b=32LLva2cZj4EeLlAwNXB0qk0XI51aGOVkTVWOjayhJuOOch5UMPxiS1cHqG204V80qo0
	 Lju8MCzD3mg1UPtthKjePxtVMmAwMl36Kcrtslpas1ufiuwXbU5wODcqerIJW0e9oxBPi
	 iLdSmbRs1RFzP1Szt7+3dyDsKofUqQDfZtXuNyHHrIykhNsqerER2eNu04kzK4QKYdtkc
	 VKg1gGhfK5LOpk3Cd4ooROFTbIMttxhaRLOtoFXyii8nXJqHSWlgPWveY3g0bSM3BMXZX
	 0wEpZcw8A9WD96MLZlazIi7GTtuOakf8x1qlXU6h+XYc9tmS8626o8g6zFWf4a3RLwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795708232;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=hNEp+EpSuoAWa2FOWz91EgctBS3DkBjcKeuPq9ixcGY=;
	b=URs837aMbVmBpdQso1ongEFqncpxBJ/JwGaB/SYXHSbrSXGqceCWqzpsB7N8KTpwVrtn
	 RnrczC3d3cInlC1P94c2Qgw/VDD7FmFLTzitbb8XXIdNnsatUSkX3D1vM+ebHtl1q4trQ
	 gZrwgWXxist6bSsVVR1TmgzHny8m0UlBuuzBW65AFEq5N+9Ji+ac30JdEuUSc2ERAUAgB
	 5bkihzF0h3Rdf5MDw4rXdk2fc3ym2ZOPDPczBiVMwGScuU1Ggq9QBQjCLvxWNaoGmSIH7
	 WZZ/kV8JkyzdclmsWGJ7TrEEN0MG8auGMJAja8n9nllokV34WhcXH1f+GS+1bsnejzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DuYKK+kO;
	arc=none smtp.remote-ip=209.85.218.69
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4349606A321
	for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 15:50:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4349606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DuYKK+kO
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c51314820bfso388482166b.1
        for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 07:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795708230; x=1796313030; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hNEp+EpSuoAWa2FOWz91EgctBS3DkBjcKeuPq9ixcGY=;
        b=DuYKK+kO36AUmhwh/+OZPWZNyu4rUChuMJ5DQLwXhAc95xzRGmGa7fKtDOEIssbG7D
         7E0wh1oR+BZkKzktFshCHSXBNzD3hIOs86BGnUKjMDRkdEVRxegzCOcaybGJ6lND6GGB
         dWPVSpOf+UTqEYrLhs8q55RdR92cXpgISqz99u9rgnAxbs5JMlUfmGNbVltWqwGup3DN
         3Evr/pHQZ/X5buw33wSiJ+d9oOkkntkopwfDJqo8SYpl/W/KQkF8Olwob9op3q8VVRyG
         FE5mKbZaGiXDUz2+DStNxhoSd4D5KD7yPazDIigMZCFZlPhxiArBE3ssIVVyQVY0bLyH
         xXjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795708230; x=1796313030;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hNEp+EpSuoAWa2FOWz91EgctBS3DkBjcKeuPq9ixcGY=;
        b=1IWiJWzKj+W1NzJ1tD4PfCX5CBuUR/xdE5wEZZuaFYML1HmRE1NKxLLb9WnAkX3c7x
         HjWgB6ZaChnasIF2xMivPKQ6BXlRiR7SuaXg/NgJLTWNx6U81gFKG0Jew+FWAXQMX0t2
         EZ6g1/lJM75G8GIBB3HqfCgLokReMFzjO/gkux0WSfrj8eAhamCedj9UxhvvvTyVb9Sp
         /KFUYda3Qqzg+FPKKbddnAfyWDVoqyDioN4x0cwQgfNgPGL7y7jl2zNTPAAcEFNJv0gH
         Qt7h5eR0/Qy5RP52fC/uEev4MgM7jPAmOsX2wP4w0rEDFjhj6JFNECZ/2+SawX905Rmx
         biTQ==
X-Gm-Message-State: APuU4Z+dCKLoPwrdez8mRwJfgiCWufS/KloiVgMiK0z8RLkImZeTkx1v
	rnV1fd6S8Jqe9JQRLcIIDDP+XzAKUh1uPMw0+I7J2vP7lQP7lCoY8q1W2UTFo9l7uokSmOQekx8
	zaJug1DW/o83tW+Pvt8rpwZ11TBtfckmklK7lkyRY38qLpZlOvoId1dZvyil2gl8etJODAgSglU
	I3FDR97G7fxEy1xhX+Aie1aI3WUQEmRg==
X-Received: from edtp10.prod.google.com ([2002:aa7:cc8a:0:b0:6b7:f191:fc17])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3e88:b0:c26:1648:a06b
 with SMTP id a640c23a62f3a-c513aae0416mr1833079566b.38.1795708229939; Thu, 26
 Nov 2026 07:50:29 -0800 (PST)
Date: Thu, 26 Nov 2026 16:50:20 +0100
In-Reply-To: <20261126155017.2401147-5-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261126155017.2401147-5-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2393; i=ardb@kernel.org;
 h=from:subject; bh=OyxyYmp5MYEMKS5makgvGF9LLz0+mYsT5yjjcBoZU4U=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZsj1NZt/vriuO1yQe3ub23qv2nzxl8QPrryo61Ot67rR
 H37BO2OUhYGMS4GWTFFFoHZf9/tPD1RqtZ5lizMHFYmkCEMXJwCMJHPBxkZNos5T3t9eIZfx5rJ
 x3IvFS0WY+J4F6x1e/4n/Y2sb7T48xkZOlYVi4SWLq69HHz+ls2VVQEP9DdzByhv2vb4kPQ5Rm5 VNgA=
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261126155017.2401147-7-ardb+git@google.com>
Subject: [PATCH 2/3] efi/zboot: Eliminate unused code from the zboot executable
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: loongarch@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>, 
	Dmitry Antipov <dmantipov@yandex.ru>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Wire up -ffunction-sections and --gc-sections so that unused functions
are dropped from the build. This saves some space, but more importantly,
will allow us to get rid of library routines that are never called
(64-bit shift on 32-bit, clz/ctz on RISC-V)

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile       | 2 ++
 drivers/firmware/efi/libstub/Makefile.zboot | 3 ++-
 drivers/firmware/efi/libstub/zboot.lds      | 4 ++--
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index ba6c9e763862..20b5b77956d1 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -34,6 +34,8 @@ cflags-$(CONFIG_LOONGARCH)	+= -fpie
 
 cflags-$(CONFIG_EFI_PARAMS_FROM_FDT)	+= -I$(srctree)/scripts/dtc/libfdt
 
+cflags-$(CONFIG_EFI_ZBOOT)	+= -ffunction-sections
+
 KBUILD_CFLAGS			:= $(subst $(CC_FLAGS_FTRACE),,$(cflags-y)) \
 				   -Os -DDISABLE_BRANCH_PROFILING \
 				   -include $(srctree)/include/linux/hidden.h \
diff --git a/drivers/firmware/efi/libstub/Makefile.zboot b/drivers/firmware/efi/libstub/Makefile.zboot
index 52baacf3e9d9..3b827e4b571d 100644
--- a/drivers/firmware/efi/libstub/Makefile.zboot
+++ b/drivers/firmware/efi/libstub/Makefile.zboot
@@ -50,7 +50,8 @@ endif
 
 ZBOOT_DEPS := $(obj)/zboot-header.o $(objtree)/drivers/firmware/efi/libstub/lib.a
 
-LDFLAGS_vmlinuz.efi.elf := -T $(srctree)/drivers/firmware/efi/libstub/zboot.lds
+LDFLAGS_vmlinuz.efi.elf := -T $(srctree)/drivers/firmware/efi/libstub/zboot.lds \
+			   --gc-sections
 $(obj)/vmlinuz.efi.elf: $(obj)/vmlinuz.o $(ZBOOT_DEPS) FORCE
 	$(call if_changed,ld)
 
diff --git a/drivers/firmware/efi/libstub/zboot.lds b/drivers/firmware/efi/libstub/zboot.lds
index a785c0123749..f3d4342c8a08 100644
--- a/drivers/firmware/efi/libstub/zboot.lds
+++ b/drivers/firmware/efi/libstub/zboot.lds
@@ -16,7 +16,7 @@ SECTIONS
 
 	.rodata : ALIGN(8) {
 		__efistub__gzdata_start = .;
-		*(.gzdata)
+		KEEP(*(.gzdata))
 		__efistub_payload_size = . - 4;
 		__efistub__gzdata_end = .;
 		*(.rodata* .init.rodata* .srodata*)
@@ -31,7 +31,7 @@ SECTIONS
 
         .sbat : ALIGN(4096) {
 		_sbat = .;
-		*(.sbat)
+		KEEP(*(.sbat))
 		_esbat = ALIGN(4096);
 		. = _esbat;
 	}
-- 
2.56.1.839.g22a8290db9-goog

