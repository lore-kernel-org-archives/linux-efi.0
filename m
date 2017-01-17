From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH V2 4/4] efi/x86: make efi_memmap_reserve only insert into
 boot mem areas
Date: Tue, 17 Jan 2017 17:13:00 +0000
Message-ID: <CAKv+Gu8C2btUOOO28LVUJ3umiS-BvEk6xi7a_OMTsuh28hoDbQ@mail.gmail.com>
References: <20170116024554.461236678@redhat.com> <20170116025026.586405871@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170116025026.586405871@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Nicolai Stange <nicstange@gmail.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>, Bhupesh Sharma <bhsharma@redhat.com>
List-Id: linux-efi@vger.kernel.org

On 16 January 2017 at 02:45, Dave Young <dyoung@redhat.com> wrote:
> efi_mem_reserve cares only about boot services regions, for making sure
> later efi_free_boot_services does not free areas which are still useful,
> such as bgrt image buffer.
>
> So add a new argument to efi_memmap_insert for this purpose.
>

So what happens is we try to efi_mem_reserve() a regions that is not
bootservices code or data? We shouldn't simply ignore it, because it
is a serious condition.

> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
> v1->v2: only check EFI_BOOT_SERVICES_CODE/_DATA
>  arch/x86/platform/efi/quirks.c  |    2 +-
>  drivers/firmware/efi/fake_mem.c |    3 ++-
>  drivers/firmware/efi/memmap.c   |    6 +++++-
>  include/linux/efi.h             |    4 ++--
>  4 files changed, 10 insertions(+), 5 deletions(-)
>
> --- linux-x86.orig/drivers/firmware/efi/memmap.c
> +++ linux-x86/drivers/firmware/efi/memmap.c
> @@ -229,7 +229,7 @@ int __init efi_memmap_split_count(efi_me
>   * to see how large @buf needs to be.
>   */
>  void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
> -                             struct efi_mem_range *mem)
> +                             struct efi_mem_range *mem, bool boot_only)
>  {
>         u64 m_start, m_end, m_attr;
>         efi_memory_desc_t *md;
> @@ -262,6 +262,10 @@ void __init efi_memmap_insert(struct efi
>                 start = md->phys_addr;
>                 end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
>
> +               if (boot_only && !(md->type == EFI_BOOT_SERVICES_CODE ||
> +                                  md->type == EFI_BOOT_SERVICES_DATA))
> +                       continue;
> +
>                 if (m_start <= start && end <= m_end)
>                         md->attribute |= m_attr;
>
> --- linux-x86.orig/arch/x86/platform/efi/quirks.c
> +++ linux-x86/arch/x86/platform/efi/quirks.c
> @@ -226,7 +226,7 @@ void __init efi_arch_mem_reserve(phys_ad
>                 return;
>         }
>
> -       efi_memmap_insert(&efi.memmap, new, &mr);
> +       efi_memmap_insert(&efi.memmap, new, &mr, true);
>         early_memunmap(new, new_size);
>
>         efi_memmap_install(new_phys, num_entries);
> --- linux-x86.orig/drivers/firmware/efi/fake_mem.c
> +++ linux-x86/drivers/firmware/efi/fake_mem.c
> @@ -85,7 +85,8 @@ void __init efi_fake_memmap(void)
>         }
>
>         for (i = 0; i < nr_fake_mem; i++)
> -               efi_memmap_insert(&efi.memmap, new_memmap, &fake_mems[i]);
> +               efi_memmap_insert(&efi.memmap, new_memmap, &fake_mems[i],
> +                                 false);
>
>         /* swap into new EFI memmap */
>         early_memunmap(new_memmap, efi.memmap.desc_size * new_nr_map);
> --- linux-x86.orig/include/linux/efi.h
> +++ linux-x86/include/linux/efi.h
> @@ -959,8 +959,8 @@ extern int __init efi_memmap_install(phy
>  extern int __init efi_memmap_split_count(efi_memory_desc_t *md,
>                                          struct range *range);
>  extern void __init efi_memmap_insert(struct efi_memory_map *old_memmap,
> -                                    void *buf, struct efi_mem_range *mem);
> -
> +                                    void *buf, struct efi_mem_range *mem,
> +                                    bool boot_only);
>  extern int efi_config_init(efi_config_table_type_t *arch_tables);
>  #ifdef CONFIG_EFI_ESRT
>  extern void __init efi_esrt_init(void);
>
>
