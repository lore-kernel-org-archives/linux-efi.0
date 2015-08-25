From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/2] x86, efi: Add "efi_fake_mem_mirror" boot option
Date: Wed, 26 Aug 2015 00:46:19 +0100
Message-ID: <20150825234618.GC3013@codeblueprint.co.uk>
References: <1440090902-15157-1-git-send-email-izumi.taku@jp.fujitsu.com>
 <1440090960-15252-1-git-send-email-izumi.taku@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1440090960-15252-1-git-send-email-izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 21 Aug, at 02:16:00AM, Taku Izumi wrote:
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
>    efi: mem00: [Boot Data          |   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000001000) (0MB)
>    efi: mem01: [Loader Data        |   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000001000-0x0000000000002000) (0MB)
>    ...
>    efi: mem35: [Boot Data          |   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000047ee6000-0x0000000048014000) (1MB)
>    efi: mem36: [Conventional Memory|   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x00000020a0000000) (129536MB)
>    efi: mem37: [Reserved           |RUN|    |  |  |  |   |  |  |  |UC] range=[0x0000000060000000-0x0000000090000000) (768MB)
> 
>  <updated EFI memmap>
>    efi: mem00: [Boot Data          |   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000001000) (0MB)
>    efi: mem01: [Loader Data        |   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000001000-0x0000000000002000) (0MB)
>    ...
>    efi: mem35: [Boot Data          |   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000047ee6000-0x0000000048014000) (1MB)
>    efi: mem36: [Conventional Memory|   |RELY|  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x0000000180000000) (2048MB)
>    efi: mem37: [Conventional Memory|   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000180000000-0x00000010a0000000) (61952MB)
>    efi: mem38: [Conventional Memory|   |RELY|  |  |  |   |WB|WT|WC|UC] range=[0x00000010a0000000-0x0000001120000000) (2048MB)
>    efi: mem39: [Conventional Memory|   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000001120000000-0x00000020a0000000) (63488MB)
>    efi: mem40: [Reserved           |RUN|    |  |  |  |   |  |  |  |UC] range=[0x0000000060000000-0x0000000090000000) (768MB)
> 
> And you will find that the following message is output:
> 
>    efi: Memory: 4096M/131455M mirrored memory
> 
> Signed-off-by: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> ---
>  Documentation/kernel-parameters.txt |   8 ++
>  arch/x86/include/asm/efi.h          |   2 +
>  arch/x86/kernel/setup.c             |   4 +-
>  arch/x86/platform/efi/efi.c         |   2 +-
>  arch/x86/platform/efi/quirks.c      | 169 ++++++++++++++++++++++++++++++++++++
>  5 files changed, 183 insertions(+), 2 deletions(-)

[...]

> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 1c7380d..5c785e1 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -18,6 +18,10 @@
>  

The quirks file isn't intended to be used for this kind of feature.
It's very much a repository for workarounds for quirky firmware, i.e.
known bugs.

Instead, how about putting all this into a new fake_mem.c file? Going
further than that, there's nothing that I can see that looks
particularly x86-specific, so how about sticking all this in
drivers/firmware/efi/fake_mem.c so that the arm64 folks can make use
of it if/when they want to start playing around with
EFI_MEMORY_MORE_RELIABLE?

>  static efi_char16_t efi_dummy_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
>  
> +#define EFI_MAX_FAKE_MIRROR 8
> +static struct range fake_mirrors[EFI_MAX_FAKE_MIRROR];
> +static int num_fake_mirror;
> +
>  static bool efi_no_storage_paranoia;
>  
>  /*
> @@ -288,3 +292,168 @@ bool efi_poweroff_required(void)
>  {
>  	return !!acpi_gbl_reduced_hardware;
>  }
> +
> +void __init efi_fake_memmap(void)
> +{
> +	efi_memory_desc_t *md;
> +	void *p, *q;
> +	int i;
> +	int nr_map = memmap.nr_map;
> +	u64 start, end, m_start, m_end;
> +	u64 new_memmap_phy;
> +	void *new_memmap;
> +
> +	if (!num_fake_mirror)
> +		return;
> +
> +	/* count up the number of EFI memory descriptor */
> +	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> +		md = p;
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
> +					nr_map++;
> +			}
> +			if (start < m_start && m_start < end) {
> +				/* split into 3 parts */
> +				if (m_end < end)
> +					nr_map += 2;
> +				/* split into 2 parts */
> +				if (end <= m_end)
> +					nr_map++;
> +			}
> +		}
> +	}
> +
> +	/* allocate memory for new EFI memmap */
> +	new_memmap_phy = memblock_alloc(memmap.desc_size * nr_map, PAGE_SIZE);
> +	if (!new_memmap_phy)
> +		return;
> +
> +	/* create new EFI memmap */
> +	new_memmap = early_memremap(new_memmap_phy, memmap.desc_size * nr_map);
> +	for (p = memmap.map, q = new_memmap;
> +	     p < memmap.map_end;
> +	     p += memmap.desc_size, q += memmap.desc_size) {

Can we rename 'p' and 'q', 'old' and 'new'? Otherwise it gets a little
tricky to follow the below code.


-- 
Matt Fleming, Intel Open Source Technology Center
