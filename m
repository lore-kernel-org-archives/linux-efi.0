From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86, efi: initial the local variable of DataSize to zero
Date: Mon, 29 Apr 2013 10:55:58 +0100
Message-ID: <517E43AE.6050203@console-pimps.org>
References: <1366996767-8234-1-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366996767-8234-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26/04/13 18:19, Lee, Chun-Yi wrote:
> That will be better initial the value of DataSize to zero for the input of
> GetVariable(), otherwise we will feed a random value. The debug log of input
> DataSize like this:
> 
> ...
> [  195.915612] EFI Variables Facility v0.08 2004-May-17
> [  195.915819] efi: size: 18446744071581821342
> [  195.915969] efi:  size': 18446744071581821342
> [  195.916324] efi: size: 18446612150714306560
> [  195.916632] efi:  size': 18446612150714306560
> [  195.917159] efi: size: 18446612150714306560
> [  195.917453] efi:  size': 18446612150714306560
> ...
> 
> Found on Acer Aspire V3 BIOS, it will not return the size of data if we input a
> non-zero DataSize.
> 
> Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index e4a86a6..cb59732 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -204,7 +204,7 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
>  	}
>  
>  	if (boot_used_size && !finished) {
> -		unsigned long size;
> +		unsigned long size = 0;
>  		u32 attr;
>  		efi_status_t s;
>  		void *tmp;
> 

Looks good to me. Matthew?

-- 
Matt Fleming, Intel Open Source Technology Center
