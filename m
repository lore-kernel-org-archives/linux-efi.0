From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efivar: Disable get_next_variable when firmware is broken
Date: Tue, 19 Mar 2013 14:23:59 -0700
Message-ID: <CAGTjWtCeJYuss271R-JESqrOSeMxiNEKLznGSDZvWmgSDNajgg@mail.gmail.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF6FBF6@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF6FBF6-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Matt Fleming (matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org)" <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "Andre Heider (a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)" <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Lingzhu Xiang (lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Satoru Moriya <satoru.moriya-7rDLJAbr9SE@public.gmane.org>, Tomoki Sekiyama <tomoki.sekiyama-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 19, 2013 at 2:17 PM, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org> wrote:
>
> [Problem]
> Some firmware implementations return the same variable name on multiple calls to
> get_next_variable().
> In this case, an efivar driver gets stuck in a infinite loop at initializing time,
> register_efivars().
> It is hard for users to fix the broken firmware.
>
> Here is an actual result of the case above.
> http://article.gmane.org/gmane.linux.kernel.efi/835
>
> [Solution]
> This patch terminates the loop immediately and disables get_next_variable()
> at the initializing time when the same variable name is found on multiple
> calls to get_next_variable().
>
> Also, to avoid stucking in the infinite loop,
> update_sysfs_entries returns without calling get_next_variable if the case above happens.
>
> Reported-by: Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reported-by: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
> ---
>  drivers/firmware/efivars.c     |   34 ++++++++++++++++++++++++++++++++--
>  drivers/firmware/google/gsmi.c |    4 +++-
>  include/linux/efi.h            |    3 ++-
>  3 files changed, 37 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index fe62aa3..fa601c6 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -1725,6 +1725,14 @@ static void efivar_update_sysfs_entries(struct work_struct *work)
>         efi_status_t status = EFI_NOT_FOUND;
>         bool found;
>
> +       spin_lock_irq(&efivars->lock);
> +       if (!efivars->ops->get_next_variable) {
> +                       spin_unlock_irq(&efivars->lock);
> +                       pr_warn("efivars: Skip updating sysfs entries\n");
> +                       return;
> +       }
> +       spin_unlock_irq(&efivars->lock);
> +
>         /* Add new sysfs entries */
>         while (1) {
>                 variable_name = kzalloc(variable_name_size, GFP_KERNEL);
> @@ -1960,7 +1968,8 @@ EXPORT_SYMBOL_GPL(unregister_efivars);
>
>  int register_efivars(struct efivars *efivars,
>                      const struct efivar_operations *ops,
> -                    struct kobject *parent_kobj)
> +                    struct kobject *parent_kobj,
> +                    bool *get_next_variable_cannot_call)
>  {
>         efi_status_t status = EFI_NOT_FOUND;
>         efi_guid_t vendor_guid;
> @@ -2006,6 +2015,21 @@ int register_efivars(struct efivars *efivars,
>                                                 &vendor_guid);
>                 switch (status) {
>                 case EFI_SUCCESS:
> +                       /*
> +                        * Some firmware implementations return the
> +                        * same variable name on multiple calls to
> +                        * get_next_variable(). Terminate the loop
> +                        * immediately as there is no guarantee that
> +                        * we'll ever see a different variable name,
> +                        * and may end up looping here forever.
> +                        */
> +                       if (variable_is_present(variable_name, &vendor_guid)) {
> +                               pr_warn("efivars: duplicate variable name.\n");
> +                               *get_next_variable_cannot_call = true;
> +                               status = EFI_NOT_FOUND;
> +                               break;
> +                       }
> +
>                         efivar_create_sysfs_entry(efivars,
>                                                   variable_name_size,
>                                                   variable_name,
> @@ -2056,6 +2080,7 @@ static int __init
>  efivars_init(void)
>  {
>         int error = 0;
> +       bool get_next_variable_cannot_call = false;
>
>         printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
>                EFIVARS_DATE);
> @@ -2075,7 +2100,12 @@ efivars_init(void)
>         ops.get_next_variable = efi.get_next_variable;
>         ops.query_variable_info = efi.query_variable_info;
>
> -       error = register_efivars(&__efivars, &ops, efi_kobj);
> +       error = register_efivars(&__efivars, &ops, efi_kobj,
> +                                &get_next_variable_cannot_call);
> +       if (get_next_variable_cannot_call) {
> +               pr_warn("efivars: Disable get_next_variable service\n");
> +               ops.get_next_variable = NULL;

I don't like this pattern of clearing out ops fields.  Can you instead
just add a flag in efivars that is checked before calling
ops->get_next_variable?

> +       }
>         if (error)
>                 goto err_put;
>
> diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
> index 91ddf0f..0c205c8 100644
> --- a/drivers/firmware/google/gsmi.c
> +++ b/drivers/firmware/google/gsmi.c
> @@ -778,6 +778,7 @@ static __init int gsmi_init(void)
>  {
>         unsigned long flags;
>         int ret;
> +       bool get_next_variable_cannot_call = false;
>
>         ret = gsmi_system_valid();
>         if (ret)
> @@ -893,7 +894,8 @@ static __init int gsmi_init(void)
>                 goto out_remove_bin_file;
>         }
>
> -       ret = register_efivars(&efivars, &efivar_ops, gsmi_kobj);
> +       ret = register_efivars(&efivars, &efivar_ops, gsmi_kobj,
> +                              &get_next_variable_cannot_call);
>         if (ret) {
>                 printk(KERN_INFO "gsmi: Failed to register efivars\n");
>                 goto out_remove_sysfs_files;
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 9bf2f1f..9db51b1 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -756,7 +756,8 @@ struct efivars {
>
>  int register_efivars(struct efivars *efivars,
>                      const struct efivar_operations *ops,
> -                    struct kobject *parent_kobj);
> +                    struct kobject *parent_kobj,
> +                    bool *get_next_variable_cannot_call);
>  void unregister_efivars(struct efivars *efivars);
>
>  #endif /* CONFIG_EFI_VARS */
> -- 1.7.1
