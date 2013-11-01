From: Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Make efi-pstore return a unique id
Date: Fri, 1 Nov 2013 17:28:59 +0100
Message-ID: <CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com>
References: <87ppqk6qvx.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87ppqk6qvx.fsf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?B?6LCi5oiQ6aqP?= <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 1, 2013 at 5:14 PM, Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Pstore fs expects that backends provide a uniqued id which could avoid
> pstore making entries as duplication or denominating entries the same
> name. So I combine the timestamp, part and count into id.
>
> Signed-off-by: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/efi-pstore.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
> index 5002d50..0de9179 100644
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -39,6 +39,17 @@ struct pstore_read_data {
>         char **buf;
>  };
>
> +static u64 efi_generate_id(unsigned long timestamp, unsigned int part, int count)
> +{
> +       char id_str[64];
> +       u64 id = 0;
> +
> +       sprintf(id_str, "%lu%u%d", timestamp, part, count);
> +       if (kstrtoull(id_str, 10, &id))
> +               pr_warn("efi-pstore: failed to generate id\n");
> +       return id;
> +}

This is just odd. You make a string from three ints and then a parse
it to a int again.

>  static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
>  {
>         efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
> @@ -57,17 +68,18 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
>
>         if (sscanf(name, "dump-type%u-%u-%d-%lu-%c",
>                    cb_data->type, &part, &cnt, &time, &data_type) == 5) {
> -               *cb_data->id = part;
> +               *cb_data->id = efi_generate_id(time, part, cnt);
>                 *cb_data->count = cnt;
>                 cb_data->timespec->tv_sec = time;
>                 cb_data->timespec->tv_nsec = 0;
> +
>                 if (data_type == 'C')
>                         *cb_data->compressed = true;
>                 else
>                         *cb_data->compressed = false;
>         } else if (sscanf(name, "dump-type%u-%u-%d-%lu",
>                    cb_data->type, &part, &cnt, &time) == 4) {
> -               *cb_data->id = part;
> +               *cb_data->id = efi_generate_id(time, part, cnt);
>                 *cb_data->count = cnt;
>                 cb_data->timespec->tv_sec = time;
>                 cb_data->timespec->tv_nsec = 0;
> @@ -79,7 +91,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
>                  * which doesn't support holding
>                  * multiple logs, remains.
>                  */
> -               *cb_data->id = part;
> +               *cb_data->id = efi_generate_id(time, part, 0);
>                 *cb_data->count = 0;
>                 cb_data->timespec->tv_sec = time;
>                 cb_data->timespec->tv_nsec = 0;
> @@ -125,9 +137,11 @@ static int efi_pstore_write(enum pstore_type_id type,
>         efi_char16_t efi_name[DUMP_NAME_LEN];
>         efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
>         int i, ret = 0;
> +       unsigned long timestamp;
>
> +       timestamp = get_seconds();
>         sprintf(name, "dump-type%u-%u-%d-%lu-%c", type, part, count,
> -               get_seconds(), compressed ? 'C' : 'D');
> +               timestamp, compressed ? 'C' : 'D');
>
>         for (i = 0; i < DUMP_NAME_LEN; i++)
>                 efi_name[i] = name[i];
> --
> 1.8.4.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
