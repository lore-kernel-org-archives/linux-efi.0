Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795708230;
	b=LRw102jeQAj4hY5ebkaXfMjof2dPZDK5nXKY9qNJ1XBBqjQDG/mBGX6hNFwZjION33Oh
	 E/UVygeCBSp1sVGVptrvW3wqwl8mlvHOGCykC+9xwS24aBOOSX/s4XYxXgyj5rDfGH9V1
	 kRASuUVjaz1TPvgCxDa4Q/t9loL+Y+JBugP+sdUDIZK7NHGXHVhWBH7UAz3NWQPOLu6OT
	 0AoKN6k4cmUQa4SStZeWCSs3Y0B7gboAAwjz0GbAIYRHdOVHAvgNId7arWQTOq/AMBRpv
	 u6M4f99NNcFCO2mNyAh81K7/6jU3OijPvMlazrqhN64pGhGPeqC4Do16WuBQvEjF9AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795708230;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=JL/cyFp2k3ubn7iKatlLArpJgvVDo1Ae4q1D5CbiC6o=;
	b=LNN8+eidIbdnBsrJBpru/rLy5BNcXKc4zXeILUDw67S9NhIm/MkbxcyG6ebySyiSbfKz
	 zbN84oT5w2Gz9KF1zXeJJiSHWIrcXlRU0UFQ8Hr6N4vgWloBBuc5fdzhjvG+6Q5NZck0P
	 SJjCMkB9Em4kHGVr3mrqJHCi8YCwHkQ/trv4/aIEyFwPHB5GFwPisKcPaMLr+b+rahEU0
	 zFW3oimlDRTksyem6PvyYxVRpjTCx5HC3XljjmCKFUTJSsEUAkML+swS/EFfsCcRGbEVE
	 hZ1hzGnvnstzMUtgiGtwpdfZA5RmQoPEk5ep1pb6T2Mw2Iw1ODB2L92jdXgRKcrWvLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YWK3159I;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEA1606A321
	for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 15:50:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DEA1606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YWK3159I
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4ba01393800so3560405e9.1
        for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 07:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795708229; x=1796313029; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JL/cyFp2k3ubn7iKatlLArpJgvVDo1Ae4q1D5CbiC6o=;
        b=YWK3159IY78g5IGwrY3R/A6a3uLjtTSUDsTNbmwB8PBzAolw9rOGGFZtpnDdv4OSqi
         Fak+UHAFsA68w9WopTt623rHJ7Xu3nEmjD0Kjz8N+gLJubhVkzgQ88fgWh5GWGynBzDi
         HIYXnKZyT9P0j0Xl3whAMIFYgX+quAKFr4YVcKtFV+Mo92wWpM0k66hRMZ0ARCykAHD8
         VKMOTQUtdhOkh5yK9z26WRiI0IOEwsS4y1lK/wdhqvDd47NpOABv6AxqXVQnZIFZ9Qca
         ATMIEe8A5P3N+ITyzZpTxeLElfwRhUxalG10TaoPxPqMrZtwLyqoX0MvBpbHmgH9Fa7X
         fuew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795708229; x=1796313029;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JL/cyFp2k3ubn7iKatlLArpJgvVDo1Ae4q1D5CbiC6o=;
        b=bTGlN6g0xQ3hnI3AVvhHcswPMPyn5CmYbi+qR/VgcB9nGcKprSTf+yn1eI4X4DllG2
         dta0Z0hIzNp3/pLUYr/6Ffm8jH0mh9CGw3pot2tHr2Yk/ftMJCt+ajDfenPay2/UlRE8
         iVCvmkXDDOPo7Cu6H5NM/ML/bqXjuvT1ydvYmNGASLvRz6eliu0O96I3qCS+367TXvm+
         sX0NlopWITT7qLLVAlWQN6PMtETAKccR/gdcy1gz6Ne1EhsaqamoXbWw3CXPvnlxKOZy
         ztaVyIkUUkZ6PwMOTKcOtv8ROQCCLRdmq0fZjY0tHWtYAacBABoGK8fxF1cmucRiYUM3
         HATQ==
X-Gm-Message-State: APuU4Z+zfIqf4USGtLQ+B1HWSqg0QNecpF5FpCIj83vDvzvmVQI7rSax
	iSyHeXoJEaDCqS7Mk+4bPJqon0kWwvGM0lkx3UF0EZISt1kzioV1zfhTLmFcpuE7VsOArwNtyQ2
	Sr+6pfYawUfijAEtqlwCTwMiSRZXk6g1nJVzYkUuYCgqxI4esE7bhDT7Yd1ADjdiEwBXn3qTgcp
	q5uKdwX5t19/s/6E1+ELiX0B6ydqHe1A==
X-Received: from wmik14.prod.google.com ([2002:a7b:c40e:0:b0:4a7:28e5:546a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:6510:10b0:4a1:811c:8078
 with SMTP id 5b1f17b1804b1-4bb8881de57mr297581615e9.26.1795708228774; Thu, 26
 Nov 2026 07:50:28 -0800 (PST)
Date: Thu, 26 Nov 2026 16:50:19 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2467; i=ardb@kernel.org;
 h=from:subject; bh=WGbDIpMotR8/+NEIXKCfjkrF2l/j1lVds5GBCom33k0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZsj1Np9jdnphlfP+6PZipzYSsXEb4YukTr10FnoxjNhc
 b+pieYdpSwMYlwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCI10YwMHyQ+GNvJWR8tnhmZ
 VrRj1/W9Zw1kK2v2b3E1c3rS4Hj7JsP/bEvD5Y1bk4Ovm4fPUGMU1indN3fmNUPz9zNeXv24vn4 JAwA=
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261126155017.2401147-6-ardb+git@google.com>
Subject: [PATCH 1/3] efi/libstub: loongarch: Provide 64-bit integer shift
 helpers for 32-bit
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: loongarch@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>, 
	Dmitry Antipov <dmantipov@yandex.ru>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The EFI stub's copy of lib/cmdline.c performs 64-bit shifts in
memparse() [which is never actually called from the stub], and so it
needs library routines when running on 32-bit CPUs that lack native
instructions for this.

The LoongArch 32-bit EFI stub build already pulls in the library helpers
that are needed for this, but only when CONFIG_EFI_ZBOOT=y, which is not
sufficient, given that the same helpers will be needed in the vmlinux
build for the builtin copy of the EFI stub.

On other architectures, the builtin copy will call vmlinux's versions of
those routines, which are exposed to the stub via aliases in the linker
script. However, on LoongArch, those are C implementations that may be
instrumented and therefore unsuitable for use in the EFI stub.

Reported-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/20261122125352.gAcg5yLx-lkp@intel.com/
Fixes: 442082297e3d ("riscv: fix building compressed EFI image")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index bbab12b8eb4b..ba6c9e763862 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -88,7 +88,9 @@ lib-$(CONFIG_ARM64)		+= kaslr.o arm64.o arm64-stub.o smbios.o
 lib-$(CONFIG_X86)		+= x86-stub.o smbios.o
 lib-$(CONFIG_X86_64)		+= x86-5lvl.o
 lib-$(CONFIG_RISCV)		+= kaslr.o riscv.o riscv-stub.o
-lib-$(CONFIG_LOONGARCH)		+= loongarch.o loongarch-stub.o
+lib-loongarch-$(CONFIG_32BIT)	+= lib-ashldi3.o lib-lshrdi3.o
+lib-$(CONFIG_LOONGARCH)		+= loongarch.o loongarch-stub.o \
+				   $(lib-loongarch-y)
 
 CFLAGS_arm32-stub.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 
@@ -99,8 +101,7 @@ CFLAGS_zboot-decompress-zstd.o	+= -I$(srctree)/lib/zstd
 
 zboot-riscv-obj-$(CONFIG_32BIT)	:= lib-ashldi3.o lib-lshrdi3.o
 zboot-obj-$(CONFIG_RISCV)	+= lib-clz_ctz.o $(zboot-riscv-obj-y)
-zboot-loongarch-obj-$(CONFIG_32BIT) := lib-ashldi3.o lib-lshrdi3.o
-zboot-obj-$(CONFIG_LOONGARCH)	+= lib-clz_ctz.o $(zboot-loongarch-obj-y)
+zboot-obj-$(CONFIG_LOONGARCH)	+= lib-clz_ctz.o
 lib-$(CONFIG_EFI_ZBOOT)		+= zboot.o $(zboot-obj-y)
 
 lib-$(CONFIG_UNACCEPTED_MEMORY) += unaccepted_memory.o bitmap.o find.o
-- 
2.56.1.839.g22a8290db9-goog

