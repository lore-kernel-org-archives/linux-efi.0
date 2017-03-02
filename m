From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] efi/capsule: Add 'capsule' lookup support
Date: Thu, 2 Mar 2017 15:38:51 +0000
Message-ID: <CAKv+Gu8=_D_ghJkxeLtnVN2fNV8ybS_2+cjs3ih_TmGtTJM4+Q@mail.gmail.com>
References: <20170301175943.87444-1-qiuxu.zhuo@intel.com> <20170301175943.87444-2-qiuxu.zhuo@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301175943.87444-2-qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 1 March 2017 at 17:59, Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Add the interface to get the array of EFI capsules when
> parsing the configuration tables.
>
> This code is based on Matt Fleming previous work from:
> https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=capsule-pstore&id=99c5f047133555aa0442f64064e85b7da2d4a45f
>
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/capsule.c | 107 +++++++++++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/efi.c     |   4 ++
>  include/linux/efi.h            |   4 ++
>  3 files changed, 115 insertions(+)
>
> diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
> index 6eedff4..7bf79fd 100644
> --- a/drivers/firmware/efi/capsule.c
> +++ b/drivers/firmware/efi/capsule.c
> @@ -24,6 +24,11 @@ typedef struct {
>  static bool capsule_pending;
>  static bool stop_capsules;
>  static int efi_reset_type = -1;
> +/*
> + * Information about capsules we pulled from the EFI System Table.
> + */
> +static efi_capsule_header_t **prev_capsules;
> +static u32 efi_capsule_num;
>
>  /*
>   * capsule_mutex serialises access to both capsule_pending and
> @@ -288,6 +293,108 @@ int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
>  }
>  EXPORT_SYMBOL_GPL(efi_capsule_update);
>
> +static int extract_capsules(void)
> +{

I would like to understand something: this routine is called
'extract_capsules', but the way it is wired up, we can only use if for
capsules with GUID set to LINUX_CRASH_EFI_GUID. That seems incorrect
to me: the generic capsule code should be able to extract capsules
with any GUID (which the prototype of efi_capsule_lookup suggests).

I think it comes down to removing the global state in prev_capsules
and efi_capsule_num, and folding extract_capsules() into
efi_capsule_lookup().

You could add a routine that iterates over the config table array to
look for your GUID: that way, you don't need to put it in generic EFI
code.

> +       void *capsule;
> +       size_t size;
> +
> +       if (efi.capsule == EFI_INVALID_TABLE_ADDR)
> +               return 0;
> +
> +       capsule = memremap(efi.capsule, sizeof(efi_capsule_num), MEMREMAP_WB);
> +       if (!capsule)
> +               return -ENOMEM;
> +
> +       /*
> +        * The array of capsules is prefixed with the number of
> +        * capsule entries in the array.
> +        */
> +       efi_capsule_num = *(uint32_t *)capsule;
> +       iounmap(capsule);
> +

Please use memunmap here

> +       if (!efi_capsule_num) {
> +               pr_info("No capsules on extraction\n");
> +               return 0;
> +       }
> +
> +       size = efi_capsule_num * sizeof(*capsule);
> +       capsule = memremap(efi.capsule, size, MEMREMAP_WB);

Is 'capsule' ever unmapped? If not, why not?

> +       if (!capsule)
> +               return -ENOMEM;
> +
> +       capsule += sizeof(uint32_t);

This is incorrect for 64-bit. You need to increment by the size of
unsigned long here, regardless of the size of efi_capsule_num.

> +       prev_capsules = (efi_capsule_header_t **)capsule;
> +       if (!*prev_capsules)
> +               pr_err("Capsule array has no entries\n");
> +
> +       return 0;
> +}
> +
> +/**
> + * efi_capsule_lookup - search capsule array for entries.
> + * @guid: the guid to search for.
> + * @nr_caps: the number of entries found.
> + *
> + * Map each capsule header into the kernel's virtual address space and
> + * inspect the guid. Build an array of capsule headers with every
> + * capsule that is found with @guid. If a match is found the capsule
> + * remains mapped, otherwise it is unmapped.
> + *
> + * Returns an array of capsule headers, each element of which has the
> + * guid @guid. The number of elements in the array is stored in
> + * @nr_caps. Returns %NULL if no capsules were found and stores zero
> + * in @nr_caps.
> + */
> +efi_capsule_header_t **efi_capsule_lookup(efi_guid_t guid, uint32_t *nr_caps)
> +{
> +       efi_capsule_header_t **capsules = NULL, **tmp;
> +       size_t capsule_size = 0;
> +       int i, rv;
> +
> +       rv = extract_capsules();
> +       if (rv)
> +               return ERR_PTR(rv);
> +
> +       *nr_caps = 0;
> +       for (i = 0; i < efi_capsule_num; i++) {
> +               efi_capsule_header_t *c;
> +               size_t size;
> +
> +               c = memremap((resource_size_t)prev_capsules[i], sizeof(*c), MEMREMAP_WB);
> +               if (!c) {
> +                       pr_err("Failed to memremap capsule\n");
> +                       continue;
> +               }
> +
> +               size = c->imagesize;
> +               iounmap(c);
> +

memunmap

> +               c = memremap((resource_size_t)prev_capsules[i], size, MEMREMAP_WB);
> +               if (!c) {
> +                       pr_err("Failed to memremap header + data\n");
> +                       continue;
> +               }
> +
> +               if (!efi_guidcmp(c->guid, guid)) {

When can we expect the capsule GUID to deviate from the GUID we looked for?

> +                       capsule_size += sizeof(*capsules);
> +                       tmp = krealloc(capsules, capsule_size, GFP_KERNEL);
> +                       if (!tmp) {
> +                               kfree(capsules);
> +                               return ERR_PTR(-ENOMEM);
> +                       }
> +
> +                       capsules = tmp;
> +                       capsules[(*nr_caps)++] = c;
> +                       continue;
> +               }
> +
> +               iounmap(c);

memunmap

> +       }
> +
> +       return capsules;
> +}
> +EXPORT_SYMBOL_GPL(efi_capsule_lookup);
> +
>  static int capsule_reboot_notify(struct notifier_block *nb, unsigned long event, void *cmd)
>  {
>         mutex_lock(&capsule_mutex);
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 9291480..03be9b8 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -52,6 +52,7 @@ struct efi __read_mostly efi = {
>         .properties_table       = EFI_INVALID_TABLE_ADDR,
>         .mem_attr_table         = EFI_INVALID_TABLE_ADDR,
>         .rng_seed               = EFI_INVALID_TABLE_ADDR,
> +       .capsule                = EFI_INVALID_TABLE_ADDR,
>  };
>  EXPORT_SYMBOL(efi);
>
> @@ -120,6 +121,8 @@ static ssize_t systab_show(struct kobject *kobj,
>                 str += sprintf(str, "BOOTINFO=0x%lx\n", efi.boot_info);
>         if (efi.uga != EFI_INVALID_TABLE_ADDR)
>                 str += sprintf(str, "UGA=0x%lx\n", efi.uga);
> +       if (efi.capsule != EFI_INVALID_TABLE_ADDR)
> +               str += sprintf(str, "CAPSULE=0x%lx\n", efi.capsule);
>
>         return str - buf;
>  }
> @@ -445,6 +448,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
>         {EFI_PROPERTIES_TABLE_GUID, "PROP", &efi.properties_table},
>         {EFI_MEMORY_ATTRIBUTES_TABLE_GUID, "MEMATTR", &efi.mem_attr_table},
>         {LINUX_EFI_RANDOM_SEED_TABLE_GUID, "RNG", &efi.rng_seed},
> +       {LINUX_EFI_CRASH_GUID, "CAPSULE", &efi.capsule},
>         {NULL_GUID, NULL, NULL},
>  };
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 5b1af30..3296724e 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -893,6 +893,7 @@ extern struct efi {
>         unsigned long properties_table; /* properties table */
>         unsigned long mem_attr_table;   /* memory attributes table */
>         unsigned long rng_seed;         /* UEFI firmware random seed */
> +       unsigned long capsule;          /* EFI capsule table */

Can we get rid of all this global stuff? If it is too tedious to go
over the config table array, we could keep it I guess (but please
don't call capsule-pstore specific things 'capsule', this is confusing
the hell out of me)

>         efi_get_time_t *get_time;
>         efi_set_time_t *set_time;
>         efi_get_wakeup_time_t *get_wakeup_time;
> @@ -1401,6 +1402,9 @@ extern int efi_capsule_supported(efi_guid_t guid, u32 flags,
>  extern int efi_capsule_update(efi_capsule_header_t *capsule,
>                               struct page **pages);
>
> +extern efi_capsule_header_t **efi_capsule_lookup(efi_guid_t guid,
> +                             uint32_t *nr_caps);
> +
>  #ifdef CONFIG_EFI_RUNTIME_MAP
>  int efi_runtime_map_init(struct kobject *);
>  int efi_get_runtime_map_size(void);
> --
> 2.9.0.GIT
>
