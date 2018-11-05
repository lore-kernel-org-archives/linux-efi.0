From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [Bug Report] kdump crashes after latest EFI memblock changes on
 arm64 machines with large number of CPUs
Date: Mon, 5 Nov 2018 12:11:03 +0100
Message-ID: <CAKv+Gu_1PNiGbgRqd3_0k6CGzh-2P+iAmqk=oSSek69kBCnb8Q@mail.gmail.com>
References: <CACi5LpOyy0YkhEzWWqt8hAQfKku2Vzp5+da_dGS23JMyHReNew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CACi5LpOyy0YkhEzWWqt8hAQfKku2Vzp5+da_dGS23JMyHReNew@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Bhupesh Sharma <bhsharma@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-efi <linux-efi@vger.kernel.org>, kexec mailing list <kexec@lists.infradead.org>, Will Deacon <will.deacon@arm.com>, Bhupesh SHARMA <bhupesh.linux@gmail.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

(+ Marc)

On 1 November 2018 at 22:14, Bhupesh Sharma <bhsharma@redhat.com> wrote:
> Hi,
>
> With the latest EFI changes for memblock reservation across kdump
> kernel from Ard (Commit 71e0940d52e107748b270213a01d3b1546657d74
> ["efi: honour memory reservations passed via a linux specific config
> table"]), we hit a panic while trying to boot the kdump kernel on
> machines which have large number of CPUs.
>

Just for my understanding: why do you boot all 224 CPus when running
the crash kernel?

I'm not saying we shouldn't fix the underlying issue, I'm just curious.

> I have a arm64 board which has 224 CPUS:
> # lscpu
> <..snip..>
> CPU(s):              224
> On-line CPU(s) list: 0-223
> <..snip..>
>
> Here are the crash logs in the kdump kernel on this machine:
>
> [    0.000000] Unable to handle kernel paging request at virtual
> address ffff80003ffe0000
> val____)nt EL), IL ata abort info:
> [    0.or: Oops: 960000inted 4.18.0+ #3
> [    0.000000] pstate: 20400089 (nzCv daIf +PAN -UAO)
> [    0.000000] pc : __memcpy+0x110/0x180
> [    0.000000] lr : memblock_double_array+0x240/0x348
> [    0.000000] sp : ffff0000092efc80 x28: 00000000bffe0000
> [    0.000000] x27: 0000000000001800 x26: ffff000009d59000
> [    0.000000] x25: ffff80003ffe0000 x24: 0000000000000000
> [    0.000000] x23: 0000000000010000 x22: ffff000009d594e8
> [    0.000000] x21: ffff000009d594f4 x20: ffff0000093c7268
> [    0.000000] x19: 0000000000000c00 x18: 0000000000000010
> [    0.000000] x17: 0000000000000000 x16: 0000000000000000
> [    0.000000] x15: ffffffffffffffff3: 0000000fc18d0000 x12: 0000000800000000
> [    0.000000] x11: 0000000000000018 x10: 00000000ddab9e18
> [    0.000000] x9 : 0000000800000000 x8 : 00000000000002c1
> [    0.000000] x7 : 0000000091b90000 x6 : ffff80003ffe0000
> [    0.000000] x5 : 0000000000000001 x4 : 0000000000000000
> [    0.000000] x3 : 0000000000000000 x2 : 0000000000000b80
> [    0.000000] x1 : ffff000009d59540 x0 : ffff80003ffe0000
> [    0.000000] Process swapper)
> [    0.000000] Call trace:
> [    0.000000]  __memcpy+0x110/0x180
> [    0.000000]  memblock_add_range+0x134/0x2e8
> [    0.000000]  memblock_reserve+0x70/0xb8
> [    0.000000]  memblock_alloc_base_nid+0x6c/0x88
> [    0.000000]  __memblock_alloc_base+0x3c/0x4c
> [    0.000000]  memblock_alloc_base+0x28/0x4c
> [    0.000000]  memblock_alloc+0x2c/0x38
> [    0.000000]  early_pgtable_alloc+0x20/0xb0
> [    0.000000]  paging_init+0x28/0x7f8
> [   0.000000]  start_kernel+0x78/0x4cc
> [    0.000000] Code: a8c12027 a8c12829 a8c1302b a8c1382d (a88120c7)
> [    0.000000] random: get_random_bytes called from
> print_oops_end_marker+0x30/0x58 with crng_init=0
> [    0.000000] ---[ end trace 0000000000000000 ]---
> [    0.000000] Kernel panic - not syncing: Fatal exception
> [    0.000000] ---[ end Kernel panic - not syncing: Fatal exception ]---
>
> Adding more debug logs via 'memblock=debug' being passed to the kdump
> kernel, (and adding a few more prints to 'mm/memblock.c'), I can see
> that the panic happens while trying to resize array inside
> 'memblock_double_array' (which doubles the size of the memblock
> regions array):
>
> [    0.000000] Reserving 13KB of memory at 0xbfff0000 for elfcorehdr
> [    0.000000] memblock_reserve:
> [0x00000000bfff0000-0x00000000bfffffff]
> memblock_alloc_base_nid+0x6c/0x88
> [    0.000000] memblock: use_slab is 0, new_area_start=bfff0000,
> new_area_size=10000
> [    0.000000] memblock: use_slab is 0, addr=0, new_area_size=10000
> [    0.000000] memblock: addr=bffe0000, __va(addr)=ffff80003ffe0000
> [    0.00000 [0xbffe0000-0xbffe17ff]
> [    0.000000] Unable to handle kernel paging request at virtual
> address ffff80003ffe0000
>
> which indicates that after Ard's patch the memblocks being reserved
> across kdump swell up on systems which have large number of CPUs and
> hence 'memblock_double_array' is called up in early kdump boot code to
> double the size of the memblock regions array.
>
> To confirm the above, I reduced the number of SMP CPUs available to
> the kernel on this system, by specifying 'nr_cpus=46' in the kernel
> bootargs for the primary kernel. As expected this makes the kdump
> kernel boot successfully and also save the crash dump properly.
>
> I saw another arm64 kdump user report this issue to me privately, so I
> am sending this to a wider audience, so that kdump users are aware
> that this is a known issue.
>
> I am working on a RFC patch which seems to fix the issue on my board
> and will try to send it out for wider review in coming days after some
> more checks at my end.
>
> Any advices on the same are also welcome :)
>
> Thanks,
> Bhupesh
