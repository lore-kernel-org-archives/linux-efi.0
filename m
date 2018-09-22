From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v7 3/3] x86/boot/KASLR: Limit kaslr to choosing the
 immovable memory
Date: Sat, 22 Sep 2018 08:48:53 -0700
Message-ID: <CAGXu5jK13F7EY--zAVWq-=P2-Lt7n-K05ctL-vH7S=rcWKQoOw@mail.gmail.com>
References: <20180913104629.5179-1-fanc.fnst@cn.fujitsu.com> <20180913104629.5179-4-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180913104629.5179-4-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Baoquan He <bhe@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Thu, Sep 13, 2018 at 3:46 AM, Chao Fan <fanc.fnst@cn.fujitsu.com> wrote:
> If CONFIG_MEMORY_HOTREMOVE enabled and the amount of immovable
> memory regions is not zero. Calculate the intersection between memory
> regions from e820/efi memory table and immovable memory regions.
>
> Signed-off-by: Chao Fan <fanc.fnst@cn.fujitsu.com>
> ---
>  arch/x86/boot/compressed/kaslr.c | 71 +++++++++++++++++++++++++++-----
>  1 file changed, 60 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
> index 0c3567bc231c..0a7ef2daf169 100644
> --- a/arch/x86/boot/compressed/kaslr.c
> +++ b/arch/x86/boot/compressed/kaslr.c
> @@ -101,6 +101,11 @@ static bool memmap_too_large;
>  /* Store memory limit specified by "mem=nn[KMG]" or "memmap=nn[KMG]" */
>  static unsigned long long mem_limit = ULLONG_MAX;
>
> +#ifdef CONFIG_MEMORY_HOTREMOVE
> +/* Store the immovable memory regions */
> +extern struct mem_vector immovable_mem[MAX_NUMNODES*2];
> +#endif
> +
>
>  enum mem_avoid_index {
>         MEM_AVOID_ZO_RANGE = 0,
> @@ -577,9 +582,9 @@ static unsigned long slots_fetch_random(void)
>         return 0;
>  }
>
> -static void process_mem_region(struct mem_vector *entry,
> -                              unsigned long minimum,
> -                              unsigned long image_size)
> +static void slots_count(struct mem_vector *entry,
> +                       unsigned long minimum,
> +                       unsigned long image_size)
>  {
>         struct mem_vector region, overlap;
>         unsigned long start_orig, end;
> @@ -655,6 +660,56 @@ static void process_mem_region(struct mem_vector *entry,
>         }
>  }
>
> +static bool process_mem_region(struct mem_vector *region,
> +                              unsigned long long minimum,
> +                              unsigned long long image_size)
> +{
> +       int i;
> +       /*
> +        * If no immovable memory found, or MEMORY_HOTREMOVE disabled,
> +        * walk all the regions, so use region directely.
> +        */
> +       if (num_immovable_mem == 0) {
> +               slots_count(region, minimum, image_size);
> +
> +               if (slot_area_index == MAX_SLOT_AREA) {
> +                       debug_putstr("Aborted e820/efi memmap scan (slot_areas full)!\n");
> +                       return 1;
> +               }
> +               return 0;
> +       }
> +
> +#ifdef CONFIG_MEMORY_HOTREMOVE
> +       /*
> +        * If immovable memory found, filter the intersection between
> +        * immovable memory and region to slots_count.
> +        * Otherwise, go on old code.
> +        */
> +       for (i = 0; i < num_immovable_mem; i++) {
> +               struct mem_vector entry;
> +               unsigned long long start, end, entry_end, region_end;
> +
> +               start = immovable_mem[i].start;
> +               end = start + immovable_mem[i].size;
> +               region_end = region->start + region->size;
> +
> +               entry.start = clamp(region->start, start, end);
> +               entry_end = clamp(region_end, start, end);
> +
> +               if (entry.start + image_size < entry_end) {

Can this logic be rewritten to use the existing mem_overlaps() check
instead? I think that would make it much more readable.

Otherwise, yes, this all looks fine.

-Kees

> +                       entry.size = entry_end - entry.start;
> +                       slots_count(&entry, minimum, image_size);
> +
> +                       if (slot_area_index == MAX_SLOT_AREA) {
> +                               debug_putstr("Aborted e820/efi memmap scan (slot_areas full)!\n");
> +                               return 1;
> +                       }
> +               }
> +       }
> +       return 0;
> +#endif
> +}
> +
>  #ifdef CONFIG_EFI
>  /*
>   * Returns true if mirror region found (and must have been processed
> @@ -720,11 +775,8 @@ process_efi_entries(unsigned long minimum, unsigned long image_size)
>
>                 region.start = md->phys_addr;
>                 region.size = md->num_pages << EFI_PAGE_SHIFT;
> -               process_mem_region(&region, minimum, image_size);
> -               if (slot_area_index == MAX_SLOT_AREA) {
> -                       debug_putstr("Aborted EFI scan (slot_areas full)!\n");
> +               if (process_mem_region(&region, minimum, image_size))
>                         break;
> -               }
>         }
>         return true;
>  }
> @@ -751,11 +803,8 @@ static void process_e820_entries(unsigned long minimum,
>                         continue;
>                 region.start = entry->addr;
>                 region.size = entry->size;
> -               process_mem_region(&region, minimum, image_size);
> -               if (slot_area_index == MAX_SLOT_AREA) {
> -                       debug_putstr("Aborted e820 scan (slot_areas full)!\n");
> +               if (process_mem_region(&region, minimum, image_size))
>                         break;
> -               }
>         }
>  }
>
> --
> 2.17.1
>
>
>



-- 
Kees Cook
Pixel Security
