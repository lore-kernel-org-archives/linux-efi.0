Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.136
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019584;
	b=v4hwayYv0maDiEQXJoxHnaINzKIoAMtdnaY0XR6p9GObXUquclgRpuglXsPvyL51Tjs+
	 sQLyMd+I+wrClYq2mbLthlM71VmwK/vfoXlIFgCW7+3D6F5McoJA1r0FOYSSgA2A8TKZ2
	 Y6bKsNQKwF7RQ1SzrhA7Xga/ykVO0iDBUx+rCTA5vc2VIJd2FxjBdbAnUTqCF31u7uvpl
	 xAit4ND/imLNPaufcDI9bdgB98qNoEkzsYfREKAhxm4M4N/ug5FeH1dNFwBw+V5ieW0co
	 ntbh9e07ClD7Yj3oVPYRsc9Pusgs/iYROq+RmPeXCQQ7zxbcB3GV5jhq0Y8UkYtkfZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019584;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Date:From:To:CC:
	 Subject:User-Agent:In-Reply-To:References:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=MrY/KnS3ef/f4qiV96vwLU4Xuf0acemhEzWgdG7MY5I=;
	b=djmh/1omTxdf4NuIR3ClT8fzoITxN1ttqduZyKJXxTbMo4RNCRWJ3dR7wy7gT1mwMfCt
	 2uUkEz/fr6glpeskV7X+vuphL0FNtSrUPrRBcGUMlY7n1M2M2xOLk7JVfap+pmysD3Z5x
	 h7jn2bcoR4KdaYXhv5od5JoNxwqD5/n4GDkeoT5eB2j24nDOI6VY0lTWXDXXSJQ/jsdm3
	 iml1tyos84Ow7kNDrABPN5DC5yATiji+pLWmSnArHwxfp1wq4HmMWYILsW+S1pVsLlEYJ
	 3xuH38M0IUr9T19OK5F84yPLahN+LVCxqqZgW3+ojyZ2Djk/P7EP3t6C+b6mE/BcXhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zytor.com;
	spf=pass smtp.mailfrom=zytor.com;
	dkim=pass header.d=zytor.com header.i=@zytor.com header.a=rsa-sha256 header.s=2026102901 header.b=z+OA0xs5;
	arc=none smtp.remote-ip=198.137.202.136
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6AC606A333;
	Wed, 18 Nov 2026 16:33:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D6AC606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.a=rsa-sha256 header.s=2026102901 header.b=z+OA0xs5
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6AIGUb9C3348199
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 18 Nov 2026 08:30:52 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6AIGUb9C3348199
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026102901; t=1795019578;
	bh=MrY/KnS3ef/f4qiV96vwLU4Xuf0acemhEzWgdG7MY5I=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=z+OA0xs5vZqfjj9VmdPdTbO/hJtCzwyIpjLJpY6J5u5X3SRJ8DA1nurvNGS//+XsE
	 gKKZRRq6vhRBoFe+97OhxQRlXLnfahFCcQF2ecm1E4XS+zcfxF6SmflqMTB53Z2U1/
	 PrORRWuhQSPIlTWmmqhHuJVq79BHY4qpi3kQRx0tRo/azm5NnjCH+kw3Zdulo3zzGQ
	 l1iSDe899cEdjm/NU3sTGHaRvfW9XAA56RvlmZwRT246f1w/qYLbPHIqP+0bkvRI/G
	 a06LUldQ+mdXaiLjZZN8BckfGKTyYSGTq9U9JdnfzWL4C3CkImfmJyBZJ5xV4U3PoP
	 LbQ1MrzMKUUOg==
Date: Wed, 18 Nov 2026 08:29:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Ard Biesheuvel <ardb@kernel.org>, Ard Biesheuvel <ardb+git@google.com>,
        x86@kernel.org
CC: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_x86=3A_Make_the_64-bit_bz?=
 =?US-ASCII?Q?Image_always_physically_relocatable?=
User-Agent: K-9 Mail for Android
In-Reply-To: <3522588c-9d7a-454b-afe8-c16c6788265a@app.fastmail.com>
References: <20261111091843.3621782-2-ardb+git@google.com> <FD1A5979-1504-4A96-B26C-D89BD362170A@zytor.com> <3522588c-9d7a-454b-afe8-c16c6788265a@app.fastmail.com>
Message-ID: <F6E708AE-0476-4E9A-A39D-3DF15E91EB80@zytor.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On November 18, 2026 8:18:44 AM PST, Ard Biesheuvel <ardb@kernel=2Eorg> wro=
te:
>
>
>On Wed, 18 Nov 2026, at 16:51, H=2E Peter Anvin wrote:
>> On November 11, 2026 1:18:44 AM PST, Ard Biesheuvel <ardb+git@google=2E=
com> wrote:
>>>From: Ard Biesheuvel <ardb@kernel=2Eorg>
>>>
>>>On x86_64, the physical placement of the kernel is independent from its
>>>mapping in the 'High Kernel Mapping' range=2E This means that even a
>>>position dependent kernel built without boot-time relocation support ca=
n
>>>run from any suitably aligned physical address, and there is no need to
>>>make this behavior dependent on whether or not the kernel is virtually
>>>relocatable=2E
>>>
>>>On i386, the situation is different, given that the physical and virtua=
l
>>>load offsets must be equal, and so only a relocatable kernel can be
>>>loaded at a physical address that deviates from its build-time default=
=2E
>>>
>>>Clarify this in Kconfig and in the code, and advertise the 64-bit
>>>bzImage as loadable at any physical offset regardless of whether
>>>CONFIG_RELOCATABLE is set=2E In practice, this makes little difference,
>>>given that it defaults to 'y' and is a prerequisite for EFI_STUB and
>>>RANDOMIZE_BASE, but it will help with some future refactoring of the
>>>relocation code=2E
>>>
>>>Signed-off-by: Ard Biesheuvel <ardb@kernel=2Eorg>
>>>---
>>> arch/x86/Kconfig                   | 40 ++++++++++++++++++------------
>>> arch/x86/boot/compressed/head_64=2ES |  4 ---
>>> arch/x86/boot/compressed/misc=2Ec    |  8 +++---
>>> arch/x86/boot/header=2ES             |  8 ++----
>>> 4 files changed, 29 insertions(+), 31 deletions(-)
>>>
>>>diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>>index 58dce0b66179=2E=2Ec7427daa0c3e 100644
>>>--- a/arch/x86/Kconfig
>>>+++ b/arch/x86/Kconfig
>>>@@ -1898,7 +1898,7 @@ config EFI
>>> config EFI_STUB
>>> 	bool "EFI stub support"
>>> 	depends on EFI
>>>-	select RELOCATABLE
>>>+	select RELOCATABLE if X86_32
>>> 	help
>>> 	  This kernel feature allows a bzImage to be loaded directly
>>> 	  by EFI firmware without the use of a bootloader=2E
>>>@@ -1995,8 +1995,9 @@ config PHYSICAL_START
>>> 	help
>>> 	  This gives the physical address where the kernel is loaded=2E
>>>=20
>>>-	  If the kernel is not relocatable (CONFIG_RELOCATABLE=3Dn) then bzIm=
age
>>>-	  will decompress itself to above physical address and run from there=
=2E
>>>+	  If the kernel is not relocatable (CONFIG_RELOCATABLE=3Dn) and built=
 for
>>>+	  i386, then the bzImage will decompress itself to the above physical
>>>+	  address and run from there=2E
>>> 	  Otherwise, bzImage will run from the address where it has been load=
ed
>>> 	  by the boot loader=2E The only exception is if it is loaded below t=
he
>>> 	  above physical address, in which case it will relocate itself there=
=2E
>>>@@ -2031,16 +2032,22 @@ config PHYSICAL_START
>>> 	  Don't change this unless you know what you are doing=2E
>>>=20
>>> config RELOCATABLE
>>>-	bool "Build a relocatable kernel"
>>>-	default y
>>>+	bool "Build a relocatable kernel" if X86_32
>>>+	default X86_32
>>> 	help
>>>-	  This builds a kernel image that retains relocation information
>>>-	  so it can be loaded someplace besides the default 1MB=2E
>>>+	  This builds a kernel image that retains relocation information so i=
t
>>>+	  can be placed someplace besides the default PAGE_OFFSET + 1MB=2E Th=
is
>>>+	  is a prerequisite for KASLR=2E
>>> 	  The relocations tend to make the kernel binary about 10% larger,
>>> 	  but are discarded at runtime=2E
>>>=20
>>>-	  One use is for the kexec on panic case where the recovery kernel
>>>-	  must live at a different physical address than the primary
>>>+	  On i386, where the virtual and physical load offset of the kernel
>>>+	  must be equal, this also allows the kernel image to be placed at a
>>>+	  physical load address that differs from the compile time default=2E=
 On
>>>+	  x86_64, this is always permitted=2E
>>>+
>>>+	  One use is for the kexec on panic case on i386, where the recovery
>>>+	  kernel must live at a different physical address than the primary
>>> 	  kernel=2E
>>>=20
>>> 	  Note: If CONFIG_RELOCATABLE=3Dy, then the kernel runs from the addr=
ess
>>>@@ -2049,7 +2056,7 @@ config RELOCATABLE
>>>=20
>>> config RANDOMIZE_BASE
>>> 	bool "Randomize the address of the kernel image (KASLR)"
>>>-	depends on RELOCATABLE
>>>+	select RELOCATABLE
>>> 	default y
>>> 	help
>>> 	  In support of Kernel Address Space Layout Randomization (KASLR),
>>>@@ -2085,7 +2092,7 @@ config RANDOMIZE_BASE
>>> # Relocation on x86 needs some additional build support
>>> config X86_NEED_RELOCS
>>> 	def_bool y
>>>-	depends on RANDOMIZE_BASE || (X86_32 && RELOCATABLE)
>>>+	depends on RELOCATABLE
>>> 	select ARCH_VMLINUX_NEEDS_RELOCS
>>>=20
>>> config PHYSICAL_ALIGN
>>>@@ -2098,12 +2105,13 @@ config PHYSICAL_ALIGN
>>> 	  where kernel is loaded and run from=2E Kernel is compiled for an
>>> 	  address which meets above alignment restriction=2E
>>>=20
>>>-	  If bootloader loads the kernel at a non-aligned address and
>>>-	  CONFIG_RELOCATABLE is set, kernel will move itself to nearest
>>>-	  address aligned to above value and run from there=2E
>>>+	  If the bootloader loads the kernel at a non-aligned address and it
>>>+	  is built for x86_64 or CONFIG_RELOCATABLE is set, the kernel will
>>>+	  move itself to the nearest address aligned to above value and run
>>>+	  from there=2E
>>>=20
>>>-	  If bootloader loads the kernel at a non-aligned address and
>>>-	  CONFIG_RELOCATABLE is not set, kernel will ignore the run time
>>>+	  If the bootloader loads the i386 kernel at a non-aligned address an=
d
>>>+	  CONFIG_RELOCATABLE is not set, the kernel will ignore the run time
>>> 	  load address and decompress itself to the address it has been
>>> 	  compiled for and run from there=2E The address for which kernel is
>>> 	  compiled already meets above alignment restrictions=2E Hence the
>>>diff --git a/arch/x86/boot/compressed/head_64=2ES b/arch/x86/boot/compr=
essed/head_64=2ES
>>>index 1aca51390f73=2E=2Ede1973f032c7 100644
>>>--- a/arch/x86/boot/compressed/head_64=2ES
>>>+++ b/arch/x86/boot/compressed/head_64=2ES
>>>@@ -143,7 +143,6 @@ SYM_FUNC_START(startup_32)
>>>  * for safe in-place decompression=2E
>>>  */
>>>=20
>>>-#ifdef CONFIG_RELOCATABLE
>>> 	movl	%ebp, %ebx
>>> 	movl	BP_kernel_alignment(%esi), %eax
>>> 	decl	%eax
>>>@@ -152,7 +151,6 @@ SYM_FUNC_START(startup_32)
>>> 	andl	%eax, %ebx
>>> 	cmpl	$LOAD_PHYSICAL_ADDR, %ebx
>>> 	jae	1f
>>>-#endif
>>> 	movl	$LOAD_PHYSICAL_ADDR, %ebx
>>> 1:
>>>=20
>>>@@ -316,7 +314,6 @@ SYM_CODE_START(startup_64)
>>> 	 */
>>>=20
>>> 	/* Start with the delta to where the kernel will run at=2E */
>>>-#ifdef CONFIG_RELOCATABLE
>>> 	leaq	startup_32(%rip) /* - $startup_32 */, %rbp
>>> 	movl	BP_kernel_alignment(%rsi), %eax
>>> 	decl	%eax
>>>@@ -325,7 +322,6 @@ SYM_CODE_START(startup_64)
>>> 	andq	%rax, %rbp
>>> 	cmpq	$LOAD_PHYSICAL_ADDR, %rbp
>>> 	jae	1f
>>>-#endif
>>> 	movq	$LOAD_PHYSICAL_ADDR, %rbp
>>> 1:
>>>=20
>>>diff --git a/arch/x86/boot/compressed/misc=2Ec b/arch/x86/boot/compress=
ed/misc=2Ec
>>>index 0f41ca0e52c0=2E=2Ed37569e7ee10 100644
>>>--- a/arch/x86/boot/compressed/misc=2Ec
>>>+++ b/arch/x86/boot/compressed/misc=2Ec
>>>@@ -314,12 +314,10 @@ static size_t parse_elf(void *output)
>>> 			if ((phdr->p_align % 0x200000) !=3D 0)
>>> 				error("Alignment of LOAD segment isn't multiple of 2MB");
>>> #endif
>>>-#ifdef CONFIG_RELOCATABLE
>>>-			dest =3D output;
>>>-			dest +=3D (phdr->p_paddr - LOAD_PHYSICAL_ADDR);
>>>-#else
>>> 			dest =3D (void *)(phdr->p_paddr);
>>>-#endif
>>>+			if (IS_ENABLED(CONFIG_X86_64) ||
>>>+			    IS_ENABLED(CONFIG_RELOCATABLE))
>>>+				dest +=3D (unsigned long)output - LOAD_PHYSICAL_ADDR;
>>> 			memmove(dest, output + phdr->p_offset, phdr->p_filesz);
>>> 			break;
>>> 		default: /* Ignore other PT_* */ break;
>>>diff --git a/arch/x86/boot/header=2ES b/arch/x86/boot/header=2ES
>>>index 9bea5a1e2c52=2E=2Eb72e6055e103 100644
>>>--- a/arch/x86/boot/header=2ES
>>>+++ b/arch/x86/boot/header=2ES
>>>@@ -332,7 +332,7 @@ initrd_addr_max: =2Elong 0x7fffffff
>>> kernel_alignment:  =2Elong CONFIG_PHYSICAL_ALIGN	#physical addr alignm=
ent
>>> 						#required for protected mode
>>> 						#kernel
>>>-#ifdef CONFIG_RELOCATABLE
>>>+#if defined(CONFIG_RELOCATABLE) || defined(CONFIG_X86_64)
>>> relocatable_kernel:    =2Ebyte 1
>>> #else
>>> relocatable_kernel:    =2Ebyte 0
>>>@@ -342,14 +342,10 @@ min_alignment:		=2Ebyte MIN_KERNEL_ALIGN_LG2	# mi=
nimum alignment
>>> xloadflags:
>>> #ifdef CONFIG_X86_64
>>> # define XLF0 XLF_KERNEL_64			/* 64-bit kernel */
>>>-#else
>>>-# define XLF0 0
>>>-#endif
>>>-
>>>-#if defined(CONFIG_RELOCATABLE) && defined(CONFIG_X86_64)
>>>    /* kernel/boot_param/ramdisk could be loaded above 4g */
>>> # define XLF1 XLF_CAN_BE_LOADED_ABOVE_4G
>>> #else
>>>+# define XLF0 0
>>> # define XLF1 0
>>> #endif
>>>=20
>>
>> Can you clarify what these nebulous future improvements are?
>
>The main improvement today is that CONFIG_RELOCATABLE will be
>only implied by CONFIG_RANDOMIZE_BASE, and so turning that off
>gets rid of the unnecessary relocation metadata=2E
>
>The future improvement is still fgKASLR, which I am implementing
>in the ELF domain, making it arch-agnostic, and applicable to
>other static ELF executables such as hypervisors and statically
>linked user space executables=2E This will hopefully make the
>needed tooling changes more palatable to the wider community=2E
>
>On x86, that will require the use of PIC code for kaslr capable
>kernels, [which surely you remember having discussed with me in
>the past], but only when opting in to kaslr/fgkaslr=2E Otherwise,
>the usual position dependent codegen will be preserved=2E
>
>Note that I have extensive benchmarking data now that shows that
>the PIC change itself has negligible impact for performance, but
>having the option to turn that off if you don't need it is still=20
>appreciated, I assume=2E But let's leave that discussion for when
>I resend that particular series=2E
>

So since you're not going to get people to stop using kASLR, you're now go=
ing a different path to forcing everyone to build with PIC?

I'm going to vote NAK on this one=2E=2E=2E I was already thinking that it =
would mess up low-level debugging too much, but when *handwave handwave fut=
ure improvement* turns into "the thing that has been NAKed several times al=
ready", then=2E=2E=2E

