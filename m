Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794388736;
	b=IaoT3BXedJG22B+zJuiRu/2YCa9bKKhsWLX2eMXV9SzuU6x2t0mx2XzaRb12pbCznpRB
	 cZf7cK22x1VcUIW39UleLakywX2XG214qghkyTVGVDHrEnJM/9zgMNWrnF3cB80W4jkco
	 VSvbdapC0JWY1i+lzBMz9CIXScjyrXDj6Nchq2Q8Ci3WvEnl1jiWwzoqkx7ag48enrwRl
	 fvW9rcqa47lGt6JtIk0OvTmqXox9TFIjtsorKk2kIIqowsyT0sAGH90WYmVDWuUYFRLtB
	 dG8wyrFUE6q8suBPIeamd+98syJqBzay3G7QRymizTRTxRyGafsJ8ziyuINgTSOXefQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794388736;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:Subject:
	 From:To:Cc:Content-Type;
	bh=TT7VtQW9u3ynfbpc9fZSH0gzZlmmELI2VQAwXCCXBdk=;
	b=VsZdTc7zCCWgJjXlBpxPATPy89KN/RFCekaQ1FuLEHDLDjUkTXoTJmjv1OC9RYL2hTqt
	 W/sALr4+INUGRXf6CIYBckjdt8+R6BHRhIhOy48s7Jky7Gr+6XhVOS1MQrYvO1gs6HtLl
	 UxEA3t8yuRel0kF0bQPHo2bcqR92c9BElLPNaD2Ri0LYJ18TZq+QdWfbwNRfn1U5d5b4R
	 X2IM7kKNLs5GDvI9BNcaFQUCMeVx6WOBYA2sV+/riXokTVNbBBwYI+Nl6Zt1gL89eCE5T
	 Y3nYEM1V70rKzSv5b8QfPQsO0oW9UP8hGpDzs9DRmLVi36xPsj1czRHIynZO7/iQxZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=B8Ty4QMx;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF01606A321
	for <linux-efi@vger.kernel.org>; Wed, 11 Nov 2026 09:18:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BF01606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=B8Ty4QMx
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4b764ffc014so27077005e9.0
        for <linux-efi@vger.kernel.org>; Wed, 11 Nov 2026 01:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794388733; x=1794993533; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TT7VtQW9u3ynfbpc9fZSH0gzZlmmELI2VQAwXCCXBdk=;
        b=B8Ty4QMxm1vfEdE1VnKY4U6c5t+iG9oumO2n2YkMjk/9hSxY1CjNIxFCaBPVgrhJ27
         4bvasjZIiY7dWta5ZXt+n/fC6cJ4W7AGMYQ4yRP7uQMLjFHFLYaT5w+VC+WgGqSzAPdt
         zPj1Nw5q8f5mNR+gYLjm97XKYTTAzewaaeHCGD9hkIYnlpC//AAils9q6rJt9Ndp9ePl
         /bhDn12fgIVYtcKwC1zelS5Et40vXXxbcHhfCnSxL3FJ2Z6SWwjH6Vtu+XdyNlD8q4Z+
         9AZa4vF7LCwnxZ4A7AoCdca9e+i2U/IrzGHwJ2vG+Jhlqfcdos5U5dx55ipjvHYo4WoU
         9bHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794388733; x=1794993533;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TT7VtQW9u3ynfbpc9fZSH0gzZlmmELI2VQAwXCCXBdk=;
        b=s0Vrwn8y9QfEtCPMUTrpdF+wkOlVAxZj9oUgLqdueT7iPgqaVOOHN5DMIH2O+yj2Pw
         b2lxFy3KET4bvHKG6iufnOiCi+FLpHr+F+i71029fhmjJqxEzN5jyxmuC0C2wEY8Kl7Q
         r6JbH9HK9RBHK8DB2XXQ62ZDehFknUereiKtxB7gE6/2XMGsbW58wPrjfFFIZYwf/zLY
         7ab4LRoDP9nmtVAyeDn7f6h1/hssBQLQolnw/RX0R017nLJNqbKBuxLidUQ5sPHtumTv
         z0A1Bi9C9BjvQ/PYxqxIP5FThX5PuUnlQZLs6E5Vx2Itjg0IxMg8R3KNKXd6whhSb6Sv
         VkjQ==
X-Forwarded-Encrypted: i=1; AL+hErGp+jW7m92A5+ZHKn3kKwuTx+vli7/Z96ZLMFqw7kKIdx9QHsAlX8eaTJm7qRFbaFrSqFMgzvh/0qE=@vger.kernel.org
X-Gm-Message-State: APuU4Z9FeL8U7yKZ5NcOy3Xe2BxRQhrFWF+cYsnSTgxTFy+LtLeOi6Vp
	Ie7Uj6H+eVNH9Bq7GHECN814tbglMCE2qnYw/MroGTQdKqQNz/j8EM97ujTQa9WplhqgoaNG0g=
	=
X-Received: from wmbgx4.prod.google.com ([2002:a05:600c:8584:b0:4a2:966:8982])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f84:b0:4a1:e92b:ae4a
 with SMTP id 5b1f17b1804b1-4ba093b9a3cmr28555185e9.21.1794388733378; Wed, 11
 Nov 2026 01:18:53 -0800 (PST)
Date: Wed, 11 Nov 2026 10:18:44 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8041; i=ardb@kernel.org;
 h=from:subject; bh=N/v1V05jBJ0umOaiddD8bOXjCN0qyvgKpT10lVOTxKM=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeuL0Zdvr5RkGir/8LxJfMhtdqK77+SH6i2HBdim7foc9
 unV1G01HaUsDGJcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAiX9oYGRpNgi1mlgrs0Jwu
 PvVhZHvonV+CtwKeLdyQV/9i7basgliGf1YvF9t5G3XsXruF58E3Q+MrcrunXL27qo/ntdvimLr rN9kA
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261111091843.3621782-2-ardb+git@google.com>
Subject: [PATCH] x86: Make the 64-bit bzImage always physically relocatable
From: Ard Biesheuvel <ardb+git@google.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, hpa@zytor.com, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

On x86_64, the physical placement of the kernel is independent from its
mapping in the 'High Kernel Mapping' range. This means that even a
position dependent kernel built without boot-time relocation support can
run from any suitably aligned physical address, and there is no need to
make this behavior dependent on whether or not the kernel is virtually
relocatable.

On i386, the situation is different, given that the physical and virtual
load offsets must be equal, and so only a relocatable kernel can be
loaded at a physical address that deviates from its build-time default.

Clarify this in Kconfig and in the code, and advertise the 64-bit
bzImage as loadable at any physical offset regardless of whether
CONFIG_RELOCATABLE is set. In practice, this makes little difference,
given that it defaults to 'y' and is a prerequisite for EFI_STUB and
RANDOMIZE_BASE, but it will help with some future refactoring of the
relocation code.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/Kconfig                   | 40 ++++++++++++++++++------------
 arch/x86/boot/compressed/head_64.S |  4 ---
 arch/x86/boot/compressed/misc.c    |  8 +++---
 arch/x86/boot/header.S             |  8 ++----
 4 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 58dce0b66179..c7427daa0c3e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1898,7 +1898,7 @@ config EFI
 config EFI_STUB
 	bool "EFI stub support"
 	depends on EFI
-	select RELOCATABLE
+	select RELOCATABLE if X86_32
 	help
 	  This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
@@ -1995,8 +1995,9 @@ config PHYSICAL_START
 	help
 	  This gives the physical address where the kernel is loaded.
 
-	  If the kernel is not relocatable (CONFIG_RELOCATABLE=n) then bzImage
-	  will decompress itself to above physical address and run from there.
+	  If the kernel is not relocatable (CONFIG_RELOCATABLE=n) and built for
+	  i386, then the bzImage will decompress itself to the above physical
+	  address and run from there.
 	  Otherwise, bzImage will run from the address where it has been loaded
 	  by the boot loader. The only exception is if it is loaded below the
 	  above physical address, in which case it will relocate itself there.
@@ -2031,16 +2032,22 @@ config PHYSICAL_START
 	  Don't change this unless you know what you are doing.
 
 config RELOCATABLE
-	bool "Build a relocatable kernel"
-	default y
+	bool "Build a relocatable kernel" if X86_32
+	default X86_32
 	help
-	  This builds a kernel image that retains relocation information
-	  so it can be loaded someplace besides the default 1MB.
+	  This builds a kernel image that retains relocation information so it
+	  can be placed someplace besides the default PAGE_OFFSET + 1MB. This
+	  is a prerequisite for KASLR.
 	  The relocations tend to make the kernel binary about 10% larger,
 	  but are discarded at runtime.
 
-	  One use is for the kexec on panic case where the recovery kernel
-	  must live at a different physical address than the primary
+	  On i386, where the virtual and physical load offset of the kernel
+	  must be equal, this also allows the kernel image to be placed at a
+	  physical load address that differs from the compile time default. On
+	  x86_64, this is always permitted.
+
+	  One use is for the kexec on panic case on i386, where the recovery
+	  kernel must live at a different physical address than the primary
 	  kernel.
 
 	  Note: If CONFIG_RELOCATABLE=y, then the kernel runs from the address
@@ -2049,7 +2056,7 @@ config RELOCATABLE
 
 config RANDOMIZE_BASE
 	bool "Randomize the address of the kernel image (KASLR)"
-	depends on RELOCATABLE
+	select RELOCATABLE
 	default y
 	help
 	  In support of Kernel Address Space Layout Randomization (KASLR),
@@ -2085,7 +2092,7 @@ config RANDOMIZE_BASE
 # Relocation on x86 needs some additional build support
 config X86_NEED_RELOCS
 	def_bool y
-	depends on RANDOMIZE_BASE || (X86_32 && RELOCATABLE)
+	depends on RELOCATABLE
 	select ARCH_VMLINUX_NEEDS_RELOCS
 
 config PHYSICAL_ALIGN
@@ -2098,12 +2105,13 @@ config PHYSICAL_ALIGN
 	  where kernel is loaded and run from. Kernel is compiled for an
 	  address which meets above alignment restriction.
 
-	  If bootloader loads the kernel at a non-aligned address and
-	  CONFIG_RELOCATABLE is set, kernel will move itself to nearest
-	  address aligned to above value and run from there.
+	  If the bootloader loads the kernel at a non-aligned address and it
+	  is built for x86_64 or CONFIG_RELOCATABLE is set, the kernel will
+	  move itself to the nearest address aligned to above value and run
+	  from there.
 
-	  If bootloader loads the kernel at a non-aligned address and
-	  CONFIG_RELOCATABLE is not set, kernel will ignore the run time
+	  If the bootloader loads the i386 kernel at a non-aligned address and
+	  CONFIG_RELOCATABLE is not set, the kernel will ignore the run time
 	  load address and decompress itself to the address it has been
 	  compiled for and run from there. The address for which kernel is
 	  compiled already meets above alignment restrictions. Hence the
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 1aca51390f73..de1973f032c7 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -143,7 +143,6 @@ SYM_FUNC_START(startup_32)
  * for safe in-place decompression.
  */
 
-#ifdef CONFIG_RELOCATABLE
 	movl	%ebp, %ebx
 	movl	BP_kernel_alignment(%esi), %eax
 	decl	%eax
@@ -152,7 +151,6 @@ SYM_FUNC_START(startup_32)
 	andl	%eax, %ebx
 	cmpl	$LOAD_PHYSICAL_ADDR, %ebx
 	jae	1f
-#endif
 	movl	$LOAD_PHYSICAL_ADDR, %ebx
 1:
 
@@ -316,7 +314,6 @@ SYM_CODE_START(startup_64)
 	 */
 
 	/* Start with the delta to where the kernel will run at. */
-#ifdef CONFIG_RELOCATABLE
 	leaq	startup_32(%rip) /* - $startup_32 */, %rbp
 	movl	BP_kernel_alignment(%rsi), %eax
 	decl	%eax
@@ -325,7 +322,6 @@ SYM_CODE_START(startup_64)
 	andq	%rax, %rbp
 	cmpq	$LOAD_PHYSICAL_ADDR, %rbp
 	jae	1f
-#endif
 	movq	$LOAD_PHYSICAL_ADDR, %rbp
 1:
 
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 0f41ca0e52c0..d37569e7ee10 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -314,12 +314,10 @@ static size_t parse_elf(void *output)
 			if ((phdr->p_align % 0x200000) != 0)
 				error("Alignment of LOAD segment isn't multiple of 2MB");
 #endif
-#ifdef CONFIG_RELOCATABLE
-			dest = output;
-			dest += (phdr->p_paddr - LOAD_PHYSICAL_ADDR);
-#else
 			dest = (void *)(phdr->p_paddr);
-#endif
+			if (IS_ENABLED(CONFIG_X86_64) ||
+			    IS_ENABLED(CONFIG_RELOCATABLE))
+				dest += (unsigned long)output - LOAD_PHYSICAL_ADDR;
 			memmove(dest, output + phdr->p_offset, phdr->p_filesz);
 			break;
 		default: /* Ignore other PT_* */ break;
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 9bea5a1e2c52..b72e6055e103 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -332,7 +332,7 @@ initrd_addr_max: .long 0x7fffffff
 kernel_alignment:  .long CONFIG_PHYSICAL_ALIGN	#physical addr alignment
 						#required for protected mode
 						#kernel
-#ifdef CONFIG_RELOCATABLE
+#if defined(CONFIG_RELOCATABLE) || defined(CONFIG_X86_64)
 relocatable_kernel:    .byte 1
 #else
 relocatable_kernel:    .byte 0
@@ -342,14 +342,10 @@ min_alignment:		.byte MIN_KERNEL_ALIGN_LG2	# minimum alignment
 xloadflags:
 #ifdef CONFIG_X86_64
 # define XLF0 XLF_KERNEL_64			/* 64-bit kernel */
-#else
-# define XLF0 0
-#endif
-
-#if defined(CONFIG_RELOCATABLE) && defined(CONFIG_X86_64)
    /* kernel/boot_param/ramdisk could be loaded above 4g */
 # define XLF1 XLF_CAN_BE_LOADED_ABOVE_4G
 #else
+# define XLF0 0
 # define XLF1 0
 #endif
 
-- 
2.56.0.611.g1030f0b940-goog

