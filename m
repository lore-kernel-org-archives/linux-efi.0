From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [PATCH 13/14] efi: Add Persistent Memory type name
Date: Tue, 2 Feb 2016 09:56:52 +0100
Message-ID: <56B06F54.8020901@redhat.com>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
 <1454364428-494-14-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454364428-494-14-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ingo Molnar <mingo@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Robert Elliott <elliott@hpe.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>
List-Id: linux-efi@vger.kernel.org

On 02/01/16 23:07, Matt Fleming wrote:
> From: Robert Elliott <elliott@hpe.com>
> 
> Add the "Persistent Memory" string for type 14 introduced in
> UEFI 2.5.  This is used when printing the UEFI memory map.
> 
> old:
> efi: mem61: [type=14            |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)
> 
> new:
> efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)
> 
> Signed-off-by: Robert Elliott <elliott@hpe.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
> Cc: Laszlo Ersek <lersek@redhat.com>
> Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
> ---
>  drivers/firmware/efi/efi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 9c8c0747c8cd..05a3d69250d4 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -553,7 +553,8 @@ static __initdata char memory_type_name[][20] = {
>  	"ACPI Memory NVS",
>  	"Memory Mapped I/O",
>  	"MMIO Port Space",
> -	"PAL Code"
> +	"PAL Code",
> +	"Persistent Memory"
>  };
>  
>  char * __init efi_md_typeattr_format(char *buf, size_t size,
> 

To minimize future churn, I suggest to add a trailing comma character:

	"Persistent Memory",

With or without that changed:

Reviewed-by: Laszlo Ersek <lersek@redhat.com>
