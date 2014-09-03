From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
Date: Wed, 3 Sep 2014 18:59:48 +0100
Message-ID: <20140903175948.GH3001@console-pimps.org>
References: <5405E186.2080406@canonical.com>
 <20140902192941.GB3001@console-pimps.org>
 <CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com>
 <5406D0DB.90401@canonical.com>
 <CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>
 <54073409.6030004@canonical.com>
 <CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 03 Sep, at 05:37:26PM, Ard Biesheuvel wrote:
> 
> Will do, thanks.
> 
> @Matt: so there is two ways to fix this, the patch above addressing
> this single instance, and alternatively, adding a #pragma GCC
> visiblilty push(hidden) to all .c files under libstub/, *before* the
> #includes. The latter would catch future problems regarding newly
> introduced global variables, but it may be a bit overkill in this
> case, as libstub is not expected to be in flux in the foreseeable
> future.
> 
> Any preferences?

Any reason we can't reuse the existing GOT fixup code in the early x86
boot code? We're not executing it before the EFI boot stub atm, which is
the reason Maarten is hitting these difficulties.

Maarten, does the following help?

If not, Ard please go ahead with option #2 above. Overkill yes, but I've
done the single __attribute__() hacks in other projects and someone
(usually me) always eventually forgets to tag some instance.

---

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 2884e0c3e8a5..7618857fcc60 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -32,6 +32,21 @@
 #include <asm/processor-flags.h>
 #include <asm/asm-offsets.h>
 
+/*
+ * Adjust our own GOT
+ */
+.macro FIXUP_GOT
+	leaq	_got(%rip), %rdx
+	leaq	_egot(%rip), %rcx
+1:
+	cmpq	%rcx, %rdx
+	jae	2f
+	addq	%rbx, (%rdx)
+	addq	$8, %rdx
+	jmp	1b
+2:
+.endm
+
 	__HEAD
 	.code32
 ENTRY(startup_32)
@@ -256,6 +271,8 @@ ENTRY(efi_pe_entry)
 	 */
 	addq	%rbp, efi64_config+88(%rip)
 
+	FIXUP_GOT
+
 	movq	%rax, %rdi
 	call	make_boot_params
 	cmpq	$0,%rax
@@ -275,6 +292,7 @@ handover_entry:
 	 */
 	movq	efi_config(%rip), %rax
 	addq	%rbp, 88(%rax)
+	FIXUP_GOT
 2:
 	movq	efi_config(%rip), %rdi
 	call	efi_main
@@ -385,19 +403,8 @@ relocated:
 	shrq	$3, %rcx
 	rep	stosq
 
-/*
- * Adjust our own GOT
- */
-	leaq	_got(%rip), %rdx
-	leaq	_egot(%rip), %rcx
-1:
-	cmpq	%rcx, %rdx
-	jae	2f
-	addq	%rbx, (%rdx)
-	addq	$8, %rdx
-	jmp	1b
-2:
-	
+	FIXUP_GOT
+
 /*
  * Do the decompression, and jump to the new kernel..
  */

-- 
Matt Fleming, Intel Open Source Technology Center
