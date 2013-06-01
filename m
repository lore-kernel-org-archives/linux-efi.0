From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] efi, pstore: Cocci spatch "memdup.spatch"
Date: Sat, 1 Jun 2013 10:11:31 -0700
Message-ID: <CAGXu5jK_mK_SCDQCQnG=y-yphy7kUT+on0pZbv4JpjS7jjpGwQ@mail.gmail.com>
References: <1370079602.29224.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370079602.29224.8.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
Cc: Anton Vorontsov <cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Jun 1, 2013 at 2:40 AM, Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org> wrote:
>
> Signed-off-by: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>

Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Thanks!

-Kees

> ---
>
> diff -u -p a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -79,10 +79,9 @@ static int efi_pstore_read_func(struct e
>                            &entry->var.DataSize, entry->var.Data);
>         size = entry->var.DataSize;
>
> -       *cb_data->buf = kmalloc(size, GFP_KERNEL);
> +       *cb_data->buf = kmemdup(entry->var.Data, size, GFP_KERNEL);
>         if (*cb_data->buf == NULL)
>                 return -ENOMEM;
> -       memcpy(*cb_data->buf, entry->var.Data, size);
>         return size;
>  }
>
>
>
>



--
Kees Cook
Chrome OS Security
