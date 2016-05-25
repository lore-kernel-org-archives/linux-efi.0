From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: remove spurious WARN_ON for !4K kernels
Date: Wed, 25 May 2016 20:23:35 +0200
Message-ID: <CAKv+Gu94GLWUJBCtNUDb4Jak3KL0-MGkUfk82fZ5UdwWH60P_w@mail.gmail.com>
References: <1464189116-30898-1-git-send-email-mark.rutland@arm.com>
	<BA565A9C-8CC0-42E4-9821-7941852F835A@linaro.org>
	<20160525161207.GD30956@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160525161207.GD30956@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 25 May 2016 at 18:12, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> On Wed, May 25, 2016 at 05:23:01PM +0200, Ard Biesheuvel wrote:
>>
>>
>> > On 25 mei 2016, at 17:11, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrot=
e:
>> >
>> > Since commit 1fd55a9a09b0293a ("arm64/efi: Apply strict permission=
s to
>> > UEFI Runtime Services regions"), booting a !4K page kernel results=
 in a
>> > boot-time splat on some systems, due to to a WARN_ONCE added in th=
at
>> > commit which fires if the base address of an EFI memory descriptor=
 is
>> > not aligned to the kernel page size (which might be 4K, 16K, or 64=
K).
>> >
>> > On page 38 of the UEFI 2.6 specification it is stated:
>> >
>> >    If a 64KiB physical page contains any 4KiB page with any of the
>> >    following types listed below, then all 4KiB pages in the 64KiB
>> >    page must use identical ARM Memory Page Attributes (as describe=
d
>> >    in Table 8):
>> >    =E2=80=94 EfiRuntimeServicesCode
>> >    =E2=80=94 EfiRuntimeServicesData
>> >    =E2=80=94 EfiReserved
>> >    =E2=80=94 EfiACPIMemoryNVS
>> >    Mixed attribute mappings within a larger page are not allowed.
>> >
>>
>> The same section mentions that the ro/xp etc attributes are unused o=
n
>> arm, so if we go by the letter here, we need to remove those memory
>> protection features entirely. So a spec update is clearly in order
>> here.
>
> Yes; that definitely needs fixing.
>
> FWIW, I don't think that matters in this case (assuming the usual EFI
> memory desc dump stuff prints those).
>
> My memory map (and the remap triggering the WARN_ONCE) look like:
>
> [    0.000000] efi: Getting EFI parameters from FDT:
> [    0.000000] efi:   System Table: 0x00000083ff34bf18
> [    0.000000] efi:   MemMap Address: 0x00000083fcefd618
> [    0.000000] efi:   MemMap Size: 0x00000540
> [    0.000000] efi:   MemMap Desc. Size: 0x00000030
> [    0.000000] efi:   MemMap Desc. Version: 0x00000001
> [    0.000000] efi: EFI v2.40 by American Megatrends
> [    0.000000] efi:  ACPI 2.0=3D0x83ff1c3000  SMBIOS 3.0=3D0x83ff3477=
98
> [    0.000000] efi: Processing EFI memory map:
> [    0.000000] efi:   0x0000e1050000-0x0000e105ffff [Memory Mapped I/=
O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x0000e1300000-0x0000e1300fff [Memory Mapped I/=
O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x0000e8200000-0x0000e827ffff [Memory Mapped I/=
O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x008000000000-0x008001e7ffff [Runtime Data    =
   |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x008001e80000-0x008001ffffff [Conventional Mem=
ory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x008002000000-0x008002ddffff [Loader Data     =
   |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x008002de0000-0x00801fdfffff [Conventional Mem=
ory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x00801fe00000-0x00801fe0ffff [Loader Data     =
   |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x00801fe10000-0x00801fffbfff [Conventional Mem=
ory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x00801fffc000-0x00801fffffff [Boot Data       =
   |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x008020000000-0x0083f0ffffff [Conventional Mem=
ory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0083f1000000-0x0083f101ffff [Boot Data       =
   |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0083f1020000-0x0083fb542fff [Conventional Mem=
ory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0083fb543000-0x0083fc2a2fff [Loader Code     =
   |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0083fc2a3000-0x0083fcefcfff [Conventional Mem=
ory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0083fcefd000-0x0083fcefefff [Loader Data     =
   |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0083fceff000-0x0083fd01afff [Loader Code     =
   |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0083fd01b000-0x0083fea67fff [Boot Data       =
   |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0083fea68000-0x0083febd3fff [Conventional Mem=
ory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0083febd4000-0x0083ff186fff [Boot Code       =
   |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0083ff187000-0x0083ff1b6fff [Reserved        =
   |   |  |  |  |  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0083ff1b7000-0x0083ff1c4fff [ACPI Reclaim Mem=
ory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0083ff1c5000-0x0083ff20ffff [Conventional Mem=
ory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0083ff210000-0x0083ff224fff [Loader Data     =
   |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0083ff225000-0x0083ff226fff [ACPI Memory NVS =
   |   |  |  |  |  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0083ff227000-0x0083ff34bfff [Runtime Data    =
   |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*

OK, so how is this expected to work then, with the regions described
above? Neither are covered by the linear mapping, and both have all of
{WB,WT,WC,UC} set, which means that each region can be mapped by the
OS as any of those types. I don't know which type we use for this
particular ACPI Memory NVS region, but it could be any of those, while
the runtime data regions are mapped as writeback cacheable in the EFI
page tables. So while the spec needs to be updated, I think the de
facto conclusion is that the only way we can do this safely is to
either force 64 KB alignment, or -as a workaround- ensure that regions
that share a 64 KB page frame are limited to the same attributes in
the OS view of the UEFI memory map.


> [    0.000000] efi:   0x0083ff34c000-0x0083ffe42fff [Runtime Code    =
   |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
> [    0.000000] efi:   0x0083ffe43000-0x0083ffffffff [Boot Data       =
   |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> ...
> [    0.079000] Remapping and enabling EFI services.
> [    0.083677]   EFI remap 0x00000000e1050000 =3D> 0000000020000000
> [    0.089551]   EFI remap 0x00000000e1300000 =3D> 0000000020010000
> [    0.095421]   EFI remap 0x00000000e8200000 =3D> 0000000020020000
> [    0.101324]   EFI remap 0x0000008000000000 =3D> 0000000020200000
> [    0.107192] UEFI Runtime regions are not aligned to 64 KB -- buggy=
 firmware?
> [    0.114116] ------------[ cut here ]------------
> [    0.118941] WARNING: CPU: 0 PID: 1 at arch/arm64/kernel/efi.c:34 e=
fi_create_mapping+0x50/0xdc
> [    0.127524] Modules linked in:
> [    0.130592]
> [    0.132083] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.6.0-next-2=
0160525 #6
> [    0.139180] Hardware name: AMD Seattle (Rev.B0) Development Board =
(Overdrive) (DT)
> [    0.146805] task: ffff8003c01e0000 ti: ffff8003c0200000 task.ti: f=
fff8003c0200000
> [    0.154338] PC is at efi_create_mapping+0x50/0xdc
> [    0.159071] LR is at efi_create_mapping+0x50/0xdc
> [    0.163800] pc : [<ffff000008b23f34>] lr : [<ffff000008b23f34>] ps=
tate: 60000245
> [    0.171248] sp : ffff8003c0203d60
> [    0.174579] x29: ffff8003c0203d60 x28: 0000000000000000
> [    0.179925] x27: 0000000000000000 x26: 0000000000000000
> [    0.185269] x25: 0000000000000000 x24: ffff000008ca7be0
> [    0.190616] x23: ffff000008d5b000 x22: ffff000008a76ff8
> [    0.195959] x21: ffff000008c45000 x20: ffff000008ca7be0
> [    0.201303] x19: ffff8003fcefdac8 x18: 0000000000000006
> [    0.206649] x17: 0000000000000007 x16: 0000000000000001
> [    0.211992] x15: ffff000008d15c95 x14: 3f657261776d7269
> [    0.217337] x13: 6620796767756220 x12: 0000000005f5e0ff
> [    0.222683] x11: 206f742064656e67 x10: 000000000001a2b8
> [    0.228026] x9 : ffff8003c0203b60 x8 : 000000000000006c
> [    0.233368] x7 : 2d2d20424b203436 x6 : ffff000008d15cd7
> [    0.238711] x5 : 0000000000000041 x4 : 0000000000000000
> [    0.244055] x3 : 0000000000000000 x2 : 00000000000002e6
> [    0.249439] x1 : ffff8003c0200000 x0 : 0000000000000040
> [    0.254784]
> [    0.256279] ---[ end trace e9947b6ce71b94cd ]---
> [    0.260922] Call trace:
> [    0.263376] Exception stack(0xffff8003c0203ba0 to 0xffff8003c0203c=
c0)
> [    0.269860] 3ba0: ffff8003fcefdac8 ffff000008ca7be0 ffff8003c0203d=
60 ffff000008b23f34
> [    0.277741] 3bc0: ffff8003c0203be0 ffff000008a08ac0 00000000000000=
40 0000000000000001
> [    0.285624] 3be0: ffff8003c0203c80 ffff0000080f42a8 ffff8003fcefda=
c8 ffff000008ca7be0
> [    0.293508] 3c00: ffff000008c45000 ffff000008a76ff8 ffff000008d5b0=
00 ffff000008ca7be0
> [    0.301391] 3c20: 0000000000000000 0000000000000000 00000000000000=
00 0000000000000000
> [    0.309271] 3c40: 0000000000000040 ffff8003c0200000 00000000000002=
e6 0000000000000000
> [    0.317154] 3c60: 0000000000000000 0000000000000041 ffff000008d15c=
d7 2d2d20424b203436
> [    0.325037] 3c80: 000000000000006c ffff8003c0203b60 000000000001a2=
b8 206f742064656e67
> [    0.332922] 3ca0: 0000000005f5e0ff 6620796767756220 3f657261776d72=
69 ffff000008d15c95
> [    0.340805] [<ffff000008b23f34>] efi_create_mapping+0x50/0xdc
> [    0.346651] [<ffff000008b530e8>] arm_enable_runtime_services+0x130=
/0x214
> [    0.353400] [<ffff000008081990>] do_one_initcall+0x38/0x128
> [    0.359009] [<ffff000008b20be4>] kernel_init_freeable+0x84/0x1f0
> [    0.365054] [<ffff0000087a9b58>] kernel_init+0x10/0x100
> [    0.370311] [<ffff000008084ac0>] ret_from_fork+0x10/0x50
> [    0.375661]   EFI remap 0x00000083ff227000 =3D> 0000000022087000
> [    0.381544]   EFI remap 0x00000083ff34c000 =3D> 00000000221ac000
>
> Thanks,
> Mark.
