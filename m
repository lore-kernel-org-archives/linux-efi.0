From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Specify ELF ABI for EFI handover protocol
Date: Mon, 07 Jan 2013 18:58:20 +0000
Message-ID: <1357585100.8203.84.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1357431222.9270.73.camel@shinybook.infradead.org>
	 <1357524456.9270.90.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357524456.9270.90.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-01-07 at 02:07 +0000, David Woodhouse wrote:
> This would have saved me some time...
> 
> Signed-off-by: David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> Also, are interrupts supposed to be disabled? The efi_main() function
> will disable them, but only *after* lidt/lgdt. Shouldn't it happen
> sooner?

I was under the impression that, yes, interrupts should be disabled when
we jump to the kernel entry points. Certainly for the 32-bit boot
protocol detailed in Documentation/x86/boot.txt, interrupts must be
disabled. The 'cli' in efi_main() is likely superfluous. I can't think
of any reason you'd want to leave interrupts enabled when you enter
efi_main().

> diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
> index 9efceff..c00aa8a 100644
> --- a/Documentation/x86/boot.txt
> +++ b/Documentation/x86/boot.txt
> @@ -1054,3 +1054,7 @@ The boot loader *must* fill out the following fields in bp,
>      o hdr.ramdisk_size  (if applicable)
>  
>  All other fields should be zero.
> +
> +Note that the efi_main entry point uses Linux/ELF calling conventions, not
> +EFI calling conventions. So 'handle' is in %rdi, 'table' in %rsi and 'bp'
> +in %rdx.

Unless you're booting under 32-bit, in which case they're on the stack.
I'll take this patch and munge it a little to mention 32-bit, thanks.
