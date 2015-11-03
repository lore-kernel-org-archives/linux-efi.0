From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 1/2] efi-pstore: fix kernel-doc argument name
Date: Tue, 3 Nov 2015 12:05:16 -0800
Message-ID: <CAGXu5jJG_qF=z6Q7v2nfdhxizOE5UciO=S9qcXDO3MowTuxMHw@mail.gmail.com>
References: <f5d7694a7f25e936f97ef9d4870fbec5d89ab87d.1446304741.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f5d7694a7f25e936f97ef9d4870fbec5d89ab87d.1446304741.git.geliangtang-9Onoh4P/yGk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
Cc: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Oct 31, 2015 at 8:23 AM, Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org> wrote:
> The first argument name in the kernel-doc argument list for
> efi_pstore_scan_sysfs_enter() was slightly off. Fix it for the
> kernel doc.
>
> Signed-off-by: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>

Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Thanks!

-Kees

> ---
>  drivers/firmware/efi/efi-pstore.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
> index c8d794c..eac76a7 100644
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -103,7 +103,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
>
>  /**
>   * efi_pstore_scan_sysfs_enter
> - * @entry: scanning entry
> + * @pos: scanning entry
>   * @next: next entry
>   * @head: list head
>   */
> --
> 2.4.3
>
>



-- 
Kees Cook
Chrome OS Security
