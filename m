From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] efi: Fix warning of int-to-pointer-cast on x86
 32-bit builds
Date: Fri, 23 Oct 2015 12:27:28 +0200
Message-ID: <20151023102728.GA1974@gmail.com>
References: <20151023085011.GB21631@gmail.com>
 <1445593697-1342-1-git-send-email-ard.biesheuvel@linaro.org>
 <1445593697-1342-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445593697-1342-2-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, izumi.taku@jp.fujitsu.com, matt.fleming@intel.com, linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> From: Taku Izumi <izumi.taku@jp.fujitsu.com>
> 
> Commit 0f96a99dab36 ("efi: Add "efi_fake_mem" boot option")
> introduces the following warning message:
> 
>   drivers/firmware/efi/fake_mem.c:186:20: warning: cast to pointer
>   from integer of different size [-Wint-to-pointer-cast]
> 
> new_memmap_phy was defined as a u64 value and cast to void*, causing
> a int-to-pointer-cast warning on x86 32-bit builds.
> However, since the void* type is inappropriate for a physical
> address, the definition of struct efi_memory_map::phys_map has been
> changed to phys_addr_t in the previous patch, and so the cast can be
> dropped entirely.
> 
> This patch also changes the type of the "new_memmap_phy" variable
> from "u64" to "phys_addr_t" to align with the types of
> memblock_alloc() and struct efi_memory_map::phys_map.
> 
> Reported-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
> [ard.biesheuvel: removed void* cast, updated commit log]
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/firmware/efi/fake_mem.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/efi/fake_mem.c b/drivers/firmware/efi/fake_mem.c
> index 32bcb14df2c8..ed3a854950cc 100644
> --- a/drivers/firmware/efi/fake_mem.c
> +++ b/drivers/firmware/efi/fake_mem.c
> @@ -59,7 +59,7 @@ void __init efi_fake_memmap(void)
>  	u64 start, end, m_start, m_end, m_attr;
>  	int new_nr_map = memmap.nr_map;
>  	efi_memory_desc_t *md;
> -	u64 new_memmap_phy;
> +	phys_addr_t new_memmap_phy;
>  	void *new_memmap;
>  	void *old, *new;
>  	int i;
> @@ -183,7 +183,7 @@ void __init efi_fake_memmap(void)
>  	/* swap into new EFI memmap */
>  	efi_unmap_memmap();
>  	memmap.map = new_memmap;
> -	memmap.phys_map = (void *)new_memmap_phy;
> +	memmap.phys_map = new_memmap_phy;
>  	memmap.nr_map = new_nr_map;
>  	memmap.map_end = memmap.map + memmap.nr_map * memmap.desc_size;

Please guys, think for a change!

How is this supposed to work with:

   include/linux/efi.h:    void *phys_map;

?

Thanks,

	Ingo
