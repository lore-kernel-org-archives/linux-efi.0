From: Linn Crosetto <linn@hpe.com>
Subject: Re: [PATCH] EFI loader: remove dead code
Date: Tue, 1 Nov 2016 16:09:50 -0700
Message-ID: <20161101230950.GD3567@oranje.usa.hp.com>
References: <20161101173808.GA2682@vnote>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161101173808.GA2682@vnote>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Korenevsky <ekorenevsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 01, 2016 at 08:38:08PM +0300, Eugene Korenevsky wrote:
> *e820ext is always NULL in 'alloc_e820ext()' (see the code of 'exit_boot()').
> Therefore the 'if' condition is always false and the entire 'if' statement is
> pointless. Remove it.
> 
> ---
>  arch/x86/boot/compressed/eboot.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index cc69e37..edfd4d6 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -956,12 +956,6 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
>  	size = sizeof(struct setup_data) +
>  		sizeof(struct e820entry) * nr_desc;
>  
> -	if (*e820ext) {
> -		efi_call_early(free_pool, *e820ext);
> -		*e820ext = NULL;
> -		*e820ext_size = 0;
> -	}
> -

I agree with your reading of the code. On the other hand, alloc_e820ext()
has no knowledge of the 'first' flag used in exit_boot_func() so the call to
free provides some assurance that memory isn't leaked if the calling code is
changed.

If the caller is responsible for freeing the memory in such a case, then
alloc_e820ext() should at least return an error.

--
Linn
