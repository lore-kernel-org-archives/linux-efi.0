From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] efi: move some sysfs files to be read-only by root
Date: Tue, 5 Dec 2017 18:15:15 +0000
Message-ID: <CAKv+Gu_+xU9=6X_AaciA3_0D5OHO-ixirSSn95yH+Cx=ga_Rwg@mail.gmail.com>
References: <20171205101343.GA5416@kroah.com> <20171205104158.GA2230@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171205104158.GA2230@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Dave Young <dyoung@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Tobin C. Harding" <me@tobin.cc>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 5 December 2017 at 10:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> Thanks to the scripts/leaking_addresses.pl script, it was found that
> some EFI values should not be readable by non-root users.
>
> So make them root-only, and to do that, add a __ATTR_RO_MODE() macro to
> make this easier, and use it in other places at the same time.
>
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Tested-by: Dave Young <dyoung@redhat.com>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
> v2: add VERIFY_OCTAL_PERMISSIONS to __ATTR_RO_MODE() as pointed out by
>     Ard.
>

Thanks. I will queue this as a fix in the EFI tree (as well as Dave's
patch that adds the systab comment)

>  drivers/firmware/efi/efi.c         |    3 +--
>  drivers/firmware/efi/esrt.c        |   15 ++++++---------
>  drivers/firmware/efi/runtime-map.c |   10 +++++-----
>  include/linux/sysfs.h              |    6 ++++++
>  4 files changed, 18 insertions(+), 16 deletions(-)
>
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -143,8 +143,7 @@ static ssize_t systab_show(struct kobjec
>         return str - buf;
>  }
>
> -static struct kobj_attribute efi_attr_systab =
> -                       __ATTR(systab, 0400, systab_show, NULL);
> +static struct kobj_attribute efi_attr_systab = __ATTR_RO_MODE(systab, 0400);
>
>  #define EFI_FIELD(var) efi.var
>
> --- a/drivers/firmware/efi/esrt.c
> +++ b/drivers/firmware/efi/esrt.c
> @@ -106,7 +106,7 @@ static const struct sysfs_ops esre_attr_
>  };
>
>  /* Generic ESRT Entry ("ESRE") support. */
> -static ssize_t esre_fw_class_show(struct esre_entry *entry, char *buf)
> +static ssize_t fw_class_show(struct esre_entry *entry, char *buf)
>  {
>         char *str = buf;
>
> @@ -117,18 +117,16 @@ static ssize_t esre_fw_class_show(struct
>         return str - buf;
>  }
>
> -static struct esre_attribute esre_fw_class = __ATTR(fw_class, 0400,
> -       esre_fw_class_show, NULL);
> +static struct esre_attribute esre_fw_class = __ATTR_RO_MODE(fw_class, 0400);
>
>  #define esre_attr_decl(name, size, fmt) \
> -static ssize_t esre_##name##_show(struct esre_entry *entry, char *buf) \
> +static ssize_t name##_show(struct esre_entry *entry, char *buf) \
>  { \
>         return sprintf(buf, fmt "\n", \
>                        le##size##_to_cpu(entry->esre.esre1->name)); \
>  } \
>  \
> -static struct esre_attribute esre_##name = __ATTR(name, 0400, \
> -       esre_##name##_show, NULL)
> +static struct esre_attribute esre_##name = __ATTR_RO_MODE(name, 0400)
>
>  esre_attr_decl(fw_type, 32, "%u");
>  esre_attr_decl(fw_version, 32, "%u");
> @@ -193,14 +191,13 @@ static int esre_create_sysfs_entry(void
>
>  /* support for displaying ESRT fields at the top level */
>  #define esrt_attr_decl(name, size, fmt) \
> -static ssize_t esrt_##name##_show(struct kobject *kobj, \
> +static ssize_t name##_show(struct kobject *kobj, \
>                                   struct kobj_attribute *attr, char *buf)\
>  { \
>         return sprintf(buf, fmt "\n", le##size##_to_cpu(esrt->name)); \
>  } \
>  \
> -static struct kobj_attribute esrt_##name = __ATTR(name, 0400, \
> -       esrt_##name##_show, NULL)
> +static struct kobj_attribute esrt_##name = __ATTR_RO_MODE(name, 0400)
>
>  esrt_attr_decl(fw_resource_count, 32, "%u");
>  esrt_attr_decl(fw_resource_count_max, 32, "%u");
> --- a/drivers/firmware/efi/runtime-map.c
> +++ b/drivers/firmware/efi/runtime-map.c
> @@ -63,11 +63,11 @@ static ssize_t map_attr_show(struct kobj
>         return map_attr->show(entry, buf);
>  }
>
> -static struct map_attribute map_type_attr = __ATTR_RO(type);
> -static struct map_attribute map_phys_addr_attr   = __ATTR_RO(phys_addr);
> -static struct map_attribute map_virt_addr_attr  = __ATTR_RO(virt_addr);
> -static struct map_attribute map_num_pages_attr  = __ATTR_RO(num_pages);
> -static struct map_attribute map_attribute_attr  = __ATTR_RO(attribute);
> +static struct map_attribute map_type_attr = __ATTR_RO_MODE(type, 0400);
> +static struct map_attribute map_phys_addr_attr = __ATTR_RO_MODE(phys_addr, 0400);
> +static struct map_attribute map_virt_addr_attr = __ATTR_RO_MODE(virt_addr, 0400);
> +static struct map_attribute map_num_pages_attr = __ATTR_RO_MODE(num_pages, 0400);
> +static struct map_attribute map_attribute_attr = __ATTR_RO_MODE(attribute, 0400);
>
>  /*
>   * These are default attributes that are added for every memmap entry.
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -117,6 +117,12 @@ struct attribute_group {
>         .show   = _name##_show,                                         \
>  }
>
> +#define __ATTR_RO_MODE(_name, _mode) {                                 \
> +       .attr   = { .name = __stringify(_name),                         \
> +                   .mode = VERIFY_OCTAL_PERMISSIONS(_mode) },          \
> +       .show   = _name##_show,                                         \
> +}
> +
>  #define __ATTR_WO(_name) {                                             \
>         .attr   = { .name = __stringify(_name), .mode = S_IWUSR },      \
>         .store  = _name##_store,                                        \
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
