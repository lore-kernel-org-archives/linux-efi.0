From: Bhupesh Sharma <bhsharma@redhat.com>
Subject: Re: [PATCH v2 0/6] arm/efi: fix memblock reallocation crash due to
 persistent reservations
Date: Fri, 9 Nov 2018 00:43:04 +0530
Message-ID: <CACi5LpPWo6wjOLdXP1ZO1scdbyyus6_D6C+gdg6YjUszsiaMaA@mail.gmail.com>
References: <20181107141611.12076-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20181107141611.12076-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-efi@vger.kernel.org, Will Deacon <will.deacon@arm.com>, linux@armlinux.org.uk, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On Wed, Nov 7, 2018 at 7:46 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> This series addresses the kexec/kdump crash on arm64 system with many CPUs
> that was reported by Bhupesh.
>
> Patch #1 fixes the actual crash, but may result in memblock_reserve() to
> fail. This is fixed in patch #4, where the point that the persistent
> reservations are applied is moved to after memblock_allow_resize() has
> been called.
>
> Patches #2 and #3 contain some minor preparatory changes that are
> required on ARM to ensure that efi_apply_persistent_mem_reservations()
> can be called at some point (i.e., when memblock resizing is already
> permitted and early memremap() is still usable)
>
> Patches #5 and #6 optimize the EFI persistent memreserve infrastructure
> so that fewer memblock reservations are required.
>
> Changes since v1:
> - Russell pointed out that switching to ordinary memremap() was not
>   possible this early, and so I refactored the ARM early boot code
>   slightly so that we can keep using early_memremap().
>
> Ard Biesheuvel (6):
>   arm64: memblock: don't permit memblock resizing until linear mapping
>     is up
>   ARM: mm: permit memblock resizing right after mapping the linear
>     region
>   ARM: mm: permit early_memremap() to be used in paging_init()
>   efi/arm: defer persistent reservations until after paging_init()
>   efi: permit multiple entries in persistent memreserve data structure
>   efi: reduce the amount of memblock reservations for persistent
>     allocations
>
>  arch/arm/kernel/setup.c                 |  2 -
>  arch/arm/mm/init.c                      |  1 -
>  arch/arm/mm/mmu.c                       |  5 ++
>  arch/arm64/kernel/setup.c               |  1 +
>  arch/arm64/mm/init.c                    |  2 -
>  arch/arm64/mm/mmu.c                     |  2 +
>  drivers/firmware/efi/efi.c              | 59 ++++++++++++++------
>  drivers/firmware/efi/libstub/arm-stub.c |  2 +-
>  include/linux/efi.h                     | 23 +++++++-
>  9 files changed, 72 insertions(+), 25 deletions(-)
>
> --
> 2.19.1
>

I did some quick checks (as I just returned from my holidays and got
hold of the hardware just now) and I haven't had the opportunity to
look closely at the entire patch set, but it looks like a step in the
right direction especially as we try to have fewer memblock
reservations (I will have a closer look at the patchset perhaps over
the weekend).

I tested this on the hardware (with 224 CPUs) where I was seeing the
crash initially and kdump seems to work fine on the same. Here are
some kdump kernel logs with 'memblock=debug' set in bootargs:

[    0.000000] memblock_reserve:
[0x00000000e2e02e18-0x00000000e2e02e4f] efi_mem_reserve+0x3c/0x54
[    0.000000] memblock_reserve:
[0x00000000dac70000-0x00000000dac7ffff] efi_init+0xc4/0x17c
[    0.000000] memblock_remove:
[0x0001000000000000-0x0000fffffffffffe] arm64_memblock_init+0x6c/0x418
[    0.000000] memblock_remove:
[0x0000800080000000-0x000080007ffffffe] arm64_memblock_init+0xac/0x418
[    0.0001dd0000-0x00000000a2cfffff] arm64_memblock_init+0x184/0x418
[    0.000000] memblock_add: [0x00000000a1dd0000-0x00000000a2cfffff]
arm64_memblock_init+0x190/0x418
[    0.000000] memblock_reserve:
[0x00000000a1dd0000-0x00000000a2cfffff]
arm64_memblock_init+0x19c/0x418
[    0.000000] memblock_reserve:
[0x00000000a0080000-0x00000000a1dcffff]
arm64_memblock_init+0x1f8/0x418
[    0.000000] memblock_reserve:
[0x00000000a1dd0000-0x00000000a2cfb402]     0.000000]
memblock_reserve: [0x00000000bfff0000-0x00000000bfff33ff]
arm64_memblock_init+0x3b4/0x418
[    0.000000] Reserving 13KB of memory at 0xbfff0000 for elfcorehdr
[    0.000000] memblock_reserve:
[0x00000000bffe0000-0x00000000bffeffff]
memblock_alloc_base_nid+0x70/0x8c
[    0.000000] memblock_reserve:
[0x00000000bffd0000-0x00000000bffdffff]
memblock_alloc_base_nid+0x70/0x8c
[    0.000000] memblock_reserve: [0x00000000bffc0se_nid+0x70/0x8c
[    0.000000] memblock_reserve:
[0x00000000bffb0000-0x00000000bffbffff]
memblock_alloc_base_nid+0x70/0x8c
[    0.000000]    memblock_free:
[0x00000000a1d80000-0x00000000a1dcffff] paging_init+0x6d4/0x6fc
[    0.000000] memblock_reserve:
[0x00000000ddab9e18-0x00000000ddab9e27]
efi_apply_persistent_mem_reservations+0x8c/0xbc

So, things look great so far. So, please feel free to add:
Tested-by: Bhupesh Sharma <bhsharma@redhat.com>

Thanks,
Bhupesh
