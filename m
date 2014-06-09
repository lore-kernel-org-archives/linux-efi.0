From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] pstore: Fix an overflow on 32-bit builds.
Date: Mon, 9 Jun 2014 13:24:43 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1406091322050.30620@chino.kir.corp.google.com>
References: <1402325440-26335-1-git-send-email-andrew.zaborowski@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402325440-26335-1-git-send-email-andrew.zaborowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrzej Zaborowski <andrew.zaborowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 9 Jun 2014, Andrzej Zaborowski wrote:

> [resend]
> In generic_id the long int timestamp is multiplied by 100000 and needs
> an explicit cast to u64.
> 
> Without that the id in the resulting pstore filename is wrong and
> userspace may have problems parsing it, but more importantly files in
> pstore can never be deleted and may fill the EFI flash (brick device?).
> This happens because when generic pstore code wants to delete a file,
> it passes the id to the EFI backend which reinterpretes it and a wrong
> variable name is attempted to be deleted.  There's no error message but
> after remounting pstore, deleted files would reappear.
> 
> Signed-off-by: Andrew Zaborowski <andrew.zaborowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
>  drivers/firmware/efi/efi-pstore.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
> index 4b9dc83..e992abc 100644
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -40,7 +40,7 @@ struct pstore_read_data {
>  static inline u64 generic_id(unsigned long timestamp,
>  			     unsigned int part, int count)
>  {
> -	return (timestamp * 100 + part) * 1000 + count;
> +	return ((u64) timestamp * 100 + part) * 1000 + count;
>  }
>  
>  static int efi_pstore_read_func(struct efivar_entry *entry, void *data)

This fixes commit fdeadb43fdf1 ("efi-pstore: Make efi-pstore return a 
unique id") that went into stable, so I'm not sure if this should go into 
stable as well.

You probably had to resend this because you didn't email any of the 
maintainers (fixed).  Use scripts/get_maintainer.pl to figure out who to 
email about a patch.
