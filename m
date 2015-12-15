From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/4] doc: efi-stub.txt: Fix arm64 paths
Date: Tue, 15 Dec 2015 08:32:30 +0100
Message-ID: <CAKv+Gu8UYrpUJ7wiRq8+R_BQ3ZpTXpSpFJ37emG7OcseWKVrEQ@mail.gmail.com>
References: <1450117613-15438-1-git-send-email-matt@codeblueprint.co.uk>
	<1450117613-15438-3-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450117613-15438-3-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alan Ott <alan-TH0P2DBAz1q9FHfhHBbuYA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 14 December 2015 at 19:26, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> From: Alan Ott <alan-TH0P2DBAz1q9FHfhHBbuYA@public.gmane.org>
>
> Update documented paths for arm64 files to match current tree.
>
> Signed-off-by: Alan Ott <alan-TH0P2DBAz1q9FHfhHBbuYA@public.gmane.org>
> Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>

Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>


> ---
>  Documentation/efi-stub.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
> index 7747024d3bb7..e15746988261 100644
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
> --
> 2.6.2
>
