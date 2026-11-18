Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018748;
	b=ItNtLbO62odaBeR1frA2afVfRi4zgQda7m/KuhOSe/wX5gwODy1ZaqJDE+p/bic5V9GW
	 3q2bmmYz+wRtfILZNX+aJFm53davWGtTNV2RUBDjqinFYXgKW6AeMIT5ERAtNVC/Rbbaf
	 bR9QUo/FapUqkA6RmGYEXLcsmJXAnkRKDlxcqB44CQgXnDTNshN9NK2XiExYgLshIiGK2
	 zLqU3OgKHp6g+mZ+bj4FSlMpTlqUWYsmXE8MtxbtPc36vhL2V5KqX1+vPEdVObWpsPSxy
	 TNahTGgcqIAtbRl+6iwfMCjukLrJ5n9U/Jt9Rb2aFmeYBavH2sDAU/7Lar3bkOnObwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018748;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=td8ITXDrXutCjNnmbB2tSH71qffKjt0MqufWPcdUlKA=;
	b=YHRcWG4XXQC6OFYOIv2fHSTMuwBnoyX0hP/LExTCGHPJVo1FyePiUZwBFEatS9qpk986
	 7hQelSC6rztst5YMX13nNEGEtEugu1c810ug0xk+yAah7q6Q9M9+EtHtFbE1fbTijXpRJ
	 ifPHN+TZ5rp4o18zVrkMaiy3s5Ds9GYejyvLpOYjEXqDs/soFm7ybBxhhDAlcEUIfXqGI
	 OLp2DwEzWUlKJh6jCa7pzUUrLuyUL6afXCWr3dYoVHnEoif/d1Ur1bHRaC92tz0vMZJN4
	 z+pZu909MHbcHUxKS/eGlqDzKbKMulejxujwRXd81GqsolyyHmlcZlzsrKLmVWOfPbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="D9qcY/95";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25710606A31C
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 16:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D9qcY/95
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907EE1F000C5
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 16:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795018747;
	bh=td8ITXDrXutCjNnmbB2tSH71qffKjt0MqufWPcdUlKA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=D9qcY/95cAaBBwMsV6z7kub6qMGt7cftSwk9MDPgQyoL5j6LyZikteqe3o6X8YxVv
	 26O9auaSpT/R+OzL2tfPJdUTCgH0O9IR8GQ1OhFvRCqgdfQDjMjaL/JBWlzrF3sr+Z
	 CCy3kOC72p+nyGS90qpgdB0oNw30ruCIyaOrHFTbJeZ7Es9ZW6kzSuoaY90HLCJvlh
	 9sM3zrtIAmArjj4RE+z50s9SdNvSNPO+RkzHVbdGuGUfTQbz5tB9QIizPPIhwTiTVZ
	 P7WTAsoauhN6pCLRoE1ZUd5swSe5Smgb5TpwaUkRKt4q4KW9rbMMIG9rkpSzKk23qR
	 h6Cwti7zBcrDw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id BCF34198003A;
	Wed, 18 Nov 2026 11:19:05 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 18 Nov 2026 11:19:05 -0500
X-ME-Sender: <xms:-M_9aor5GGxkRLSqV_OzDjqT-Djasd03viitIJz8JnqvSfkcXiVQuQ>
    <xme:-M_9apcPmwmMPkNhyZf2W59Gi001XpGxOSGUBP48hZwEgDudrRg5dBXVgyoAy6LsB
    94oVG9GgnkBlHaegXSjZ-IcT-L6-434koeGfqphqmOe2o6igCxCBoib>
X-ME-Proxy-Cause: dmFkZTE9Mc/hBAyYah6FqRqdr+bR1Ar06azXY8Nnjm5x/ePyqiT3v+LLHb0X6oltaIXTKz
    ctcxqmzs3k4VXpma/zsm2VZ/a8kCqiUTUo9/6TGlh9TS0a8q7DxM5YPl9wbIqLcy2OW0Bn
    9wYozBUVZi6Ex91fba9dslQXEk2PeNYpkeDqE3uZIkhpRFxzSErAu1Hb7TMcBJv0zns1mK
    9w6qmc+hJJPotRkcVo+YCE+H1Autd0bOAYXSbggFRA9pHsYpOwPj6uf0P2gU52rsriL5Wp
    UkEumPqNd0GuGYIT09ee+EJhTpelp/rHMR6Yq+bLegnywF9MkGnLXn4c8xbTqzz+mVzJJK
    Mavzj0F7uCe/DpPRr/P+A1M/9jTcjHKnpHAOygnCUoiuj0eX4zB6PuvtIpl+2QNWI+wpxF
    ySJZI+p+fVjPJYPpKbheF+kiv3m0glNUrFzUcN5cmeJSgyXSlqaF1M85FEguml2VgbZZug
    05wvu6sVfx1stZmxHEedD8mNzvVkpuZzIfo8NF2hoHfqDRAWV7nHdEWyHPR+oaMd+iRDat
    6p39T8d5KSxZzl0qBvUGuEHOUCLPh50hFI+7cE+4yfqDIuwhPmBilbB1WNKC8Qg4DiQ7DC
    PMp+1utAgh1+iNIwE4H8QXl0ReWnvNGw6nFjYsj0HypnNonOu7lABUVq9pCg
X-ME-Proxy: <xmx:-c_9ap2GXLqpeoWMP5aRXqbao86CObu6taH2pvP0mXchalb_lzkARg>
    <xmx:-c_9apC4Dr3AyrWkfiFvXBSybOMHB51LorGFa-ahCjXWQFw00ag3bQ>
    <xmx:-c_9alc9DxTPVJ4JdwR-Rmv8pSxkYlDg-NL0PImz3HHVWP5yh0y6LQ>
    <xmx:-c_9am6JPjENt1E-703SsMsckrSlq7Y9z5295ZgDvzoteZbdQDbDDw>
    <xmx:-c_9aoWyRIUEvZcB_N6m6hl6Pi63vJNsVazseSmQxGCFiNtoyrtjvDrW>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 5C8D7F80093; Wed, 18 Nov 2026 11:19:04 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Wed, 18 Nov 2026 17:18:44 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "H . Peter Anvin" <hpa@zytor.com>, "Ard Biesheuvel" <ardb+git@google.com>,
 x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Message-Id: <3522588c-9d7a-454b-afe8-c16c6788265a@app.fastmail.com>
In-Reply-To: <FD1A5979-1504-4A96-B26C-D89BD362170A@zytor.com>
References: <20261111091843.3621782-2-ardb+git@google.com>
 <FD1A5979-1504-4A96-B26C-D89BD362170A@zytor.com>
Subject: Re: [PATCH] x86: Make the 64-bit bzImage always physically relocatable
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 18 Nov 2026, at 16:51, H. Peter Anvin wrote:
> On November 11, 2026 1:18:44 AM PST, Ard Biesheuvel <ardb+git@google.com> wrote:
>>From: Ard Biesheuvel <ardb@kernel.org>
>>
>>On x86_64, the physical placement of the kernel is independent from its
>>mapping in the 'High Kernel Mapping' range. This means that even a
>>position dependent kernel built without boot-time relocation support can
>>run from any suitably aligned physical address, and there is no need to
>>make this behavior dependent on whether or not the kernel is virtually
>>relocatable.
>>
>>On i386, the situation is different, given that the physical and virtual
>>load offsets must be equal, and so only a relocatable kernel can be
>>loaded at a physical address that deviates from its build-time default.
>>
>>Clarify this in Kconfig and in the code, and advertise the 64-bit
>>bzImage as loadable at any physical offset regardless of whether
>>CONFIG_RELOCATABLE is set. In practice, this makes little difference,
>>given that it defaults to 'y' and is a prerequisite for EFI_STUB and
>>RANDOMIZE_BASE, but it will help with some future refactoring of the
>>relocation code.
>>
>>Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>>---
>> arch/x86/Kconfig                   | 40 ++++++++++++++++++------------
>> arch/x86/boot/compressed/head_64.S |  4 ---
>> arch/x86/boot/compressed/misc.c    |  8 +++---
>> arch/x86/boot/header.S             |  8 ++----
>> 4 files changed, 29 insertions(+), 31 deletions(-)
>>
>>diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>index 58dce0b66179..c7427daa0c3e 100644
>>--- a/arch/x86/Kconfig
>>+++ b/arch/x86/Kconfig
>>@@ -1898,7 +1898,7 @@ config EFI
>> config EFI_STUB
>> 	bool "EFI stub support"
>> 	depends on EFI
>>-	select RELOCATABLE
>>+	select RELOCATABLE if X86_32
>> 	help
>> 	  This kernel feature allows a bzImage to be loaded directly
>> 	  by EFI firmware without the use of a bootloader.
>>@@ -1995,8 +1995,9 @@ config PHYSICAL_START
>> 	help
>> 	  This gives the physical address where the kernel is loaded.
>> 
>>-	  If the kernel is not relocatable (CONFIG_RELOCATABLE=n) then bzImage
>>-	  will decompress itself to above physical address and run from there.
>>+	  If the kernel is not relocatable (CONFIG_RELOCATABLE=n) and built for
>>+	  i386, then the bzImage will decompress itself to the above physical
>>+	  address and run from there.
>> 	  Otherwise, bzImage will run from the address where it has been loaded
>> 	  by the boot loader. The only exception is if it is loaded below the
>> 	  above physical address, in which case it will relocate itself there.
>>@@ -2031,16 +2032,22 @@ config PHYSICAL_START
>> 	  Don't change this unless you know what you are doing.
>> 
>> config RELOCATABLE
>>-	bool "Build a relocatable kernel"
>>-	default y
>>+	bool "Build a relocatable kernel" if X86_32
>>+	default X86_32
>> 	help
>>-	  This builds a kernel image that retains relocation information
>>-	  so it can be loaded someplace besides the default 1MB.
>>+	  This builds a kernel image that retains relocation information so it
>>+	  can be placed someplace besides the default PAGE_OFFSET + 1MB. This
>>+	  is a prerequisite for KASLR.
>> 	  The relocations tend to make the kernel binary about 10% larger,
>> 	  but are discarded at runtime.
>> 
>>-	  One use is for the kexec on panic case where the recovery kernel
>>-	  must live at a different physical address than the primary
>>+	  On i386, where the virtual and physical load offset of the kernel
>>+	  must be equal, this also allows the kernel image to be placed at a
>>+	  physical load address that differs from the compile time default. On
>>+	  x86_64, this is always permitted.
>>+
>>+	  One use is for the kexec on panic case on i386, where the recovery
>>+	  kernel must live at a different physical address than the primary
>> 	  kernel.
>> 
>> 	  Note: If CONFIG_RELOCATABLE=y, then the kernel runs from the address
>>@@ -2049,7 +2056,7 @@ config RELOCATABLE
>> 
>> config RANDOMIZE_BASE
>> 	bool "Randomize the address of the kernel image (KASLR)"
>>-	depends on RELOCATABLE
>>+	select RELOCATABLE
>> 	default y
>> 	help
>> 	  In support of Kernel Address Space Layout Randomization (KASLR),
>>@@ -2085,7 +2092,7 @@ config RANDOMIZE_BASE
>> # Relocation on x86 needs some additional build support
>> config X86_NEED_RELOCS
>> 	def_bool y
>>-	depends on RANDOMIZE_BASE || (X86_32 && RELOCATABLE)
>>+	depends on RELOCATABLE
>> 	select ARCH_VMLINUX_NEEDS_RELOCS
>> 
>> config PHYSICAL_ALIGN
>>@@ -2098,12 +2105,13 @@ config PHYSICAL_ALIGN
>> 	  where kernel is loaded and run from. Kernel is compiled for an
>> 	  address which meets above alignment restriction.
>> 
>>-	  If bootloader loads the kernel at a non-aligned address and
>>-	  CONFIG_RELOCATABLE is set, kernel will move itself to nearest
>>-	  address aligned to above value and run from there.
>>+	  If the bootloader loads the kernel at a non-aligned address and it
>>+	  is built for x86_64 or CONFIG_RELOCATABLE is set, the kernel will
>>+	  move itself to the nearest address aligned to above value and run
>>+	  from there.
>> 
>>-	  If bootloader loads the kernel at a non-aligned address and
>>-	  CONFIG_RELOCATABLE is not set, kernel will ignore the run time
>>+	  If the bootloader loads the i386 kernel at a non-aligned address and
>>+	  CONFIG_RELOCATABLE is not set, the kernel will ignore the run time
>> 	  load address and decompress itself to the address it has been
>> 	  compiled for and run from there. The address for which kernel is
>> 	  compiled already meets above alignment restrictions. Hence the
>>diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
>>index 1aca51390f73..de1973f032c7 100644
>>--- a/arch/x86/boot/compressed/head_64.S
>>+++ b/arch/x86/boot/compressed/head_64.S
>>@@ -143,7 +143,6 @@ SYM_FUNC_START(startup_32)
>>  * for safe in-place decompression.
>>  */
>> 
>>-#ifdef CONFIG_RELOCATABLE
>> 	movl	%ebp, %ebx
>> 	movl	BP_kernel_alignment(%esi), %eax
>> 	decl	%eax
>>@@ -152,7 +151,6 @@ SYM_FUNC_START(startup_32)
>> 	andl	%eax, %ebx
>> 	cmpl	$LOAD_PHYSICAL_ADDR, %ebx
>> 	jae	1f
>>-#endif
>> 	movl	$LOAD_PHYSICAL_ADDR, %ebx
>> 1:
>> 
>>@@ -316,7 +314,6 @@ SYM_CODE_START(startup_64)
>> 	 */
>> 
>> 	/* Start with the delta to where the kernel will run at. */
>>-#ifdef CONFIG_RELOCATABLE
>> 	leaq	startup_32(%rip) /* - $startup_32 */, %rbp
>> 	movl	BP_kernel_alignment(%rsi), %eax
>> 	decl	%eax
>>@@ -325,7 +322,6 @@ SYM_CODE_START(startup_64)
>> 	andq	%rax, %rbp
>> 	cmpq	$LOAD_PHYSICAL_ADDR, %rbp
>> 	jae	1f
>>-#endif
>> 	movq	$LOAD_PHYSICAL_ADDR, %rbp
>> 1:
>> 
>>diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
>>index 0f41ca0e52c0..d37569e7ee10 100644
>>--- a/arch/x86/boot/compressed/misc.c
>>+++ b/arch/x86/boot/compressed/misc.c
>>@@ -314,12 +314,10 @@ static size_t parse_elf(void *output)
>> 			if ((phdr->p_align % 0x200000) != 0)
>> 				error("Alignment of LOAD segment isn't multiple of 2MB");
>> #endif
>>-#ifdef CONFIG_RELOCATABLE
>>-			dest = output;
>>-			dest += (phdr->p_paddr - LOAD_PHYSICAL_ADDR);
>>-#else
>> 			dest = (void *)(phdr->p_paddr);
>>-#endif
>>+			if (IS_ENABLED(CONFIG_X86_64) ||
>>+			    IS_ENABLED(CONFIG_RELOCATABLE))
>>+				dest += (unsigned long)output - LOAD_PHYSICAL_ADDR;
>> 			memmove(dest, output + phdr->p_offset, phdr->p_filesz);
>> 			break;
>> 		default: /* Ignore other PT_* */ break;
>>diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
>>index 9bea5a1e2c52..b72e6055e103 100644
>>--- a/arch/x86/boot/header.S
>>+++ b/arch/x86/boot/header.S
>>@@ -332,7 +332,7 @@ initrd_addr_max: .long 0x7fffffff
>> kernel_alignment:  .long CONFIG_PHYSICAL_ALIGN	#physical addr alignment
>> 						#required for protected mode
>> 						#kernel
>>-#ifdef CONFIG_RELOCATABLE
>>+#if defined(CONFIG_RELOCATABLE) || defined(CONFIG_X86_64)
>> relocatable_kernel:    .byte 1
>> #else
>> relocatable_kernel:    .byte 0
>>@@ -342,14 +342,10 @@ min_alignment:		.byte MIN_KERNEL_ALIGN_LG2	# minimum alignment
>> xloadflags:
>> #ifdef CONFIG_X86_64
>> # define XLF0 XLF_KERNEL_64			/* 64-bit kernel */
>>-#else
>>-# define XLF0 0
>>-#endif
>>-
>>-#if defined(CONFIG_RELOCATABLE) && defined(CONFIG_X86_64)
>>    /* kernel/boot_param/ramdisk could be loaded above 4g */
>> # define XLF1 XLF_CAN_BE_LOADED_ABOVE_4G
>> #else
>>+# define XLF0 0
>> # define XLF1 0
>> #endif
>> 
>
> Can you clarify what these nebulous future improvements are?

The main improvement today is that CONFIG_RELOCATABLE will be
only implied by CONFIG_RANDOMIZE_BASE, and so turning that off
gets rid of the unnecessary relocation metadata.

The future improvement is still fgKASLR, which I am implementing
in the ELF domain, making it arch-agnostic, and applicable to
other static ELF executables such as hypervisors and statically
linked user space executables. This will hopefully make the
needed tooling changes more palatable to the wider community.

On x86, that will require the use of PIC code for kaslr capable
kernels, [which surely you remember having discussed with me in
the past], but only when opting in to kaslr/fgkaslr. Otherwise,
the usual position dependent codegen will be preserved.

Note that I have extensive benchmarking data now that shows that
the PIC change itself has negligible impact for performance, but
having the option to turn that off if you don't need it is still 
appreciated, I assume. But let's leave that discussion for when
I resend that particular series.

-- 
Ard.
