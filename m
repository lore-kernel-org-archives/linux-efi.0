From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 3.10 ~ 3.14] efi: fix the efi 32bit boot failed problem
Date: Thu, 30 Jul 2015 16:04:28 +0100
Message-ID: <20150730150428.GJ2725@codeblueprint.co.uk>
References: <1438078879-24705-1-git-send-email-fupan.li@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438078879-24705-1-git-send-email-fupan.li@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
To: fupan.li@windriver.com
Cc: linux-kernel@vger.kernel.org, fupanli@gmail.com, linux-efi@vger.kernel.org, Luis Henriques <luis.henriques@canonical.com>, Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

(Add linux-efi, Luis and Greg)

On Tue, 28 Jul, at 06:21:19PM, fupan.li@windriver.com wrote:
> From: fli <fupan.li@windriver.com>
> 
> The commit 35d5134b7d5a55e269c953096224248b9f6f72c2
> Author: Matt Fleming <matt@console-pimps.org>
> Date:   Tue Apr 8 13:14:00 2014 +0100
> 
>     x86/efi: Correct EFI boot stub use of code32_start
> 
> imported a bug, which should use the label's address instead
> of the value stored in the label's address to caculate the
> code32_start address.
> 
> Signed-off-by: fli <fupan.li@windriver.com>
> ---
>  arch/x86/boot/compressed/head_32.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
> index abb988a..3b28eff 100644
> --- a/arch/x86/boot/compressed/head_32.S
> +++ b/arch/x86/boot/compressed/head_32.S
> @@ -54,7 +54,7 @@ ENTRY(efi_pe_entry)
>  	call	reloc
>  reloc:
>  	popl	%ecx
> -	subl	reloc, %ecx
> +	subl	$reloc, %ecx
>  	movl	%ecx, BP_code32_start(%eax)
>  
>  	sub	$0x4, %esp

Woa, nice catch!

The commit message could do with a little work however. In particular
the usual way to refer to a commit is like this: commit 35d5134b7d5a
("x86/efi: Correct EFI boot stub use of code32_start"). And the
Signed-off-by line should contain your full name.

Luis, Greg, what is the procedure for submitting a patch that is only
required for stable?

-- 
Matt Fleming, Intel Open Source Technology Center
