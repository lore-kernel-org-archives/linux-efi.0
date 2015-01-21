From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Subject: Re: Boot with EFI stub fails on VMWare during decompression
Date: Wed, 21 Jan 2015 14:54:20 +0100
Message-ID: <20150121145420.76511d61@pluto.restena.lu>
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
>=20
> By any chance have you modified CONFIG_PHYSICAL_START in your .config=
?

As mentioned in the other mail, it's left at default value:
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

I've put a breakpoint here (hlt-loop) and have following details:

(gdb) info registers
rax            0x0      0
rbx            0x1e53ae18       508800536
rcx            0xffffffff       4294967295
rdx            0x1ded8f98       502108056
rsi            0x1000   4096
rdi            0xffffffff       4294967295
rbp            0x1c003e00       0x1c003e00
rsp            0x1ffd7b68       0x1ffd7b68
r8             0x0      0
r9             0x0      0
r10            0x0      0
r11            0x0      0
r12            0x1ffd7dc8       536706504
r13            0x1ffd7dc0       536706496
r14            0x0      0
r15            0x1ffd7dc0       536706496
rip            0x10002ad        0x10002ad
eflags         0x46     [ PF ZF ]
cs             0x18     24
ss             0x0      0
ds             0x0      0
es             0x0      0
fs             0x0      0
gs             0x0      0
(gdb) disassemble /r 0x10002ac,+64
Dump of assembler code from 0x10002ac to 0x10002ec:
   0x00000000010002ac:  f4      hlt   =20
=3D> 0x00000000010002ad:  eb fd   jmp    0x10002ac
   0x00000000010002af:  48 8d 2d 4a fd ff ff    lea    -0x2b6(%rip),%rb=
p        # 0x1000000
   0x00000000010002b6:  8b 86 30 02 00 00       mov    0x230(%rsi),%eax
   0x00000000010002bc:  ff c8   dec    %eax
   0x00000000010002be:  48 01 c5        add    %rax,%rbp
   0x00000000010002c1:  48 f7 d0        not    %rax
   0x00000000010002c4:  48 21 c5        and    %rax,%rbp
   0x00000000010002c7:  48 81 fd 00 00 00 01    cmp    $0x1000000,%rbp
   0x00000000010002ce:  7d 07   jge    0x10002d7
   0x00000000010002d0:  48 c7 c5 00 00 00 01    mov    $0x1000000,%rbp
   0x00000000010002d7:  48 8d 9d 00 60 a3 00    lea    0xa36000(%rbp),%=
rbx
   0x00000000010002de:  48 8d a3 00 ec 9c 00    lea    0x9cec00(%rbx),%=
rsp
   0x00000000010002e5:  6a 00   pushq  $0x0
   0x00000000010002e7:  9d      popfq =20
   0x00000000010002e8:  56      push   %rsi
   0x00000000010002e9:  48 8d 35 08 29 9c 00    lea    0x9c2908(%rip),%=
rsi        # 0x19c2bf8


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

So the default LOAD_PHYSICAL_ADDR is being selected/used.

This all happens after efi_main() as far as I can understand.
Is there a way to let efi_printk() do string formatting? It should have
both source and destination addresses as it is doing the relocation (or=
 at
least one step of it).

Bruno
