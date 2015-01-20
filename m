From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: Boot with EFI stub fails on VMWare during decompression
Date: Tue, 20 Jan 2015 19:02:38 +0000
Message-ID: <20150120190238.GB12079@codeblueprint.co.uk>
References: <20150116110344.715cc887@pluto.restena.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150116110344.715cc887-I2t2yFIzmohO7ya8xxV06g@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Cc: linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 16 Jan, at 11:03:44AM, Bruno Pr=E9mont wrote:
> Register dump:
> rax            0x1000   4096
> rbx            0x23f78cb        37714123
> rcx            0x0      0
> rdx            0x0      0
> rsi            0x0      0
> rdi            0x23f7863        37714019
> rbp            0x1a363b4        0x1a363b4
> rsp            0x2404b20        0x2404b20
> r8             0x2404ee0        37768928
> r9             0x4      4
> r10            0x3      3
> r11            0x9      9
> r12            0x13dcbbc        20827068
> r13            0x1e000000       503316480      (this seems to point t=
o decompressed kernel)

[...]
=20
> while on the failing one I get (just enough efi_printk to cause kerne=
l to boot):
> [    0.000000] efi: EFI v2.30 by VMware, Inc.
> [    0.000000] efi:  SMBIOS=3D0x1ffaf000  ACPI 2.0=3D0x1ff9f000=20
> [    0.000000] efi: mem00: [ACPI Memory NVS    |   |  |  |  |   |WB|W=
T|WC|UC] range=3D[0x0000000000000000-0x0000000000001000) (0MB)

[..]

> [    0.000000] efi: mem23: [Boot Data          |   |  |  |  |   |WB|W=
T|WC|UC] range=3D[0x000000001dee8000-0x000000001e547000) (6MB)

Oops. It sure looks like the EFI boot stub is trashing an EFI boot data
region. That would certainly explain the memory corruption you're seein=
g
(since the firmware assumes no one else is touch its data areas).

By any chance have you modified CONFIG_PHYSICAL_START in your .config?

The suspect code is probably this from
arch/x86/boot/compressed/head_64.S:

---

	/*
	 * Compute the decompressed kernel start address.  It is where
	 * we were loaded at aligned to a 2M boundary. %rbp contains the
	 * decompressed kernel start address.
	 *
	 * If it is a relocatable kernel then decompress and run the kernel
	 * from load address aligned to 2MB addr, otherwise decompress and
	 * run the kernel from LOAD_PHYSICAL_ADDR
	 *
	 * We cannot rely on the calculation done in 32-bit mode, since we
	 * may have been invoked via the 64-bit entry point.
	 */

	/* Start with the delta to where the kernel will run at. */
#ifdef CONFIG_RELOCATABLE
	leaq	startup_32(%rip) /* - $startup_32 */, %rbp
	movl	BP_kernel_alignment(%rsi), %eax
	decl	%eax
	addq	%rax, %rbp
	notq	%rax
	andq	%rax, %rbp
	cmpq	$LOAD_PHYSICAL_ADDR, %rbp
	jge	1f
#endif
	movq	$LOAD_PHYSICAL_ADDR, %rbp
1:

You may want to snoop around this code to make sure that we're not
making some crazy calculation mistakes wrt where we decompress the
kernel.

--=20
Matt Fleming, Intel Open Source Technology Center
