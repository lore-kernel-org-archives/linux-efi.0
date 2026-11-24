Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795518339;
	b=wxS+l62M+MEUpXVTwLCvxjjCGy23tcDV2UoD7m548apE2cKGgrI+x98FV4dCtjpug2L7
	 7FBXqBLWEZkLWR9M7K8WXnok9ApkwgjUilnmuI4DGjWpBf1GxA47DxyK5doFTLeZI8VJp
	 dBwJbY2cliid9FjbdE7fQmdX3KNauLCRSx9K5zSF80sc9w2Dmbxzx0jMNdtS9VcETYq9U
	 wv5avPZTxMycWN+kW0UjkZOajKVWHnQ3V47/Og9YHsCJCXdBXtuBGDW8bizadc7UiQk5C
	 gBwb8STJFQzX2dVFz674aWpxZhbXrCCrVcrkQotmOo2uveqgrPChwzQ8K9lSbUd3ftA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795518339;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:Subject:
	 From:To:Cc:Content-Type;
	bh=q1FewmwQpyYBj5/92ypDDWXTNPW1ruAQcVRFBx9mNXs=;
	b=xjEMXLiQoC2mQjhjVSm+AlnJZfvMCweyXeH1lfl7HazMySd/ksSo3EVj+BwEh9/AfUql
	 UU4/iuOpNSGx5Kr1SqNBd+J9k5g17GfCN8593QE52ci9ybEVMKMPzkgBt6coInKthgp2A
	 C/aEDYvPp/PNRWyJ8oJtn6H1Nw9gg4AQTWK50LQY9A5udKU7xRSJoqSuV5SEtAkCVAlLI
	 6pC3bnCR3H1/UK4pdFWLM6CA4Nji1R8Qzsslq4zqfN2rLzxs509KaF88ECABgoGkv9i69
	 p7xq80E4E9uQzrxUKNzth9omfmLVyJdQW+gYNDqnovsPG26UBUzFKuHfulr8oC+seLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hRAF2ovc;
	arc=none smtp.remote-ip=209.85.221.72
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F003A606A321
	for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 11:05:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F003A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hRAF2ovc
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4a370217dcfso4052879f8f.1
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 03:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795518336; x=1796123136; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q1FewmwQpyYBj5/92ypDDWXTNPW1ruAQcVRFBx9mNXs=;
        b=hRAF2ovc6btmk4ke2cEeEcDPy9S0CtF84jMlh0iBJlIowssAGSx+alHBYLptm5VCoN
         GLD/mzWU+oYVdxpXHg2ljF7GIofDvHdYAe7kZ5bOGFJq9+VrxSTcn9lqXv1KEHf9pAA9
         ji2PExaDyNaoYg8o+0BhAYDj0ihnkLuxcv8jVjLyv+TWWFzq50uxnHe4Ct1AbqG+g1FU
         YLwL2VS9kprBuYsleiKC2AEmGVQs4brGhiFvbJ9uWVOGCNif0n2C+OuayhiC+V1aYRU7
         sdmdj+KbSO4Nh4yO204AAREQnAmE/qsbDADXLmo3i8idgBtkMpKf62MmU/SFXS72UbeS
         PqWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795518336; x=1796123136;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q1FewmwQpyYBj5/92ypDDWXTNPW1ruAQcVRFBx9mNXs=;
        b=eHTV14GSFRcYjWd/CI7rh3Q+lBPoBTjVi0DyS+11c52G+wgC8swC1d92drPd6F+9e3
         EoVdRNx/NhJbnvAHuyuZ396KmKwmR9oyUGsRZeY+Sa4eXgPf7IP4scBfjjljVvxNEo5l
         2XNPMSbqf4DmMAAOZ9AaWosUUP5sA5Q4gvEW8lVHDarLhRtuo5BRPW5fUerj0RDbUEEH
         /q1BCwXcPGKz91wzuyoWkSMviIwLVYIeXuEwxTQuQYag169WLetTxujA8KC6vZY8kSqs
         caQ5X0RyjOioHkfK5JFsEV+TriJbmJNOrGpUp5PKTYLxT0n6exOMZZUjVKLohZKc7fml
         8Lqg==
X-Forwarded-Encrypted: i=1; AL+hErHxyCFeS6ScItIOoM88bitTU12DEpd15A7X6n0h8oBNey2rPaSmGfnRS8QzNfWs22l2KzbXQL5m76A=@vger.kernel.org
X-Gm-Message-State: APuU4Z+VXIORHmPGALRAb03xwTr/qhm3qKXt+nvs8KMpZ9WNc2QEASg0
	ExoQ2U/y07vvSfLgs1TT+oOO2fzLUx/C+LX9McbYYmt4jfys4C1DdUHuMqBoDKQt+fNnu8B26A=
	=
X-Received: from wrva18.prod.google.com ([2002:a5d:5712:0:b0:4b8:5e5b:92ea])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:470c:b0:4a7:557:fc0
 with SMTP id ffacd0b85a97d-4abb225fb4bmr26841487f8f.32.1795518336014; Tue, 24
 Nov 2026 03:05:36 -0800 (PST)
Date: Tue, 24 Nov 2026 12:05:23 +0100
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=11650; i=ardb@kernel.org;
 h=from:subject; bh=SDc+5FPp/AF/6SxWAP97nVgzcWB9q6/E+VASAxZN4iY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZs1v7iR82zta/kTii84Hk2oufF7se6GJ76HWmNiFxsml
 Jjd6/frKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABM5mcDwP6ltdcSrI/cnsgcv
 E7Fjf6FV+m3u2x29sz8zKGnZ/39deYnhv8O2DTkiop3VT85bt5j2JnIv1I+Zvv/z98olPKtj1s3 /zgcA
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261124110522.1371247-2-ardb+git@google.com>
Subject: [PATCH v2] x86: Always permit the kernel to be placed at any physical address
From: Ard Biesheuvel <ardb+git@google.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

On i386, the virtual displacement relative to PAGE_OFFSET must equal the
physical displacement relative to LOAD_OFFSET, and so relocations need
to be applied to all virtual symbol references at boot if the actual
physical load address deviates from the build-time default.

This requires CONFIG_RELOCATABLE=y, otherwise the decompressor will
place the kernel at its build-time default physical load address, so
that no relocations need to be applied.

On x86_64, this logic was inherited, even though the virtual placement
of the kernel is independent from the physical load address, and so the
kernel can always be placed at its build-time virtual default address
regardless of where it was placed in the physical space, requiring no
relocation fixups to be applied.

This means that for the 64-bit kernel, the CONFIG_RELOCATABLE dependency
can be dropped. Instead, always present it as 'relocatable' via the
bzImage metadata as well as to the EFI stub, and only depend on
CONFIG_RELOCATABLE when enabling KASLR (CONFIG_RANDOMIZE_BASE=y).

For symmetry, do the same for the 32-bit kernel. This makes
CONFIG_RELOCATABLE a hard dependency there, as the relocation metadata
is always required, but this is already the default in practice.

While at it, tidy up the Kconfig help texts.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
Changes since v1: [0]
- make i386 kernels always relocatable as well
- clean up Kconfig help texts a bit more

[0] https://lore.kernel.org/all/20261111091843.3621782-2-ardb+git@google.com/

 arch/x86/Kconfig                   | 94 ++++++--------------
 arch/x86/boot/compressed/head_32.S |  2 -
 arch/x86/boot/compressed/head_64.S |  4 -
 arch/x86/boot/compressed/misc.c    |  4 -
 arch/x86/boot/header.S             | 10 +--
 5 files changed, 28 insertions(+), 86 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 58dce0b66179..bc3647515e8b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -19,6 +19,7 @@ config X86_32
 	select MODULES_USE_ELF_REL
 	select OLD_SIGACTION
 	select ARCH_SPLIT_ARG64
+	select RELOCATABLE
 
 config X86_64
 	def_bool y
@@ -1898,7 +1899,6 @@ config EFI
 config EFI_STUB
 	bool "EFI stub support"
 	depends on EFI
-	select RELOCATABLE
 	help
 	  This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
@@ -1990,66 +1990,37 @@ config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
 	def_bool CRASH_RESERVE
 
 config PHYSICAL_START
-	hex "Physical address where the kernel is loaded" if (EXPERT || CRASH_DUMP)
+	hex "Physical load address of the kernel" if (EXPERT || CRASH_DUMP) && X86_32
 	default "0x1000000"
 	help
-	  This gives the physical address where the kernel is loaded.
-
-	  If the kernel is not relocatable (CONFIG_RELOCATABLE=n) then bzImage
-	  will decompress itself to above physical address and run from there.
-	  Otherwise, bzImage will run from the address where it has been loaded
-	  by the boot loader. The only exception is if it is loaded below the
-	  above physical address, in which case it will relocate itself there.
-
-	  In normal kdump cases one does not have to set/change this option
-	  as now bzImage can be compiled as a completely relocatable image
-	  (CONFIG_RELOCATABLE=y) and be used to load and run from a different
-	  address. This option is mainly useful for the folks who don't want
-	  to use a bzImage for capturing the crash dump and want to use a
-	  vmlinux instead. vmlinux is not relocatable hence a kernel needs
-	  to be specifically compiled to run from a specific memory area
-	  (normally a reserved region) and this option comes handy.
-
-	  So if you are using bzImage for capturing the crash dump,
-	  leave the value here unchanged to 0x1000000 and set
-	  CONFIG_RELOCATABLE=y.  Otherwise if you plan to use vmlinux
-	  for capturing the crash dump change this value to start of
-	  the reserved region.  In other words, it can be set based on
-	  the "X" value as specified in the "crashkernel=YM@XM"
-	  command line boot parameter passed to the panic-ed
-	  kernel. Please take a look at Documentation/admin-guide/kdump/kdump.rst
-	  for more details about crash dumps.
-
-	  Usage of bzImage for capturing the crash dump is recommended as
-	  one does not have to build two kernels. Same kernel can be used
-	  as production kernel and capture kernel. Above option should have
-	  gone away after relocatable bzImage support is introduced. But it
-	  is present because there are users out there who continue to use
-	  vmlinux for dump capture. This option should go away down the
-	  line.
+	  The minimum physical load address of the decompressed image. The
+	  kernel will be placed here by the decompressor if it was loaded below
+	  this address. If it was loaded at or above this address, the kernel
+	  will be placed at the actual load address rounded up to
+	  PHYSICAL_ALIGN.
 
-	  Don't change this unless you know what you are doing.
+	  Legacy i386 kdump use cases based on vmlinux rather than bzImage
+	  might need to override this, otherwise leave at its default.
 
 config RELOCATABLE
-	bool "Build a relocatable kernel"
-	default y
+	def_bool y
 	help
-	  This builds a kernel image that retains relocation information
-	  so it can be loaded someplace besides the default 1MB.
-	  The relocations tend to make the kernel binary about 10% larger,
-	  but are discarded at runtime.
+	  This builds a kernel image that retains relocation information,
+	  allowing its placement in the virtual address space to deviate from
+	  the build time default. The relocations are applied at boot and then
+	  discarded, so their runtime memory footprint is zero.
 
-	  One use is for the kexec on panic case where the recovery kernel
-	  must live at a different physical address than the primary
-	  kernel.
+	  On i386, the virtual displacement relative to PAGE_OFFSET must equal
+	  the physical displacement relative to LOAD_OFFSET, and so this option
+	  must always be set.
 
-	  Note: If CONFIG_RELOCATABLE=y, then the kernel runs from the address
-	  it has been loaded at and the compile time physical address
-	  (CONFIG_PHYSICAL_START) is used as the minimum location.
+	  On x86_64, the virtual displacement is independent from the physical
+	  placement, and the relocations are only used when randomizing the
+	  virtual address space (KASLR).
 
 config RANDOMIZE_BASE
 	bool "Randomize the address of the kernel image (KASLR)"
-	depends on RELOCATABLE
+	select RELOCATABLE
 	default y
 	help
 	  In support of Kernel Address Space Layout Randomization (KASLR),
@@ -2085,30 +2056,19 @@ config RANDOMIZE_BASE
 # Relocation on x86 needs some additional build support
 config X86_NEED_RELOCS
 	def_bool y
-	depends on RANDOMIZE_BASE || (X86_32 && RELOCATABLE)
+	depends on RELOCATABLE
 	select ARCH_VMLINUX_NEEDS_RELOCS
 
 config PHYSICAL_ALIGN
-	hex "Alignment value to which kernel should be aligned"
+	hex "Minimum alignment of the physical load address"
 	default "0x200000"
 	range 0x2000 0x1000000 if X86_32
 	range 0x200000 0x1000000 if X86_64
 	help
-	  This value puts the alignment restrictions on physical address
-	  where kernel is loaded and run from. Kernel is compiled for an
-	  address which meets above alignment restriction.
-
-	  If bootloader loads the kernel at a non-aligned address and
-	  CONFIG_RELOCATABLE is set, kernel will move itself to nearest
-	  address aligned to above value and run from there.
-
-	  If bootloader loads the kernel at a non-aligned address and
-	  CONFIG_RELOCATABLE is not set, kernel will ignore the run time
-	  load address and decompress itself to the address it has been
-	  compiled for and run from there. The address for which kernel is
-	  compiled already meets above alignment restrictions. Hence the
-	  end result is that kernel runs from a physical address meeting
-	  above alignment restrictions.
+	  The minimum alignment of the kernel's physical load address. If the
+	  decompressor was loaded at a physical address > PHYSICAL_START but
+	  not aligned to this value, it will round it up to the next multiple
+	  and decompress the kernel there.
 
 	  On 32-bit this value must be a multiple of 0x2000. On 64-bit
 	  this value must be a multiple of 0x200000.
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 1cfe9802a42f..79d9e2c330ba 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -82,7 +82,6 @@ SYM_FUNC_START(startup_32)
  * %ebp is calculated to be the address that the kernel will be decompressed to.
  */
 
-#ifdef CONFIG_RELOCATABLE
 	leal	startup_32@GOTOFF(%edx), %ebx
 	movl	BP_kernel_alignment(%esi), %eax
 	decl	%eax
@@ -91,7 +90,6 @@ SYM_FUNC_START(startup_32)
 	andl    %eax, %ebx
 	cmpl	$LOAD_PHYSICAL_ADDR, %ebx
 	jae	1f
-#endif
 	movl	$LOAD_PHYSICAL_ADDR, %ebx
 1:
 
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
index 0f41ca0e52c0..7a4aff845fbd 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -314,12 +314,8 @@ static size_t parse_elf(void *output)
 			if ((phdr->p_align % 0x200000) != 0)
 				error("Alignment of LOAD segment isn't multiple of 2MB");
 #endif
-#ifdef CONFIG_RELOCATABLE
 			dest = output;
 			dest += (phdr->p_paddr - LOAD_PHYSICAL_ADDR);
-#else
-			dest = (void *)(phdr->p_paddr);
-#endif
 			memmove(dest, output + phdr->p_offset, phdr->p_filesz);
 			break;
 		default: /* Ignore other PT_* */ break;
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 9bea5a1e2c52..d06ebc6d4c06 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -332,24 +332,16 @@ initrd_addr_max: .long 0x7fffffff
 kernel_alignment:  .long CONFIG_PHYSICAL_ALIGN	#physical addr alignment
 						#required for protected mode
 						#kernel
-#ifdef CONFIG_RELOCATABLE
 relocatable_kernel:    .byte 1
-#else
-relocatable_kernel:    .byte 0
-#endif
 min_alignment:		.byte MIN_KERNEL_ALIGN_LG2	# minimum alignment
 
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
2.56.1.831.g720f3f5937-goog

