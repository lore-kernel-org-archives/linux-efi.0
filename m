From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Subject: Boot with EFI stub fails on VMWare during decompression
Date: Fri, 16 Jan 2015 11:03:44 +0100
Message-ID: <20150116110344.715cc887@pluto.restena.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

I have a few systems that don't boot on some VMWare nodes using EFI stub.

Kernel boots on VMWare ESXi 5.1 but has trouble on ESXi 5.5.

>From behavior it seems very much related to memory layout as just
adding a few efi_printk() into EFI stub gets the otherwise same kernel
to boot. Also the kernel does boot on another VMWare node.

Kernel I'm using: 3.18.2

I've take a snapshot that i converted to core dump. Poking at it with
gdb it looks like kernel gets stuck in misc.o somewhere during zlib
decompression.


Register dump:
rax            0x1000   4096
rbx            0x23f78cb        37714123
rcx            0x0      0
rdx            0x0      0
rsi            0x0      0
rdi            0x23f7863        37714019
rbp            0x1a363b4        0x1a363b4
rsp            0x2404b20        0x2404b20
r8             0x2404ee0        37768928
r9             0x4      4
r10            0x3      3
r11            0x9      9
r12            0x13dcbbc        20827068
r13            0x1e000000       503316480      (this seems to point to decompressed kernel)
r14            0x9b8ea7 10194599
r15            0x23f8bc0        37718976
rip            0x23f21f9        0x23f21f9
eflags         0x46     [ PF ZF ]
cs             0x18     24
ss             0x0      0
ds             0x0      0
es             0x0      0
fs             0x0      0
gs             0x0      0


Code disassembly:
Dump of assembler code from 0x23f21d0 to 0x23f22f8:
   0x00000000023f21d0:  53      push   %rbx
   0x00000000023f21d1:  48 89 fb        mov    %rdi,%rbx
   0x00000000023f21d4:  48 8d 3d 85 56 00 00    lea    0x5685(%rip),%rdi        # 0x23f7860
   0x00000000023f21db:  e8 50 fe ff ff  callq  0x23f2030
   0x00000000023f21e0:  48 89 df        mov    %rbx,%rdi
   0x00000000023f21e3:  e8 48 fe ff ff  callq  0x23f2030
   0x00000000023f21e8:  48 8d 3d 74 56 00 00    lea    0x5674(%rip),%rdi        # 0x23f7863
   0x00000000023f21ef:  e8 3c fe ff ff  callq  0x23f2030
   0x00000000023f21f4:  0f 1f 40 00     nopl   0x0(%rax)
   0x00000000023f21f8:  f4      hlt    
=> 0x00000000023f21f9:  eb fd   jmp    0x23f21f8
   0x00000000023f21fb:  0f 1f 44 00 00  nopl   0x0(%rax,%rax,1)
   0x00000000023f2200:  41 57   push   %r15
   0x00000000023f2202:  4d 89 c7        mov    %r8,%r15
   0x00000000023f2205:  41 56   push   %r14
   0x00000000023f2207:  49 89 ce        mov    %rcx,%r14
   0x00000000023f220a:  41 55   push   %r13
   0x00000000023f220c:  49 89 fd        mov    %rdi,%r13
   0x00000000023f220f:  41 54   push   %r12
   0x00000000023f2211:  4d 89 cc        mov    %r9,%r12
   0x00000000023f2214:  55      push   %rbp
   0x00000000023f2215:  48 89 d5        mov    %rdx,%rbp
   0x00000000023f2218:  53      push   %rbx
   0x00000000023f2219:  48 89 f3        mov    %rsi,%rbx
   0x00000000023f221c:  48 83 ec 48     sub    $0x48,%rsp
   0x00000000023f2220:  80 bf ef 01 00 00 00    cmpb   $0x0,0x1ef(%rdi)
   0x00000000023f2227:  48 8b 05 8a 68 00 00    mov    0x688a(%rip),%rax        # 0x23f8ab8
   0x00000000023f222e:  48 89 38        mov    %rdi,(%rax)
   0x00000000023f2231:  74 69   je     0x23f229c
   0x00000000023f2233:  48 8d bf c0 00 00 00    lea    0xc0(%rdi),%rdi
   0x00000000023f223a:  ba 00 01 00 00  mov    $0x100,%edx
   0x00000000023f223f:  31 f6   xor    %esi,%esi
   0x00000000023f2241:  e8 0a 08 00 00  callq  0x23f2a50
   0x00000000023f2246:  49 8d bd eb 01 00 00    lea    0x1eb(%r13),%rdi
   0x00000000023f224d:  ba 06 00 00 00  mov    $0x6,%edx
   0x00000000023f2252:  31 f6   xor    %esi,%esi
   0x00000000023f2254:  e8 f7 07 00 00  callq  0x23f2a50
   0x00000000023f2259:  49 8d bd 68 02 00 00    lea    0x268(%r13),%rdi
   0x00000000023f2260:  ba 28 00 00 00  mov    $0x28,%edx
   0x00000000023f2265:  31 f6   xor    %esi,%esi
   0x00000000023f2267:  e8 e4 07 00 00  callq  0x23f2a50
   0x00000000023f226c:  49 8d bd d0 0c 00 00    lea    0xcd0(%r13),%rdi
   0x00000000023f2273:  ba 30 00 00 00  mov    $0x30,%edx
   0x00000000023f2278:  31 f6   xor    %esi,%esi
   0x00000000023f227a:  e8 d1 07 00 00  callq  0x23f2a50
   0x00000000023f227f:  49 8d bd ec 0e 00 00    lea    0xeec(%r13),%rdi
   0x00000000023f2286:  ba 14 01 00 00  mov    $0x114,%edx
   0x00000000023f228b:  31 f6   xor    %esi,%esi
   0x00000000023f228d:  e8 be 07 00 00  callq  0x23f2a50
   0x00000000023f2292:  48 8b 05 1f 68 00 00    mov    0x681f(%rip),%rax        # 0x23f8ab8
   0x00000000023f2299:  4c 8b 28        mov    (%rax),%r13
   0x00000000023f229c:  41 80 7d 06 07  cmpb   $0x7,0x6(%r13)
   0x00000000023f22a1:  0f 84 69 01 00 00       je     0x23f2410
   0x00000000023f22a7:  48 c7 05 2e 29 01 00 00 80 0b 00        movq   $0xb8000,0x1292e(%rip)        # 0x2404be0
   0x00000000023f22b2:  c7 05 1c 29 01 00 d4 03 00 00   movl   $0x3d4,0x1291c(%rip)        # 0x2404bd8
   0x00000000023f22bc:  41 0f b6 45 0e  movzbl 0xe(%r13),%eax
   0x00000000023f22c1:  89 05 0d 29 01 00       mov    %eax,0x1290d(%rip)        # 0x2404bd4
   0x00000000023f22c7:  41 0f b6 45 07  movzbl 0x7(%r13),%eax
   0x00000000023f22cc:  89 05 fe 28 01 00       mov    %eax,0x128fe(%rip)        # 0x2404bd0
   0x00000000023f22d2:  e8 b9 0b 00 00  callq  0x23f2e90
   0x00000000023f22d7:  48 8d 3d 9a 56 00 00    lea    0x569a(%rip),%rdi        # 0x23f7978
   0x00000000023f22de:  e8 4d fd ff ff  callq  0x23f2030
   0x00000000023f22e3:  48 8b 05 de 67 00 00    mov    0x67de(%rip),%rax        # 0x23f8ac8
   0x00000000023f22ea:  4c 39 a4 24 80 00 00 00 cmp    %r12,0x80(%rsp)
   0x00000000023f22f2:  4c 89 e1        mov    %r12,%rcx
   0x00000000023f22f5:  48 0f 43 8c 24 80 00 00 00      cmovae 0x80(%rsp),%rcx

Objdump of arch/x86/boot/compressed/misc.o:
0000000000002de0 <error>:
    2de0:       53                      push   %rbx
    2de1:       48 89 fb                mov    %rdi,%rbx
    2de4:       48 8d 3d 00 00 00 00    lea    0x0(%rip),%rdi        # 2deb <zlib_updatewindow+0x2d7b>
    2deb:       e8 00 00 00 00          callq  2df0 <zlib_updatewindow+0x2d80>
    2df0:       48 89 df                mov    %rbx,%rdi
    2df3:       e8 00 00 00 00          callq  2df8 <zlib_updatewindow+0x2d88>
    2df8:       48 8d 3d 00 00 00 00    lea    0x0(%rip),%rdi        # 2dff <zlib_updatewindow+0x2d8f>
    2dff:       e8 00 00 00 00          callq  2e04 <zlib_updatewindow+0x2d94>
    2e04:       0f 1f 40 00             nopl   0x0(%rax)
    2e08:       f4                      hlt    
=>  2e09:       eb fd                   jmp    2e08 <zlib_updatewindow+0x2d98>
    2e0b:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)

0000000000002e10 <decompress_kernel>:
    2e10:       41 57                   push   %r15
    2e12:       4d 89 c7                mov    %r8,%r15
    2e15:       41 56                   push   %r14
    2e17:       49 89 ce                mov    %rcx,%r14
    2e1a:       41 55                   push   %r13
    2e1c:       49 89 fd                mov    %rdi,%r13
    2e1f:       41 54                   push   %r12
    2e21:       4d 89 cc                mov    %r9,%r12
    2e24:       55                      push   %rbp
    2e25:       48 89 d5                mov    %rdx,%rbp
    2e28:       53                      push   %rbx
    2e29:       48 89 f3                mov    %rsi,%rbx
    2e2c:       48 83 ec 48             sub    $0x48,%rsp
    2e30:       80 bf ef 01 00 00 00    cmpb   $0x0,0x1ef(%rdi)
    2e37:       48 8b 05 00 00 00 00    mov    0x0(%rip),%rax        # 2e3e <zlib_updatewindow+0x2dce>


Possibly of interest, on the VMWare node where the kernel boots I get this memory mapping:
[    0.000000] efi: EFI v2.30 by VMware, Inc.
[    0.000000] efi:  SMBIOS=0x1ffa8000  ACPI 2.0=0x1ff99000 
[    0.000000] efi: mem00: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000001000) (0MB)
[    0.000000] efi: mem01: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000001000-0x0000000000007000) (0MB)
[    0.000000] efi: mem02: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000007000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem03: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem04: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000001000000-0x000000000240b000) (20MB)
[    0.000000] efi: mem05: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000240b000-0x000000001b1bc000) (397MB)
[    0.000000] efi: mem06: [Loader Code        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001b1bc000-0x000000001d5c7000) (36MB)
[    0.000000] efi: mem07: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001d5c7000-0x000000001df83000) (9MB)
[    0.000000] efi: mem08: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001df83000-0x000000001df8e000) (0MB)
[    0.000000] efi: mem09: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001df8e000-0x000000001dfaf000) (0MB)
[    0.000000] efi: mem10: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dfaf000-0x000000001dfb2000) (0MB)
[    0.000000] efi: mem11: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dfb2000-0x000000001dfc4000) (0MB)
[    0.000000] efi: mem12: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dfc4000-0x000000001dfc5000) (0MB)
[    0.000000] efi: mem13: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dfc5000-0x000000001e61a000) (6MB)
[    0.000000] efi: mem14: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e61a000-0x000000001e6d8000) (0MB)
[    0.000000] efi: mem15: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e6d8000-0x000000001e6e7000) (0MB)
[    0.000000] efi: mem16: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e6e7000-0x000000001e6ed000) (0MB)
[    0.000000] efi: mem17: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e6ed000-0x000000001e6ee000) (0MB)
[    0.000000] efi: mem18: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e6ee000-0x000000001e71b000) (0MB)
[    0.000000] efi: mem19: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e71b000-0x000000001e71e000) (0MB)
[    0.000000] efi: mem20: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e71e000-0x000000001e724000) (0MB)
[    0.000000] efi: mem21: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e724000-0x000000001e725000) (0MB)
[    0.000000] efi: mem22: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e725000-0x000000001e729000) (0MB)
[    0.000000] efi: mem23: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e729000-0x000000001e72a000) (0MB)
[    0.000000] efi: mem24: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e72a000-0x000000001e751000) (0MB)
[    0.000000] efi: mem25: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e751000-0x000000001e754000) (0MB)
[    0.000000] efi: mem26: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e754000-0x000000001e755000) (0MB)
[    0.000000] efi: mem27: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e755000-0x000000001e756000) (0MB)
[    0.000000] efi: mem28: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e756000-0x000000001e75e000) (0MB)
[    0.000000] efi: mem29: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e75e000-0x000000001e760000) (0MB)
[    0.000000] efi: mem30: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e760000-0x000000001e76f000) (0MB)
[    0.000000] efi: mem31: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e76f000-0x000000001ee83000) (7MB)
[    0.000000] efi: mem32: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001ee83000-0x000000001ee8c000) (0MB)
[    0.000000] efi: mem33: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001ee8c000-0x000000001fe30000) (15MB)
[    0.000000] efi: mem34: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001fe30000-0x000000001fe43000) (0MB)
[    0.000000] efi: mem35: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x000000001fe43000-0x000000001fe48000) (0MB)
[    0.000000] efi: mem36: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001fe48000-0x000000001ff20000) (0MB)
[    0.000000] efi: mem37: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x000000001ff20000-0x000000001ff40000) (0MB)
[    0.000000] efi: mem38: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x000000001ff40000-0x000000001ff8a000) (0MB)
[    0.000000] efi: mem39: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x000000001ff8a000-0x000000001ff90000) (0MB)
[    0.000000] efi: mem40: [ACPI Reclaim Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001ff90000-0x000000001ff99000) (0MB)
[    0.000000] efi: mem41: [ACPI Reclaim Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001ff99000-0x000000001ffa8000) (0MB)
[    0.000000] efi: mem42: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001ffa8000-0x000000001ffaa000) (0MB)
[    0.000000] efi: mem43: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001ffaa000-0x000000001ffaf000) (0MB)
[    0.000000] efi: mem44: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001ffaf000-0x000000001ffb0000) (0MB)
[    0.000000] efi: mem45: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001ffb0000-0x0000000020000000) (0MB)
[    0.000000] efi: mem46: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |  ] range=[0x00000000ffc00000-0x00000000ffc18000) (0MB)
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: VMware, Inc. VMware7,1/440BX Desktop Reference Platform, BIOS VMW71.00V.0.B64.1309111724 09/11/2013

while on the failing one I get (just enough efi_printk to cause kernel to boot):
[    0.000000] efi: EFI v2.30 by VMware, Inc.
[    0.000000] efi:  SMBIOS=0x1ffaf000  ACPI 2.0=0x1ff9f000 
[    0.000000] efi: mem00: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000001000) (0MB)
[    0.000000] efi: mem01: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000001000-0x0000000000007000) (0MB)
[    0.000000] efi: mem02: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000007000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem03: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem04: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000001000000-0x000000000240b000) (20MB)
[    0.000000] efi: mem05: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000240b000-0x000000001ae96000) (394MB)
[    0.000000] efi: mem06: [Loader Code        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001ae96000-0x000000001d2a1000) (36MB)
[    0.000000] efi: mem07: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001d2a1000-0x000000001dc68000) (9MB)
[    0.000000] efi: mem08: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dc68000-0x000000001dcb3000) (0MB)
[    0.000000] efi: mem09: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dcb3000-0x000000001dcdb000) (0MB)
[    0.000000] efi: mem10: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dcdb000-0x000000001dce9000) (0MB)
[    0.000000] efi: mem11: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dce9000-0x000000001dcea000) (0MB)
[    0.000000] efi: mem12: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dcea000-0x000000001dcec000) (0MB)
[    0.000000] efi: mem13: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dcec000-0x000000001dcfb000) (0MB)
[    0.000000] efi: mem14: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dcfb000-0x000000001dcfc000) (0MB)
[    0.000000] efi: mem15: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dcfc000-0x000000001dcfd000) (0MB)
[    0.000000] efi: mem16: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dcfd000-0x000000001dcfe000) (0MB)
[    0.000000] efi: mem17: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dcfe000-0x000000001ddd8000) (0MB)
[    0.000000] efi: mem18: [Loader Code        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001ddd8000-0x000000001deb0000) (0MB)
[    0.000000] efi: mem19: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001deb0000-0x000000001decf000) (0MB)
[    0.000000] efi: mem20: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001decf000-0x000000001dee0000) (0MB)
[    0.000000] efi: mem21: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dee0000-0x000000001dee6000) (0MB)
[    0.000000] efi: mem22: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dee6000-0x000000001dee8000) (0MB)
[    0.000000] efi: mem23: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001dee8000-0x000000001e547000) (6MB)
[    0.000000] efi: mem24: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e547000-0x000000001e58b000) (0MB)
[    0.000000] efi: mem25: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e58b000-0x000000001e58c000) (0MB)
[    0.000000] efi: mem26: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e58c000-0x000000001e590000) (0MB)
[    0.000000] efi: mem27: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e590000-0x000000001e591000) (0MB)
[    0.000000] efi: mem28: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e591000-0x000000001e5a0000) (0MB)
[    0.000000] efi: mem29: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e5a0000-0x000000001e5a2000) (0MB)
[    0.000000] efi: mem30: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e5a2000-0x000000001e602000) (0MB)
[    0.000000] efi: mem31: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e602000-0x000000001e604000) (0MB)
[    0.000000] efi: mem32: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e604000-0x000000001e613000) (0MB)
[    0.000000] efi: mem33: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e613000-0x000000001e614000) (0MB)
[    0.000000] efi: mem34: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e614000-0x000000001e645000) (0MB)
[    0.000000] efi: mem35: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e645000-0x000000001e648000) (0MB)
[    0.000000] efi: mem36: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e648000-0x000000001e64f000) (0MB)
[    0.000000] efi: mem37: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e64f000-0x000000001e651000) (0MB)
[    0.000000] efi: mem38: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e651000-0x000000001e656000) (0MB)
[    0.000000] efi: mem39: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e656000-0x000000001e657000) (0MB)
[    0.000000] efi: mem40: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e657000-0x000000001e66c000) (0MB)
[    0.000000] efi: mem41: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e66c000-0x000000001e66d000) (0MB)
[    0.000000] efi: mem42: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e66d000-0x000000001e69c000) (0MB)
[    0.000000] efi: mem43: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e69c000-0x000000001e6a2000) (0MB)
[    0.000000] efi: mem44: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e6a2000-0x000000001e6ad000) (0MB)
[    0.000000] efi: mem45: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e6ad000-0x000000001e9b3000) (3MB)
[    0.000000] efi: mem46: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e9b3000-0x000000001e9c2000) (0MB)
[    0.000000] efi: mem47: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001e9c2000-0x000000001edd3000) (4MB)
[    0.000000] efi: mem48: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001edd3000-0x000000001eddc000) (0MB)
[    0.000000] efi: mem49: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001eddc000-0x000000001fe31000) (16MB)
[    0.000000] efi: mem50: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001fe31000-0x000000001fe33000) (0MB)
[    0.000000] efi: mem51: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001fe33000-0x000000001fe3c000) (0MB)
[    0.000000] efi: mem52: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x000000001fe3c000-0x000000001fe44000) (0MB)
[    0.000000] efi: mem53: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001fe44000-0x000000001ff21000) (0MB)
[    0.000000] efi: mem54: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x000000001ff21000-0x000000001ff41000) (0MB)
[    0.000000] efi: mem55: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x000000001ff41000-0x000000001ff8b000) (0MB)
[    0.000000] efi: mem56: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x000000001ff8b000-0x000000001ff91000) (0MB)
[    0.000000] efi: mem57: [ACPI Reclaim Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001ff91000-0x000000001ff9f000) (0MB)
[    0.000000] efi: mem58: [ACPI Reclaim Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001ff9f000-0x000000001ffad000) (0MB)
[    0.000000] efi: mem59: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001ffad000-0x000000001ffae000) (0MB)
[    0.000000] efi: mem60: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001ffae000-0x000000001ffb1000) (0MB)
[    0.000000] efi: mem61: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000001ffb1000-0x0000000020000000) (0MB)
[    0.000000] efi: mem62: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |  ] range=[0x00000000ffc00000-0x00000000ffc18000) (0MB)
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: VMware, Inc. VMware7,1/440BX Desktop Reference Platform, BIOS VMW71.00V.0.B64.1404140612 04/14/2014

Size of bzImage: 10250672
Size of vmlinus: 28188076
Big size is due to included initrd.

Any idea where to search further or how to gather some more useful data with GDB?

Thanks,
Bruno
