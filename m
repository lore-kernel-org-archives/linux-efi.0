From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Subject: Re: Boot with EFI stub fails on VMWare during decompression
Date: Wed, 21 Jan 2015 08:09:02 +0100
Message-ID: <20150121080902.6220e9a0@pluto.restena.lu>
References: <20150116110344.715cc887@pluto.restena.lu>
	<20150120190238.GB12079@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150120190238.GB12079-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,

On Tue, 20 Jan 2015 19:02:38 +0000 Matt Fleming wrote:
> On Fri, 16 Jan, at 11:03:44AM, Bruno Pr=C3=A9mont wrote:
> > Register dump:
> > rax            0x1000   4096
> > rbx            0x23f78cb        37714123
> > rcx            0x0      0
> > rdx            0x0      0
> > rsi            0x0      0
> > rdi            0x23f7863        37714019
> > rbp            0x1a363b4        0x1a363b4
> > rsp            0x2404b20        0x2404b20
> > r8             0x2404ee0        37768928
> > r9             0x4      4
> > r10            0x3      3
> > r11            0x9      9
> > r12            0x13dcbbc        20827068
> > r13            0x1e000000       503316480      (this seems to point=
 to decompressed kernel)
>=20
> [...]
> =20
> > while on the failing one I get (just enough efi_printk to cause ker=
nel to boot):
> > [    0.000000] efi: EFI v2.30 by VMware, Inc.
> > [    0.000000] efi:  SMBIOS=3D0x1ffaf000  ACPI 2.0=3D0x1ff9f000=20
> > [    0.000000] efi: mem00: [ACPI Memory NVS    |   |  |  |  |   |WB=
|WT|WC|UC] range=3D[0x0000000000000000-0x0000000000001000) (0MB)
>=20
> [..]
>=20
> > [    0.000000] efi: mem23: [Boot Data          |   |  |  |  |   |WB=
|WT|WC|UC] range=3D[0x000000001dee8000-0x000000001e547000) (6MB)
>=20
> Oops. It sure looks like the EFI boot stub is trashing an EFI boot da=
ta
> region. That would certainly explain the memory corruption you're see=
ing
> (since the firmware assumes no one else is touch its data areas).

Interestingly that part of the memory map has not changed though.

Though I'm wondering why bzImage is (also) being corrupted in mem04.
I've not checked yet how far decompression got (nor if it matches the
start of corruption in bzImage).

> By any chance have you modified CONFIG_PHYSICAL_START in your .config=
?

I've not touched it, so it has default value:
  CONFIG_PHYSICAL_START=3D0x1000000

> The suspect code is probably this from
> arch/x86/boot/compressed/head_64.S:
>=20
> ---
>=20
> 	/*
> 	 * Compute the decompressed kernel start address.  It is where
> 	 * we were loaded at aligned to a 2M boundary. %rbp contains the
> 	 * decompressed kernel start address.
> 	 *
> 	 * If it is a relocatable kernel then decompress and run the kernel
> 	 * from load address aligned to 2MB addr, otherwise decompress and
> 	 * run the kernel from LOAD_PHYSICAL_ADDR
> 	 *
> 	 * We cannot rely on the calculation done in 32-bit mode, since we
> 	 * may have been invoked via the 64-bit entry point.
> 	 */
>=20
> 	/* Start with the delta to where the kernel will run at. */
> #ifdef CONFIG_RELOCATABLE
> 	leaq	startup_32(%rip) /* - $startup_32 */, %rbp
> 	movl	BP_kernel_alignment(%rsi), %eax
> 	decl	%eax
> 	addq	%rax, %rbp
> 	notq	%rax
> 	andq	%rax, %rbp
> 	cmpq	$LOAD_PHYSICAL_ADDR, %rbp
> 	jge	1f
> #endif
> 	movq	$LOAD_PHYSICAL_ADDR, %rbp
> 1:
>=20
> You may want to snoop around this code to make sure that we're not
> making some crazy calculation mistakes wrt where we decompress the
> kernel.

What's the best way to check this?

I could at en endless loop just before that block and replay in gdb
with coredump.

Thanks,
Bruno
