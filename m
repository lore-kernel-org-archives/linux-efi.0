From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 3/3] x86, efi: Add "efi_fake_mem_mirror" boot option
Date: Wed, 9 Sep 2015 14:51:41 +0100
Message-ID: <20150909135141.GH4973@codeblueprint.co.uk>
References: <1440609031-14695-1-git-send-email-izumi.taku@jp.fujitsu.com>
 <1440609097-14836-1-git-send-email-izumi.taku@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1440609097-14836-1-git-send-email-izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 27 Aug, at 02:11:37AM, Taku Izumi wrote:
> This patch introduces new boot option named "efi_fake_mem_mirror".
> By specifying this parameter, you can mark specific memory as
> mirrored memory. This is useful for debugging of Address Range
> Mirroring feature.
> 
> For example, if you specify "efi_fake_mem_mirror=2G@4G,2G@0x10a0000000",
> the original (firmware provided) EFI memmap will be updated so that
> the specified memory regions have EFI_MEMORY_MORE_RELIABLE attribute:
> 
>  <original EFI memmap>
>    efi: mem00: [Boot Data          |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000001000) (0MB)
>    efi: mem01: [Loader Data        |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000001000-0x0000000000002000) (0MB)
>    ...
>    efi: mem35: [Boot Data          |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000047ee6000-0x0000000048014000) (1MB)
>    efi: mem36: [Conventional Memory|  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x00000020a0000000) (129536MB)
>    efi: mem37: [Reserved           |RT|  |  |  |  |   |  |  |  |UC] range=[0x0000000060000000-0x0000000090000000) (768MB)
> 
>  <updated EFI memmap>
>    efi: mem00: [Boot Data          |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000001000) (0MB)
>    efi: mem01: [Loader Data        |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000001000-0x0000000000002000) (0MB)
>    ...
>    efi: mem35: [Boot Data          |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000047ee6000-0x0000000048014000) (1MB)
>    efi: mem36: [Conventional Memory|  |MR|  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x0000000180000000) (2048MB)
>    efi: mem37: [Conventional Memory|  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000180000000-0x00000010a0000000) (61952MB)
>    efi: mem38: [Conventional Memory|  |MR|  |  |  |   |WB|WT|WC|UC] range=[0x00000010a0000000-0x0000001120000000) (2048MB)
>    efi: mem39: [Conventional Memory|  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000001120000000-0x00000020a0000000) (63488MB)
>    efi: mem40: [Reserved           |RT|  |  |  |  |   |  |  |  |UC] range=[0x0000000060000000-0x0000000090000000) (768MB)
> 
> And you will find that the following message is output:
> 
>    efi: Memory: 4096M/131455M mirrored memory
> 
> Signed-off-by: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> ---
>  Documentation/kernel-parameters.txt |   8 ++
>  arch/x86/include/asm/efi.h          |   1 +
>  arch/x86/kernel/setup.c             |   4 +-
>  arch/x86/platform/efi/efi.c         |   2 +-
>  drivers/firmware/efi/Kconfig        |  12 +++
>  drivers/firmware/efi/Makefile       |   1 +
>  drivers/firmware/efi/fake_mem.c     | 204 ++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h                 |   6 ++
>  8 files changed, 236 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/firmware/efi/fake_mem.c

[...]

> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index e4308fe..eee8068 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -222,7 +222,7 @@ int __init efi_memblock_x86_reserve_range(void)
>  	return 0;
>  }
>  
> -static void __init print_efi_memmap(void)
> +void __init print_efi_memmap(void)
>  {
>  #ifdef EFI_DEBUG
>  	efi_memory_desc_t *md;

If we're going to make this function global we should stick to the
existing naming convention and rename it efi_print_memmap() in a
separate patch.

> diff --git a/drivers/firmware/efi/fake_mem.c b/drivers/firmware/efi/fake_mem.c
> new file mode 100644
> index 0000000..2645d4a
> --- /dev/null
> +++ b/drivers/firmware/efi/fake_mem.c
> @@ -0,0 +1,204 @@
> +/*
> + * fake_mem.c
> + *
> + * Copyright (C) 2015 FUJITSU LIMITED
> + * Author: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> + *
> + * This code introduces new boot option named "efi_fake_mem_mirror"
> + * By specifying this parameter, you can mark specific memory as
> + * mirrored memory by updating original (firmware provided) EFI
> + * memmap.
> + *
> + *  This program is free software; you can redistribute it and/or modify it
> + *  under the terms and conditions of the GNU General Public License,
> + *  version 2, as published by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope it will be useful, but WITHOUT
> + *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + *  more details.
> + *
> + *  You should have received a copy of the GNU General Public License along with
> + *  this program; if not, see <http://www.gnu.org/licenses/>.
> + *
> + *  The full GNU General Public License is included in this distribution in
> + *  the file called "COPYING".
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/efi.h>
> +#include <linux/init.h>
> +#include <linux/memblock.h>
> +#include <linux/types.h>
> +#include <asm/efi.h>
> +
> +#define EFI_MAX_FAKE_MIRROR 8
> +static struct range fake_mirrors[EFI_MAX_FAKE_MIRROR];

Should we make this a Kconfig option? Is there any reason that 8 has
to be the absolute maximum?

> +static int num_fake_mirror;
> +
> +void __init efi_fake_memmap(void)
> +{
> +	u64 start, end, m_start, m_end;
> +	int new_nr_map = memmap.nr_map;
> +	efi_memory_desc_t *md;
> +	u64 new_memmap_phy;
> +	void *new_memmap;
> +	void *old, *new;
> +	int i;
> +
> +	if (!num_fake_mirror)
> +		return;
> +

You probably also want to check that efi_enabled(EFI_MEMMAP) is true
here, if not, you shouldn't iterate over the EFI memory map.

> +	/* count up the number of EFI memory descriptor */
> +	for (old = memmap.map; old < memmap.map_end; old += memmap.desc_size) {
> +		md = old;
> +		start = md->phys_addr;
> +		end = start + (md->num_pages << EFI_PAGE_SHIFT) - 1;
> +
> +		for (i = 0; i < num_fake_mirror; i++) {
> +			/* mirroring range */
> +			m_start = fake_mirrors[i].start;
> +			m_end = fake_mirrors[i].end;
> +
> +			if (m_start <= start) {
> +				/* split into 2 parts */
> +				if (start < m_end && m_end < end)
> +					new_nr_map++;
> +			}
> +			if (start < m_start && m_start < end) {
> +				/* split into 3 parts */
> +				if (m_end < end)
> +					new_nr_map += 2;
> +				/* split into 2 parts */
> +				if (end <= m_end)
> +					new_nr_map++;
> +			}
> +		}
> +	}
> +
> +	/* allocate memory for new EFI memmap */
> +	new_memmap_phy = memblock_alloc(memmap.desc_size * new_nr_map,
> +					PAGE_SIZE);
> +	if (!new_memmap_phy)
> +		return;
> +
> +	/* create new EFI memmap */
> +	new_memmap = early_memremap(new_memmap_phy,
> +				    memmap.desc_size * new_nr_map);

early_memremap() can fail and return NULL, so you should check for
that.

The rest of the patch looks fine to me.

-- 
Matt Fleming, Intel Open Source Technology Center
