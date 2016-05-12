From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/2] Fix efi_call
Date: Thu, 12 May 2016 12:41:49 +0100
Message-ID: <20160512114149.GD2728@codeblueprint.co.uk>
References: <1462996545-98387-1-git-send-email-athorlton@sgi.com>
 <1462996545-98387-3-git-send-email-athorlton@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462996545-98387-3-git-send-email-athorlton-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 11 May, at 02:55:45PM, Alex Thorlton wrote:
> The efi_call assembly code has a slight error that prevents us from
> using arguments 7 and higher, which will be passed in on the stack.
> 
>         mov (%rsp), %rax
>         mov 8(%rax), %rax
> 	...
>         mov %rax, 40(%rsp)
> 
> This code goes and grabs the return address for the current stack frame,
> and puts it on the stack, next the 5th argument for the EFI runtime
> call.  Considering the fact that having the return address in that
> position on the stack makes no sense, I'm guessing that the intent of
> this code was actually to grab an argument off the stack frame for this
> call and place it into the frame for the next one.
> 
> The small change to that offset (i.e. 8(%rax) to 16(%rax)) ensures that
> we grab the 7th argument off the stack, and pass it as the 6th argument
> to the EFI runtime function that we're about to call.  This change gets
> our EFI runtime calls that need to pass more than 6 arguments working
> again.
> 
> Signed-off-by: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
> Cc: Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>
> Cc: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
> Cc: Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  arch/x86/platform/efi/efi_stub_64.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
> index 92723ae..62938ff 100644
> --- a/arch/x86/platform/efi/efi_stub_64.S
> +++ b/arch/x86/platform/efi/efi_stub_64.S
> @@ -43,7 +43,7 @@ ENTRY(efi_call)
>  	FRAME_BEGIN
>  	SAVE_XMM
>  	mov (%rsp), %rax
> -	mov 8(%rax), %rax
> +	mov 16(%rax), %rax
>  	subq $48, %rsp
>  	mov %r9, 32(%rsp)
>  	mov %rax, 40(%rsp)

Nice. Your fix looks good, so I've put it in the urgent queue and
tagged it for stable.
