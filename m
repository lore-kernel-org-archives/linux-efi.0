From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] doc: efi-stub.txt: Fix arm64 paths
Date: Wed, 2 Dec 2015 09:24:30 +0000
Message-ID: <20151202092430.GA2551@codeblueprint.co.uk>
References: <20151130113237.GC2441@codeblueprint.co.uk>
 <1448894214-23616-1-git-send-email-alan@softiron.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1448894214-23616-1-git-send-email-alan-TH0P2DBAz1q9FHfhHBbuYA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Ott <alan-TH0P2DBAz1q9FHfhHBbuYA@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 30 Nov, at 09:36:54AM, Alan Ott wrote:
> Update documented paths for arm64 files to match current tree.
> 
> Signed-off-by: Alan Ott <alan-TH0P2DBAz1q9FHfhHBbuYA@public.gmane.org>
> ---
>  Documentation/efi-stub.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
> index 7747024..e157469 100644
> --- a/Documentation/efi-stub.txt
> +++ b/Documentation/efi-stub.txt
> @@ -10,12 +10,12 @@ arch/x86/boot/header.S and arch/x86/boot/compressed/eboot.c,
>  respectively. For ARM the EFI stub is implemented in
>  arch/arm/boot/compressed/efi-header.S and
>  arch/arm/boot/compressed/efi-stub.c. EFI stub code that is shared
> -between architectures is in drivers/firmware/efi/efi-stub-helper.c.
> +between architectures is in drivers/firmware/efi/libstub.
>  
>  For arm64, there is no compressed kernel support, so the Image itself
>  masquerades as a PE/COFF image and the EFI stub is linked into the
>  kernel. The arm64 EFI stub lives in arch/arm64/kernel/efi-entry.S
> -and arch/arm64/kernel/efi-stub.c.
> +and drivers/firmware/efi/libstub/arm64-stub.c.
>  
>  By using the EFI boot stub it's possible to boot a Linux kernel
>  without the use of a conventional EFI boot loader, such as grub or

Thanks, applied for v4.5.
