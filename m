From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 2/2] eif/capsule-pstore: Add capsule pstore backend
Date: Mon, 26 Jun 2017 19:25:11 +0000
Message-ID: <CAKv+Gu_FJ1WkK=inaMSY2rk680MD5wNMRvEF6s61tuc4+VfUUw@mail.gmail.com>
References: <20170622163509.95792-1-qiuxu.zhuo@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170622163509.95792-1-qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 22 June 2017 at 16:35, Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> The EFI capsule mechanism allows data blobs to be passed to the EFI
> firmware. By setting the EFI_CAPSULE_POPULATE_SYSTEM_TABLE and the
> EFI_CAPSULE_PERSIST_ACROSS_REBOOT flags, the firmware will place a
> pointer to our data blob in the EFI System Table on the next boot.
> We can utilise this facility to save crash dumps, call traces, etc
> and pick them up to aid in debugging after reboot.
>
> Initial cut at this driver by Matt Fleming as below links
> https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=
=3Dcapsule-pstore&id=3D99c5f047133555aa0442f64064e85b7da2d4a45f
> https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=
=3Dcapsule-pstore&id=3D8625c776c9b8bbed7fa4aa023e36542615165240
> Extensive cleanup, refactoring, bug fix, and verification by Qiuxu Zhuo
>
> Patch verified on Intel Kabylake client platform + Intel KBL BIOS:(10/24/=
2016):
> - modprobe capsule-pstore
> - echo "Test pmsg on capsule-pstore" > /dev/pmsg0
> - echo 1 > /sys/module/kernel/parameters/panic
> - echo c > /proc/sysrq-trigger
> - system reboot...
> - ls -l /sys/fs/pstore/
>   -r--r--r-- 1 root root 4946 6=E6=9C=88  19 14:05 console-capsule-pstore=
-0
>   -r--r--r-- 1 root root 8976 6=E6=9C=88  19 14:03 dmesg-capsule-pstore-6=
433226157407076353
>   -r--r--r-- 1 root root 9043 6=E6=9C=88  19 14:03 dmesg-capsule-pstore-6=
433226157407076354
>   -r--r--r-- 1 root root 9069 6=E6=9C=88  19 14:03 dmesg-capsule-pstore-6=
433226157407076355
>   -r--r--r-- 1 root root 9092 6=E6=9C=88  19 14:03 dmesg-capsule-pstore-6=
433226157407076356
>   -r--r--r-- 1 root root 8976 6=E6=9C=88  19 14:03 dmesg-capsule-pstore-6=
433226157407076357
>   -r--r--r-- 1 root root 9028 6=E6=9C=88  19 14:03 dmesg-capsule-pstore-6=
433226157407076358
>   -r--r--r-- 1 root root   28 6=E6=9C=88  19 14:05 pmsg-capsule-pstore-0
>
> The above files contain pmsg log and the last console/dmesg logs.
>
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Actually, even though I expect that your definition of the capsule
table struct is the correct one (including the packed attribute), this
patch triggers a *lot* of checkpatch warnings regarding lines that
exceed 80 characters, and so I will not be able to merge this as-is.
Could you please fix it up? (you can ignore the other warnings re
typedefs and MAINTAINERS)

Thanks,
Ard.


> ---
>  drivers/firmware/efi/Kconfig          |  21 ++
>  drivers/firmware/efi/Makefile         |   1 +
>  drivers/firmware/efi/capsule-pstore.c | 679 ++++++++++++++++++++++++++++=
++++++
>  3 files changed, 701 insertions(+)
>  create mode 100644 drivers/firmware/efi/capsule-pstore.c
>
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 394db40..f8c6564 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -151,6 +151,27 @@ config APPLE_PROPERTIES
>
>           If unsure, say Y if you have a Mac.  Otherwise N.
>
> +config EFI_CAPSULE_PSTORE
> +       tristate "EFI capsule pstore backend"
> +       depends on EFI && PSTORE
> +       help
> +         Saying Y here enable the EFI capsule mechanism to store crash d=
umps,
> +         console log, and function tracing data.
> +
> +         To compile this driver as a module, choose M here.
> +
> +         Not many firmware implementations fully support EFI capsules.
> +         If you plan to rely on this you should test whether yours works=
 by
> +         forcing a crash. Most people should not enable this.
> +
> +config EFI_CAPSULE_PSTORE_DEFAULT_DISABLE
> +       bool "Disable using efi capsule as a pstore backend by default"
> +       depends on EFI_CAPSULE_PSTORE
> +       help
> +         Saying Y here will disable the use of efi capsule as a storage
> +         backend for pstore by default. This setting can be overridden
> +         using the capsule-pstore module's pstore_disable parameter.
> +
>  endmenu
>
>  config UEFI_CPER
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefil=
e
> index 0329d31..c06e52f 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -15,6 +15,7 @@ obj-$(CONFIG_EFI)                     +=3D capsule.o me=
mmap.o
>  obj-$(CONFIG_EFI_VARS)                 +=3D efivars.o
>  obj-$(CONFIG_EFI_ESRT)                 +=3D esrt.o
>  obj-$(CONFIG_EFI_VARS_PSTORE)          +=3D efi-pstore.o
> +obj-$(CONFIG_EFI_CAPSULE_PSTORE)               +=3D capsule-pstore.o
>  obj-$(CONFIG_UEFI_CPER)                        +=3D cper.o
>  obj-$(CONFIG_EFI_RUNTIME_MAP)          +=3D runtime-map.o
>  obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)     +=3D runtime-wrappers.o
> diff --git a/drivers/firmware/efi/capsule-pstore.c b/drivers/firmware/efi=
/capsule-pstore.c
> new file mode 100644
> index 0000000..10cc22e
> --- /dev/null
> +++ b/drivers/firmware/efi/capsule-pstore.c
> @@ -0,0 +1,679 @@
> +/*
> + * EFI capsule pstore backend support.
> + * Copyright (c) 2017, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify =
it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOU=
T
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> + * more details.
> + */
> +
> +#define pr_fmt(fmt) "capsule-pstore: " fmt
> +#include <linux/slab.h>
> +#include <linux/vmalloc.h>
> +#include <linux/highmem.h>
> +#include <linux/efi.h>
> +#include <linux/module.h>
> +#include <linux/pstore.h>
> +
> +#define CAPSULE_SIZE (16 * 1024)
> +#define CRASH_SIZE 4096
> +#define CAPSULE_MAGIC 0x63617073 /* 'caps' */
> +
> +static bool efi_capsule_pstore_disable __ro_after_init =3D
> +       IS_ENABLED(CONFIG_CAPSULE_PSTORE_DEFAULT_DISABLE);
> +
> +static int efi_reset_type =3D -1;
> +
> +struct efi_capsule_ctx {
> +       struct page **pages;
> +       phys_addr_t *phys_addrs;
> +       unsigned int nr_pages;
> +       efi_capsule_header_t *capsule;
> +       size_t capsule_size;
> +       void *data;
> +       size_t data_size;
> +};
> +
> +struct efi_capsule_pstore_buf {
> +       void *buf;
> +       size_t size;
> +       atomic_long_t offset;
> +};
> +
> +struct efi_capsule_pstore {
> +       /* Old records */
> +       efi_capsule_header_t **hdrs;
> +       u32 hdrs_num;
> +       off_t hdr_offset;
> +
> +       /* New records */
> +       struct efi_capsule_pstore_buf console;
> +       struct efi_capsule_pstore_buf ftrace;
> +       struct efi_capsule_pstore_buf dmesg;
> +       struct efi_capsule_pstore_buf pmsg;
> +};
> +
> +struct efi_capsule_pstore_record {
> +       u64 timestamp;
> +       u64 id;
> +       enum pstore_type_id type;
> +       size_t size;
> +       bool compressed;
> +       u32 magic;
> +       char data[];
> +} __packed;
> +
> +typedef struct {
> +       u32 capsule_array_number;
> +       void *capsule_addr[];
> +} __packed efi_capsule_table_t;
> +
> +static ssize_t efi_capsule_pstore_read(struct pstore_record *record);
> +static int notrace efi_capsule_pstore_write(struct pstore_record *record=
);
> +static int notrace efi_capsule_pstore_write_user(struct pstore_record *r=
ecord, const char __user *buf);
> +
> +static struct pstore_info efi_capsule_pstore_info =3D {
> +       .owner      =3D THIS_MODULE,
> +       .name       =3D "capsule-pstore",
> +       .buf_lock   =3D __SPIN_LOCK_UNLOCKED(efi_capsule_pstore_info.buf_=
lock),
> +       .bufsize    =3D CRASH_SIZE,
> +       .flags      =3D PSTORE_FLAGS_DMESG | PSTORE_FLAGS_CONSOLE | PSTOR=
E_FLAGS_FTRACE | PSTORE_FLAGS_PMSG,
> +       .read       =3D efi_capsule_pstore_read,
> +       .write      =3D efi_capsule_pstore_write,
> +       .write_user =3D efi_capsule_pstore_write_user,
> +};
> +
> +static efi_capsule_table_t *efi_capsule_table_get(efi_guid_t guid)
> +{
> +       unsigned long table =3D EFI_INVALID_TABLE_ADDR;
> +       void *p, *tablep =3D NULL, *tablec =3D NULL;
> +       int i, sz;
> +       u32 n;
> +
> +       if (efi.config_table =3D=3D EFI_INVALID_TABLE_ADDR || efi.nr_conf=
ig_table =3D=3D 0)
> +               return NULL;
> +
> +       if (efi_enabled(EFI_64BIT))
> +               sz =3D sizeof(efi_config_table_64_t);
> +       else
> +               sz =3D sizeof(efi_config_table_32_t);
> +
> +       tablep =3D memremap(efi.config_table, efi.nr_config_table * sz, M=
EMREMAP_WB);
> +       if (!tablep)
> +               return NULL;
> +
> +       p =3D tablep;
> +       for (i =3D 0; i < efi.nr_config_table; i++) {
> +               efi_guid_t id;
> +
> +               if (efi_enabled(EFI_64BIT)) {
> +                       id =3D ((efi_config_table_64_t *)p)->guid;
> +                       if (!efi_guidcmp(id, guid)) {
> +                               table =3D ((efi_config_table_64_t *)p)->t=
able;
> +                               break;
> +                       }
> +               } else {
> +                       id =3D ((efi_config_table_32_t *)p)->guid;
> +                       if (!efi_guidcmp(id, guid)) {
> +                               table =3D ((efi_config_table_32_t *)p)->t=
able;
> +                               break;
> +                       }
> +               }
> +
> +               p +=3D sz;
> +       }
> +
> +       if (table =3D=3D EFI_INVALID_TABLE_ADDR)
> +               goto out;
> +
> +       sz =3D sizeof(u32);
> +       tablec =3D memremap(table, sz, MEMREMAP_WB);
> +       if (!tablec)
> +               goto out;
> +
> +       /*
> +        * The array of capsules is prefixed with the number of
> +        * capsule entries in the array.
> +        */
> +       n =3D *(u32 *)tablec;
> +       memunmap(tablec);
> +       if (!n) {
> +               pr_info("No capsules on extraction\n");
> +               goto out;
> +       }
> +
> +       sz +=3D n * sizeof(*tablec);
> +       tablec =3D memremap(table, sz, MEMREMAP_WB);
> +
> +out:
> +       memunmap(tablep);
> +
> +       return (efi_capsule_table_t *)tablec;
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
> +static efi_capsule_header_t **efi_capsule_lookup(efi_guid_t guid, u32 *n=
r_caps)
> +{
> +       efi_capsule_header_t **capsules =3D NULL, **tmp;
> +       efi_capsule_table_t *tablec;
> +       int i, sz =3D 0;
> +
> +       tablec =3D efi_capsule_table_get(guid);
> +       if (!tablec)
> +               return NULL;
> +
> +       *nr_caps =3D 0;
> +       for (i =3D 0; i < tablec->capsule_array_number; i++) {
> +               efi_capsule_header_t *c;
> +               size_t size;
> +
> +               c =3D memremap((resource_size_t)tablec->capsule_addr[i], =
sizeof(*c), MEMREMAP_WB);
> +               if (!c) {
> +                       pr_err("Fail to memremap capsule header\n");
> +                       continue;
> +               }
> +
> +               size =3D c->imagesize;
> +               memunmap(c);
> +
> +               c =3D memremap((resource_size_t)tablec->capsule_addr[i], =
size, MEMREMAP_WB);
> +               if (!c) {
> +                       pr_err("Fail to memremap capsule header + data\n"=
);
> +                       continue;
> +               }
> +
> +               sz +=3D sizeof(*capsules);
> +               tmp =3D krealloc(capsules, sz, GFP_KERNEL);
> +               if (!tmp) {
> +                       for (i =3D 0; i < *nr_caps; i++)
> +                               memunmap(capsules[i]);
> +
> +                       kfree(capsules);
> +                       memunmap(tablec);
> +
> +                       return NULL;
> +               }
> +
> +               capsules =3D tmp;
> +               capsules[(*nr_caps)++] =3D c;
> +       }
> +
> +       memunmap(tablec);
> +
> +       return capsules;
> +}
> +
> +static __init void efi_capsule_destroy(struct efi_capsule_ctx *ctx)
> +{
> +       if (IS_ERR_OR_NULL(ctx))
> +               return;
> +
> +       vunmap(ctx->capsule);
> +
> +       while (ctx->nr_pages--)
> +               __free_page(ctx->pages[ctx->nr_pages]);
> +
> +       kfree(ctx->pages);
> +       kfree(ctx->phys_addrs);
> +       kfree(ctx);
> +}
> +
> +/**
> + * efi_capsule_build - alloc data buffer and fill out the header
> + * @guid: vendor's guid
> + * @data_size: size in bytes of the capsule data
> + *
> + * This is a helper function for allocating enough room for user data
> + * + the size of an EFI capsule header.
> + *
> + * Returns a pointer to an allocated capsule on success, an ERR_PTR()
> + * value on error.
> + */
> +static __init struct efi_capsule_ctx *efi_capsule_build(efi_guid_t guid,=
 size_t data_size)
> +{
> +       size_t capsule_size, needed_pages;
> +       struct efi_capsule_ctx *ctx;
> +       u32 flags;
> +       int rv;
> +
> +       flags =3D EFI_CAPSULE_PERSIST_ACROSS_RESET | EFI_CAPSULE_POPULATE=
_SYSTEM_TABLE;
> +       needed_pages =3D ALIGN(data_size + sizeof(efi_capsule_header_t), =
PAGE_SIZE) >> PAGE_SHIFT;
> +       capsule_size =3D needed_pages * PAGE_SIZE;
> +       data_size =3D capsule_size - sizeof(efi_capsule_header_t);
> +
> +       rv =3D efi_capsule_supported(LINUX_EFI_CRASH_GUID, flags, capsule=
_size, &efi_reset_type);
> +       if (rv)
> +               return ERR_PTR(rv);
> +
> +       ctx =3D kzalloc(sizeof(*ctx), GFP_KERNEL);
> +       if (!ctx)
> +               return ERR_PTR(-ENOMEM);
> +
> +       ctx->pages =3D kcalloc(needed_pages, sizeof(*ctx->pages), GFP_KER=
NEL);
> +       if (!ctx->pages)
> +               goto fail;
> +
> +       ctx->phys_addrs =3D kcalloc(needed_pages, sizeof(*ctx->phys_addrs=
), GFP_KERNEL);
> +       if (!ctx->phys_addrs)
> +               goto fail;
> +
> +       while (needed_pages--) {
> +               struct page *page =3D alloc_page(GFP_KERNEL | __GFP_HIGHM=
EM);
> +
> +               if (!page)
> +                       goto fail;
> +
> +               ctx->pages[ctx->nr_pages] =3D page;
> +               ctx->phys_addrs[ctx->nr_pages++] =3D page_to_phys(page);
> +       }
> +
> +       ctx->capsule =3D vmap(ctx->pages, ctx->nr_pages, 0, PAGE_KERNEL);
> +       if (!ctx->capsule)
> +               goto fail;
> +
> +       ctx->capsule_size =3D capsule_size;
> +       ctx->data =3D (void *)ctx->capsule + sizeof(efi_capsule_header_t)=
;
> +       ctx->data_size =3D data_size;
> +
> +       /* Setup the EFI capsule header */
> +       memcpy(&ctx->capsule->guid, &guid, sizeof(guid));
> +       ctx->capsule->flags =3D flags;
> +       ctx->capsule->headersize =3D sizeof(*ctx->capsule);
> +       ctx->capsule->imagesize =3D capsule_size;
> +
> +       return ctx;
> +
> +fail:
> +       efi_capsule_destroy(ctx);
> +       return ERR_PTR(-ENOMEM);
> +}
> +
> +#define BUILD_UPDATE_CAPSULE(name) \
> +       do { \
> +               name##_ctx =3D efi_capsule_build(LINUX_EFI_CRASH_GUID, CA=
PSULE_SIZE); \
> +               if (IS_ERR(name##_ctx)) { \
> +                       rv =3D PTR_ERR(name##_ctx); \
> +                       name##_ctx =3D NULL; \
> +                       pr_info("Fail to build %s capsule\n", #name); \
> +                       goto fail_##name; \
> +               } \
> +               rv =3D efi_capsule_update(name##_ctx->capsule, name##_ctx=
->phys_addrs); \
> +               if (rv) { \
> +                       pr_info("Fail to register %s with firmware\n", #n=
ame); \
> +                       goto fail_##name; \
> +               } \
> +       } while (0)
> +
> +#define INIT_PSTORE_RECORD(name, type_id) \
> +       do { \
> +               memset(name##_ctx->data, 0, name##_ctx->data_size); \
> +               pctx->name.size =3D name##_ctx->data_size; \
> +               pctx->name.buf =3D name##_ctx->data; \
> +               rec =3D pctx->name.buf; \
> +               rec->type =3D type_id; \
> +               rec->magic =3D CAPSULE_MAGIC; \
> +               atomic_long_set(&pctx->name.offset, 0); \
> +       } while (0)
> +
> +/**
> + * We may not be in a position to allocate memory at the time of a
> + * crash, so pre-allocate some space now and register it with the
> + * firmware via efi_capsule_update().
> + *
> + * Also, iterate through the array of capsules pointed to from the EFI
> + * system table and take note of any LINUX_EFI_CRASH_GUID
> + * capsules. They will be parsed by efi_capsule_pstore_read().
> + */
> +static __init int efi_capsule_pstore_setup(void)
> +{
> +       struct efi_capsule_ctx *console_ctx =3D NULL;
> +       struct efi_capsule_ctx *ftrace_ctx =3D NULL;
> +       struct efi_capsule_ctx *dmesg_ctx =3D NULL;
> +       struct efi_capsule_ctx *pmsg_ctx =3D NULL;
> +       struct efi_capsule_pstore *pctx =3D NULL;
> +       struct efi_capsule_pstore_record *rec;
> +       efi_capsule_header_t **hdrs;
> +       void *crash_buf =3D NULL;
> +       u32 hdrs_num =3D 0;
> +       int rv;
> +
> +       pctx =3D kzalloc(sizeof(*pctx), GFP_KERNEL);
> +       if (!pctx)
> +               return -ENOMEM;
> +
> +       crash_buf =3D kmalloc(CRASH_SIZE, GFP_KERNEL);
> +       if (!crash_buf) {
> +               rv =3D -ENOMEM;
> +               goto fail;
> +       }
> +
> +       /* Allocate and pass capsules to firmware upfront. */
> +       BUILD_UPDATE_CAPSULE(console);
> +       BUILD_UPDATE_CAPSULE(ftrace);
> +       BUILD_UPDATE_CAPSULE(dmesg);
> +       BUILD_UPDATE_CAPSULE(pmsg);
> +
> +       /* Initialize the pstore records. */
> +       INIT_PSTORE_RECORD(console, PSTORE_TYPE_CONSOLE);
> +       INIT_PSTORE_RECORD(ftrace, PSTORE_TYPE_FTRACE);
> +       INIT_PSTORE_RECORD(dmesg, PSTORE_TYPE_DMESG);
> +       INIT_PSTORE_RECORD(pmsg, PSTORE_TYPE_PMSG);
> +
> +       /* Read any pstore entries that were passed across a reboot. */
> +       hdrs =3D efi_capsule_lookup(LINUX_EFI_CRASH_GUID, &hdrs_num);
> +       pctx->hdrs_num =3D hdrs_num;
> +       pctx->hdrs =3D hdrs;
> +
> +       /* Register the capsule backend with pstore. */
> +       efi_capsule_pstore_info.buf =3D crash_buf;
> +       efi_capsule_pstore_info.data =3D pctx;
> +       rv =3D pstore_register(&efi_capsule_pstore_info);
> +
> +       if (!rv)
> +               return 0;
> +
> +       pr_err("Fail to register capsule support for pstore: %d\n", rv);
> +
> +       efi_capsule_destroy(pmsg_ctx);
> +fail_pmsg:
> +       efi_capsule_destroy(dmesg_ctx);
> +fail_dmesg:
> +       efi_capsule_destroy(ftrace_ctx);
> +fail_ftrace:
> +       efi_capsule_destroy(console_ctx);
> +fail_console:
> +       kfree(crash_buf);
> +fail:
> +       kfree(pctx);
> +
> +       return rv;
> +}
> +
> +/**
> + * Return the next pstore record that was passed to us across a reboot
> + * in an EFI capsule.
> + *
> + * This is expected to be called under the pstore
> + * read_mutex. Therefore, no serialisation is done here.
> + */
> +static struct efi_capsule_pstore_record *
> +get_pstore_read_record(struct efi_capsule_pstore *pctx)
> +{
> +       struct efi_capsule_pstore_record *rec;
> +       efi_capsule_header_t *hdr;
> +       off_t remaining;
> +
> +next:
> +       if (!pctx->hdrs_num)
> +               return NULL;
> +
> +       hdr =3D pctx->hdrs[pctx->hdrs_num - 1];
> +       rec =3D (void *)hdr + hdr->headersize + pctx->hdr_offset;
> +
> +       /*
> +        * A single EFI capsule may contain multiple pstore
> +        * records. It may also only be partially filled with pstore
> +        * records, which we can detect by checking for a record with
> +        * zero size.
> +        *
> +        * If there are no more records or invalid records in this capsul=
e try the next.
> +        */
> +       if (!rec->size || rec->size > CAPSULE_SIZE - sizeof(efi_capsule_h=
eader_t) - offsetof(typeof(*rec), data)) {
> +               pctx->hdrs_num--;
> +               pctx->hdr_offset =3D 0;
> +               goto next;
> +       }
> +
> +       remaining =3D hdr->imagesize - hdr->headersize - pctx->hdr_offset=
 - offsetof(typeof(*rec), data);
> +
> +       /*
> +        * If we've finished parsing all records in this capsule, move
> +        * onto the next. Otherwise, increment the offset into the
> +        * current capsule (pctx->hdr_offset).
> +        */
> +       if (rec->size =3D=3D remaining) {
> +               pctx->hdrs_num--;
> +               pctx->hdr_offset =3D 0;
> +       } else {
> +               pctx->hdr_offset +=3D rec->size + offsetof(typeof(*rec), =
data);
> +       }
> +
> +       return rec;
> +}
> +
> +static ssize_t efi_capsule_pstore_read(struct pstore_record *record)
> +{
> +       struct efi_capsule_pstore *pctx =3D record->psi->data;
> +       struct efi_capsule_pstore_record *rec;
> +       ssize_t size;
> +
> +       rec =3D get_pstore_read_record(pctx);
> +       if (!rec)
> +               return 0;
> +
> +       if (rec->magic !=3D CAPSULE_MAGIC) {
> +               pr_info("Invalid capsule record!\n");
> +               return 0;
> +       }
> +
> +       record->type =3D rec->type;
> +       record->time.tv_sec =3D rec->timestamp;
> +       record->time.tv_nsec =3D 0;
> +       size =3D rec->size;
> +       record->id =3D rec->id;
> +       record->compressed =3D rec->compressed;
> +       record->ecc_notice_size =3D 0;
> +       record->buf =3D kmalloc(size, GFP_KERNEL);
> +
> +       if (!record->buf)
> +               return -ENOMEM;
> +
> +       memcpy(record->buf, rec->data, size);
> +
> +       return size;
> +}
> +
> +/*
> + * We expect to be called with ->buf_lock held, and so don't perform
> + * any serialisation.
> + */
> +static struct notrace efi_capsule_pstore_record *
> +get_pstore_write_record(struct efi_capsule_pstore_buf *pbuf, size_t *siz=
e)
> +{
> +       struct efi_capsule_pstore_record *rec;
> +       long offset =3D atomic_long_read(&pbuf->offset);
> +
> +       if (offset + offsetof(typeof(*rec), data) >=3D pbuf->size)
> +               return NULL;
> +
> +       /* Trim 'size' if there isn't enough remaining space */
> +       if (offset + *size + offsetof(typeof(*rec), data) > pbuf->size)
> +               *size =3D pbuf->size - offset - offsetof(typeof(*rec), da=
ta);
> +
> +       rec =3D pbuf->buf + offset;
> +       atomic_long_add(offsetof(typeof(*rec), data) + *size, &pbuf->offs=
et);
> +
> +       return rec;
> +}
> +
> +static notrace void *get_pstore_write_ring_buf(struct efi_capsule_pstore=
_buf *pbuf, size_t size)
> +{
> +       struct efi_capsule_pstore_record *rec =3D pbuf->buf;
> +       size_t ring_size =3D pbuf->size - offsetof(typeof(*rec), data);
> +       void *ring_buf =3D pbuf->buf + offsetof(typeof(*rec), data);
> +       atomic_long_t *ring_offset =3D &pbuf->offset;
> +       long next, curr;
> +
> +       if (size > ring_size)
> +               return NULL;
> +
> +       if (rec->size + size > ring_size)
> +               rec->size =3D ring_size;
> +       else
> +               rec->size +=3D size;
> +
> +       do {
> +               curr =3D atomic_long_read(ring_offset);
> +               next =3D curr + size;
> +
> +               if (next > ring_size) {
> +                       next =3D size;
> +                       if (atomic_long_cmpxchg(ring_offset, curr, next))=
 {
> +                               curr =3D 0;
> +                               break;
> +                       }
> +                       continue;
> +               }
> +
> +       } while (atomic_long_cmpxchg(ring_offset, curr, next) !=3D curr);
> +
> +       return ring_buf + curr;
> +}
> +
> +static int notrace efi_capsule_pstore_write(struct pstore_record *record=
)
> +{
> +       struct efi_capsule_pstore *pctx =3D record->psi->data;
> +       struct efi_capsule_pstore_record *rec;
> +       static atomic64_t seq;
> +       void *dst;
> +
> +       /*
> +        * A zero size record would break our detection of
> +        * partially-filled capsules.
> +        */
> +       if (!record->size)
> +               return -EINVAL;
> +
> +       if (record->type =3D=3D PSTORE_TYPE_CONSOLE) {
> +               dst =3D get_pstore_write_ring_buf(&pctx->console, record-=
>size);
> +       } else if (record->type =3D=3D PSTORE_TYPE_FTRACE) {
> +               dst =3D get_pstore_write_ring_buf(&pctx->ftrace, record->=
size);
> +       } else if (record->type =3D=3D PSTORE_TYPE_DMESG) {
> +               size_t size =3D record->size;
> +
> +               rec =3D get_pstore_write_record(&pctx->dmesg, &record->si=
ze);
> +               if (!rec || (record->compressed && record->size < size))
> +                       return -ENOSPC;
> +
> +               rec->type =3D record->type;
> +               rec->timestamp =3D record->time.tv_sec;
> +               rec->size =3D record->size;
> +               if (!atomic64_read(&seq))
> +                       atomic64_set(&seq, rec->timestamp << 32);
> +               record->id =3D atomic64_inc_return(&seq);
> +               rec->id =3D record->id;
> +               rec->compressed =3D record->compressed;
> +               rec->magic =3D CAPSULE_MAGIC;
> +
> +               dst =3D rec->data;
> +       } else if (record->type =3D=3D PSTORE_TYPE_PMSG) {
> +               pr_warn_ratelimited("PMSG should not call %s\n", __func__=
);
> +               return -EINVAL;
> +       } else {
> +               return -EINVAL;
> +       }
> +
> +       if (!dst)
> +               return -ENOSPC;
> +
> +       memcpy(dst, record->buf, record->size);
> +
> +       return 0;
> +}
> +
> +static int notrace efi_capsule_pstore_write_user(struct pstore_record *r=
ecord, const char __user *buf)
> +{
> +       struct efi_capsule_pstore *pctx =3D record->psi->data;
> +       void *dst;
> +
> +       if (record->type =3D=3D PSTORE_TYPE_PMSG) {
> +               dst =3D get_pstore_write_ring_buf(&pctx->pmsg, record->si=
ze);
> +               if (!dst)
> +                       return -ENOSPC;
> +
> +               if (unlikely(__copy_from_user(dst, buf, record->size)))
> +                       return -EFAULT;
> +
> +               return 0;
> +       }
> +
> +       return -EINVAL;
> +}
> +
> +static __init int check_capsule_support(void)
> +{
> +       int rv;
> +
> +       efi_guid_t guid =3D LINUX_EFI_CRASH_GUID;
> +       u32 flags =3D EFI_CAPSULE_PERSIST_ACROSS_RESET |
> +               EFI_CAPSULE_POPULATE_SYSTEM_TABLE;
> +
> +       rv =3D efi_capsule_supported(guid, flags, CAPSULE_SIZE, &efi_rese=
t_type);
> +       if (rv)
> +               return rv;
> +
> +       return 0;
> +}
> +
> +static __init int efi_capsule_pstore_init(void)
> +{
> +       int rv =3D 0;
> +
> +       if (!efi_enabled(EFI_RUNTIME_SERVICES))
> +               return -ENODEV;
> +
> +       if (efi_capsule_pstore_disable) {
> +               pr_info("Capsule-pstore is disabled\n ");
> +               return 0;
> +       }
> +
> +       rv =3D check_capsule_support();
> +       if (rv) {
> +               pr_info("Capsule-pstore is not supported: %d\n ", rv);
> +               return rv;
> +       }
> +
> +       rv =3D efi_capsule_pstore_setup();
> +       if (rv) {
> +               pr_err("Fail to setup capsule-pstore: %d\n", rv);
> +               return rv;
> +       }
> +
> +       /*
> +        * Once the memory reserved for capsules passed to the firmware
> +        * by EFI UpdateCapsule(), there's no way to let firmware give up
> +        * the capsules. So this module cannot be unloaded once loaded.
> +        */
> +       __module_get(THIS_MODULE);
> +
> +       return 0;
> +}
> +
> +static __exit void efi_capsule_pstore_exit(void) {}
> +
> +module_init(efi_capsule_pstore_init);
> +module_exit(efi_capsule_pstore_exit);
> +
> +module_param_named(pstore_disable, efi_capsule_pstore_disable, bool, 064=
4);
> +
> +MODULE_DESCRIPTION("EFI capsule backend for pstore");
> +MODULE_LICENSE("GPL v2");
> --
> 2.9.0.GIT
>
