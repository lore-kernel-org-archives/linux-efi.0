From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efivars: avoid potential null-dereference
Date: Thu, 8 Jan 2015 10:02:39 +0200
Message-ID: <CAHp75VfWWwC4z-50eDhYNgPezY18fYk6YiHfmBJ1RxLdTsc3Sg@mail.gmail.com>
References: <1420596500-32158-1-git-send-email-andy.shevchenko@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420596500-32158-1-git-send-email-andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 7, 2015 at 4:08 AM, Andy Shevchenko
<andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> We have to check the pointer before dereferencing it. The patch fixes
> such issues in the efivars module.

Discard this, sorry for noise.

>
> Signed-off-by: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/efivars.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
> index f256ecd..e62ef79 100644
> --- a/drivers/firmware/efi/efivars.c
> +++ b/drivers/firmware/efi/efivars.c
> @@ -122,12 +122,14 @@ efivar_create_sysfs_entry(struct efivar_entry *new_var);
>  static ssize_t
>  efivar_guid_read(struct efivar_entry *entry, char *buf)
>  {
> -       struct efi_variable *var = &entry->var;
> +       struct efi_variable *var;
>         char *str = buf;
>
>         if (!entry || !buf)
>                 return 0;
>
> +       var = &entry->var;
> +
>         efi_guid_unparse(&var->VendorGuid, str);
>         str += strlen(str);
>         str += sprintf(str, "\n");
> @@ -138,12 +140,14 @@ efivar_guid_read(struct efivar_entry *entry, char *buf)
>  static ssize_t
>  efivar_attr_read(struct efivar_entry *entry, char *buf)
>  {
> -       struct efi_variable *var = &entry->var;
> +       struct efi_variable *var;
>         char *str = buf;
>
>         if (!entry || !buf)
>                 return -EINVAL;
>
> +       var = &entry->var;
> +
>         var->DataSize = 1024;
>         if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
>                 return -EIO;
> @@ -171,12 +175,14 @@ efivar_attr_read(struct efivar_entry *entry, char *buf)
>  static ssize_t
>  efivar_size_read(struct efivar_entry *entry, char *buf)
>  {
> -       struct efi_variable *var = &entry->var;
> +       struct efi_variable *var;
>         char *str = buf;
>
>         if (!entry || !buf)
>                 return -EINVAL;
>
> +       var = &entry->var;
> +
>         var->DataSize = 1024;
>         if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
>                 return -EIO;
> @@ -188,11 +194,13 @@ efivar_size_read(struct efivar_entry *entry, char *buf)
>  static ssize_t
>  efivar_data_read(struct efivar_entry *entry, char *buf)
>  {
> -       struct efi_variable *var = &entry->var;
> +       struct efi_variable *var;
>
>         if (!entry || !buf)
>                 return -EINVAL;
>
> +       var = &entry->var;
> +
>         var->DataSize = 1024;
>         if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
>                 return -EIO;
> @@ -280,7 +288,7 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
>                 if (err)
>                         return err;
>
> -               copy_out_compat(&entry->var, compat);
> +               copy_out_compat(var, compat);
>         } else {
>                 if (count != sizeof(struct efi_variable))
>                         return -EINVAL;
> @@ -297,7 +305,7 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
>                 if (err)
>                         return err;
>
> -               memcpy(&entry->var, new_var, count);
> +               memcpy(var, new_var, count);
>         }
>
>         err = efivar_entry_set(entry, attributes, size, data, NULL);
> @@ -312,13 +320,15 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
>  static ssize_t
>  efivar_show_raw(struct efivar_entry *entry, char *buf)
>  {
> -       struct efi_variable *var = &entry->var;
> +       struct efi_variable *var;
>         struct compat_efi_variable *compat;
>         size_t size;
>
>         if (!entry || !buf)
>                 return 0;
>
> +       var = &entry->var;
> +
>         var->DataSize = 1024;
>         if (efivar_entry_get(entry, &entry->var.Attributes,
>                              &entry->var.DataSize, entry->var.Data))
> --
> 1.8.3.101.g727a46b
>



-- 
With Best Regards,
Andy Shevchenko
