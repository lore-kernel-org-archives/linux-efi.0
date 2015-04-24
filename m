From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] x86/efi: fix potential NULL pointer dereference
Date: Fri, 24 Apr 2015 08:33:29 -0700
Message-ID: <1429889609.2182.25.camel@HansenPartnership.com>
References: <1429855639-14706-1-git-send-email-firogm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429855639-14706-1-git-send-email-firogm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Firo Yang <firogm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 2015-04-24 at 14:07 +0800, Firo Yang wrote:
> In this patch, I add error-handing code for kmalloc() in
> arch/x86/platform/efi/efi_64.c::efi_call_phys_prolog().
> 
> If kmalloc() failed to alloc memroy, save_pgd will be a NULL
> pointer dereferenced by subsequent codes.
> 
> Signed-off-by: Firo Yang <firogm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi_64.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index a0ac0f9..62326c4 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -90,6 +90,8 @@ pgd_t * __init efi_call_phys_prolog(void)
>  
>  	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
>  	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
> +	if (unlikely(!save_pgd))
> +		return NULL;
>  
>  	for (pgd = 0; pgd < n_pgds; pgd++) {
>  		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);

First explain what you're trying to achieve?  I'm asking because the
code you've introduced is actively harmful: the return from
efi_call_phys_prolog() isn't checked for errors, so the error you return
won't be handled and we'll likely trigger a much harder to detect error
if the allocation you're checking fails.  Effectively the prolog/epilog
do nothing and we never restore the pgds we hijacked, yet the system
continues on with the memory map in an unexpected state.

In my opinion the NULL deref we get further down in the prolog code is
actually a far better indicator of failure than what you're proposing.

James
