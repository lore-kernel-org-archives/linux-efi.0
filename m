From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 1/4] efi/x86: move efi bgrt init code to early init code
Date: Tue, 17 Jan 2017 17:10:14 +0000
Message-ID: <CAKv+Gu-pLxSceJnYTb-to93S5OeVc6bNyGbZ_R6SPg11vJd-0w@mail.gmail.com>
References: <20170116024554.461236678@redhat.com> <20170116025026.435634158@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170116025026.435634158-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 16 January 2017 at 02:45, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Before invoking the arch specific handler, efi_mem_reserve() reserves
> the given memory region through memblock.
>
> efi_bgrt_init will call efi_mem_reserve after mm_init(), at that time
> memblock is dead and it should not be used any more.
>
> efi bgrt code depend on acpi intialization to get the bgrt acpi table,
> moving bgrt parsing to acpi early boot code can make sure efi_mem_reserve
> in efi bgrt code still use memblock safely.
>
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> v1->v2: efi_bgrt_init: check table length first before copying bgrt table
>         error checking in drivers/acpi/bgrt.c
>  arch/x86/kernel/acpi/boot.c      |   12 +++++++
>  arch/x86/platform/efi/efi-bgrt.c |   59 ++++++++++++++++-----------------------
>  arch/x86/platform/efi/efi.c      |    5 ---
>  drivers/acpi/bgrt.c              |   28 +++++++++++++-----
>  include/linux/efi-bgrt.h         |    7 +---
>  init/main.c                      |    1
>  6 files changed, 60 insertions(+), 52 deletions(-)
>
> --- linux-x86.orig/arch/x86/kernel/acpi/boot.c
> +++ linux-x86/arch/x86/kernel/acpi/boot.c
> @@ -35,6 +35,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/ioport.h>
>  #include <linux/pci.h>
> +#include <linux/efi-bgrt.h>
>
>  #include <asm/irqdomain.h>
>  #include <asm/pci_x86.h>
> @@ -1557,6 +1558,14 @@ int __init early_acpi_boot_init(void)
>         return 0;
>  }
>
> +#ifdef CONFIG_ACPI_BGRT
> +static int __init acpi_parse_bgrt(struct acpi_table_header *table)
> +{
> +       efi_bgrt_init(table);
> +       return 0;
> +}
> +#endif
> +

Please drop the #ifdef / #endif

>  int __init acpi_boot_init(void)
>  {
>         /* those are executed after early-quirks are executed */
> @@ -1581,6 +1590,9 @@ int __init acpi_boot_init(void)
>         acpi_process_madt();
>
>         acpi_table_parse(ACPI_SIG_HPET, acpi_parse_hpet);
> +#ifdef CONFIG_ACPI_BGRT

Please replace with

if (IS_ENABLED(CONFIG_ACPI_BGRT))

> +       acpi_table_parse("BGRT", acpi_parse_bgrt);
> +#endif
>

and perhaps we should add a #define for ACPI_SIG_BGRT as well?

>         if (!acpi_noirq)
>                 x86_init.pci.init = pci_acpi_init;
> --- linux-x86.orig/arch/x86/platform/efi/efi-bgrt.c
> +++ linux-x86/arch/x86/platform/efi/efi-bgrt.c
> @@ -19,8 +19,7 @@
>  #include <linux/efi.h>
>  #include <linux/efi-bgrt.h>
>
> -struct acpi_table_bgrt *bgrt_tab;
> -void *__initdata bgrt_image;
> +struct acpi_table_bgrt bgrt_tab;
>  size_t __initdata bgrt_image_size;
>
>  struct bmp_header {
> @@ -28,66 +27,58 @@ struct bmp_header {
>         u32 size;
>  } __packed;
>
> -void __init efi_bgrt_init(void)
> +void __init efi_bgrt_init(struct acpi_table_header *table)
>  {
> -       acpi_status status;
>         void *image;
>         struct bmp_header bmp_header;
> +       struct acpi_table_bgrt *bgrt = &bgrt_tab;
>
>         if (acpi_disabled)
>                 return;
>
> -       status = acpi_get_table("BGRT", 0,
> -                               (struct acpi_table_header **)&bgrt_tab);
> -       if (ACPI_FAILURE(status))
> -               return;
> -
> -       if (bgrt_tab->header.length < sizeof(*bgrt_tab)) {
> +       if (table->length < sizeof(bgrt_tab)) {
>                 pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
> -                      bgrt_tab->header.length, sizeof(*bgrt_tab));
> +                      table->length, sizeof(bgrt_tab));
>                 return;
>         }
> -       if (bgrt_tab->version != 1) {
> +       *bgrt = *(struct acpi_table_bgrt *)table;
> +       if (bgrt->version != 1) {
>                 pr_notice("Ignoring BGRT: invalid version %u (expected 1)\n",
> -                      bgrt_tab->version);
> -               return;
> +                      bgrt->version);
> +               goto out;
>         }
> -       if (bgrt_tab->status & 0xfe) {
> +       if (bgrt->status & 0xfe) {
>                 pr_notice("Ignoring BGRT: reserved status bits are non-zero %u\n",
> -                      bgrt_tab->status);
> -               return;
> +                      bgrt->status);
> +               goto out;
>         }
> -       if (bgrt_tab->image_type != 0) {
> +       if (bgrt->image_type != 0) {
>                 pr_notice("Ignoring BGRT: invalid image type %u (expected 0)\n",
> -                      bgrt_tab->image_type);
> -               return;
> +                      bgrt->image_type);
> +               goto out;
>         }
> -       if (!bgrt_tab->image_address) {
> +       if (!bgrt->image_address) {
>                 pr_notice("Ignoring BGRT: null image address\n");
> -               return;
> +               goto out;
>         }
>
> -       image = memremap(bgrt_tab->image_address, sizeof(bmp_header), MEMREMAP_WB);
> +       image = early_memremap(bgrt->image_address, sizeof(bmp_header));
>         if (!image) {
>                 pr_notice("Ignoring BGRT: failed to map image header memory\n");
> -               return;
> +               goto out;
>         }
>
>         memcpy(&bmp_header, image, sizeof(bmp_header));
> -       memunmap(image);
> +       early_memunmap(image, sizeof(bmp_header));
>         if (bmp_header.id != 0x4d42) {
>                 pr_notice("Ignoring BGRT: Incorrect BMP magic number 0x%x (expected 0x4d42)\n",
>                         bmp_header.id);
> -               return;
> +               goto out;
>         }
>         bgrt_image_size = bmp_header.size;
> +       efi_mem_reserve(bgrt->image_address, bgrt_image_size);
>
> -       bgrt_image = memremap(bgrt_tab->image_address, bmp_header.size, MEMREMAP_WB);
> -       if (!bgrt_image) {
> -               pr_notice("Ignoring BGRT: failed to map image memory\n");
> -               bgrt_image = NULL;
> -               return;
> -       }
> -
> -       efi_mem_reserve(bgrt_tab->image_address, bgrt_image_size);
> +       return;
> +out:
> +       memset(bgrt, 0, sizeof(bgrt_tab));
>  }
> --- linux-x86.orig/drivers/acpi/bgrt.c
> +++ linux-x86/drivers/acpi/bgrt.c
> @@ -15,40 +15,41 @@
>  #include <linux/sysfs.h>
>  #include <linux/efi-bgrt.h>
>
> +static void *bgrt_image;
>  static struct kobject *bgrt_kobj;
>
>  static ssize_t show_version(struct device *dev,
>                             struct device_attribute *attr, char *buf)
>  {
> -       return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab->version);
> +       return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.version);
>  }
>  static DEVICE_ATTR(version, S_IRUGO, show_version, NULL);
>
>  static ssize_t show_status(struct device *dev,
>                            struct device_attribute *attr, char *buf)
>  {
> -       return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab->status);
> +       return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.status);
>  }
>  static DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
>
>  static ssize_t show_type(struct device *dev,
>                          struct device_attribute *attr, char *buf)
>  {
> -       return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab->image_type);
> +       return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.image_type);
>  }
>  static DEVICE_ATTR(type, S_IRUGO, show_type, NULL);
>
>  static ssize_t show_xoffset(struct device *dev,
>                             struct device_attribute *attr, char *buf)
>  {
> -       return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab->image_offset_x);
> +       return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.image_offset_x);
>  }
>  static DEVICE_ATTR(xoffset, S_IRUGO, show_xoffset, NULL);
>
>  static ssize_t show_yoffset(struct device *dev,
>                             struct device_attribute *attr, char *buf)
>  {
> -       return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab->image_offset_y);
> +       return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.image_offset_y);
>  }
>  static DEVICE_ATTR(yoffset, S_IRUGO, show_yoffset, NULL);
>
> @@ -84,15 +85,24 @@ static int __init bgrt_init(void)
>  {
>         int ret;
>
> -       if (!bgrt_image)
> +       if (!bgrt_tab.image_address)
>                 return -ENODEV;
>
> +       bgrt_image = memremap(bgrt_tab.image_address, bgrt_image_size,
> +                             MEMREMAP_WB);
> +       if (!bgrt_image) {
> +               pr_notice("Ignoring BGRT: failed to map image memory\n");
> +               return -ENOMEM;
> +       }
> +
>         bin_attr_image.private = bgrt_image;
>         bin_attr_image.size = bgrt_image_size;
>
>         bgrt_kobj = kobject_create_and_add("bgrt", acpi_kobj);
> -       if (!bgrt_kobj)
> -               return -EINVAL;
> +       if (!bgrt_kobj) {
> +               ret = -EINVAL;
> +               goto out_memmap;
> +       }
>
>         ret = sysfs_create_group(bgrt_kobj, &bgrt_attribute_group);
>         if (ret)
> @@ -102,6 +112,8 @@ static int __init bgrt_init(void)
>
>  out_kobject:
>         kobject_put(bgrt_kobj);
> +out_memmap:
> +       memunmap(bgrt_image);
>         return ret;
>  }
>  device_initcall(bgrt_init);
> --- linux-x86.orig/include/linux/efi-bgrt.h
> +++ linux-x86/include/linux/efi-bgrt.h
> @@ -5,16 +5,15 @@
>
>  #include <linux/acpi.h>
>
> -void efi_bgrt_init(void);
> +void efi_bgrt_init(struct acpi_table_header *table);
>
>  /* The BGRT data itself; only valid if bgrt_image != NULL. */
> -extern void *bgrt_image;
>  extern size_t bgrt_image_size;
> -extern struct acpi_table_bgrt *bgrt_tab;
> +extern struct acpi_table_bgrt bgrt_tab;
>
>  #else /* !CONFIG_ACPI_BGRT */
>
> -static inline void efi_bgrt_init(void) {}
> +static inline void efi_bgrt_init(struct acpi_table_header *table) {}
>
>  #endif /* !CONFIG_ACPI_BGRT */
>
> --- linux-x86.orig/arch/x86/platform/efi/efi.c
> +++ linux-x86/arch/x86/platform/efi/efi.c
> @@ -546,11 +546,6 @@ void __init efi_init(void)
>                 efi_print_memmap();
>  }
>
> -void __init efi_late_init(void)
> -{
> -       efi_bgrt_init();
> -}
> -
>  void __init efi_set_executable(efi_memory_desc_t *md, bool executable)
>  {
>         u64 addr, npages;
> --- linux-x86.orig/init/main.c
> +++ linux-x86/init/main.c
> @@ -663,7 +663,6 @@ asmlinkage __visible void __init start_k
>         sfi_init_late();
>
>         if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> -               efi_late_init();
>                 efi_free_boot_services();
>         }
>
>
>
