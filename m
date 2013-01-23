From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 2/6] x86, efi: Fix 32-bit EFI handover protocol entry
 point
Date: Wed, 23 Jan 2013 16:26:35 +0000
Message-ID: <1358958395.2496.35.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1357841068-6582-1-git-send-email-dwmw2@infradead.org>
	 <1357841068-6582-2-git-send-email-dwmw2@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357841068-6582-2-git-send-email-dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-01-10 at 18:04 +0000, David Woodhouse wrote:
> From: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> If the bootloader calls the EFI handover entry point as a standard function
> call, then it'll have a return address on the stack. We need to pop that
> before calling efi_main(), or the arguments will all be out of position on
> the stack.
> 
> Signed-off-by: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/boot/compressed/head_32.S | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
> index aa4aaf1..ccb2f4a 100644
> --- a/arch/x86/boot/compressed/head_32.S
> +++ b/arch/x86/boot/compressed/head_32.S
> @@ -50,8 +50,10 @@ ENTRY(startup_32)
>  	pushl	%eax
>  	pushl	%esi
>  	pushl	%ecx
> +	sub	$0x4, %esp
>  
>  	.org 0x30,0x90
> +	add	$0x4, %esp
>  	call	efi_main
>  	cmpl	$0, %eax
>  	movl	%eax, %esi

It's worth pointing out that efilinux doesn't invoke the handover
protocol as a function, it pushes arguments onto the stack and jumps. So
this change will actually break that boot loader.

Is there a particular reason why you need to invoke it as a standard
function on 32-bits?

-- 
Matt Fleming, Intel Open Source Technology Center
