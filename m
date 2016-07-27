From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi: initialize status to ensure garbage is not
 returned on small size
Date: Wed, 27 Jul 2016 15:38:13 +0100
Message-ID: <20160727143813.GG31759@codeblueprint.co.uk>
References: <1469009466-19980-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469009466-19980-1-git-send-email-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, 20 Jul, at 11:11:06AM, Colin Ian King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Although very unlikey, if size is too small or zero, then we end up with
> status not being set and returning garbage. Instead, initializing status to
> EFI_INVALID_PARAMETER to indicate that size is invalid in the calls to
> setup_uga32 and setup_uga64.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  arch/x86/boot/compressed/eboot.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index ff574da..ec6d2ef 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -578,7 +578,7 @@ setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
>  	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
>  	unsigned long nr_ugas;
>  	u32 *handles = (u32 *)uga_handle;;
> -	efi_status_t status;
> +	efi_status_t status = EFI_INVALID_PARAMETER;
>  	int i;
>  
>  	first_uga = NULL;
> @@ -623,7 +623,7 @@ setup_uga64(void **uga_handle, unsigned long size, u32 *width, u32 *height)
>  	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
>  	unsigned long nr_ugas;
>  	u64 *handles = (u64 *)uga_handle;;
> -	efi_status_t status;
> +	efi_status_t status = EFI_INVALID_PARAMETER;
>  	int i;
>  
>  	first_uga = NULL;

Can this ever happen in practice? This would imply that
locate_protocol() found EFI_UGA_PROTOCOL_GUID but that the size
returned is utterly bogus?

If so, I have no problem applying the patch but want to make sure
we're not tricking ourselves into thinking we're being protected from
something when we're not.
