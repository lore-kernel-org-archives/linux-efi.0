From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: EFI_STUB fails to boot non-EFI on arm64
Date: Fri, 23 May 2014 14:47:20 +0100
Message-ID: <20140523134720.GA9256@arm.com>
References: <20140523094513.GC9252@arm.com>
 <20140523131656.GR4179@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140523131656.GR4179-t77nlHhSwNqAroYi2ySoxKxOck334EZe@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, May 23, 2014 at 02:16:56PM +0100, Leif Lindholm wrote:
> Subject: [PATCH] arm64: efi: only attempt efi map setup if booting via EFI
> 
> Booting a kernel with CONFIG_EFI enabled on a non-EFI system caused
> an oops with the current UEFI support code.
> Add the required test to prevent this.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/kernel/efi.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 7bfd650..14db1f6 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -333,6 +333,9 @@ void __init efi_init(void)
>  
>  void __init efi_idmap_init(void)
>  {
> +	if (!efi_enabled(EFI_BOOT))
> +		return;
> +

That's a first (possibly temporary) step and I think it's fine:

Acked-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>

But we need some further tweaking to the way we call efi_init().
Currently it doesn't matter whether Linux booted as an EFI application
or not and efi_init() is always called, causing some pr_err() in
fdt_find_uefi_params(). It's not really an error as we support the same
image booting non-EFI as well.

Can we add another of detecting whether it's an EFI application and
avoid calling efi_init()? I can see x86 sets some efi_loader_signature
string in exit_boot() and checks against it later when calling
efi_init().

-- 
Catalin
