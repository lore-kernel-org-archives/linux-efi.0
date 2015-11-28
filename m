From: Alan Ott <alan@softiron.co.uk>
Subject: Re: [PATCH] doc: efi-stub.txt: Fix arm64 paths
Date: Sat, 28 Nov 2015 11:12:00 -0500
Message-ID: <5659D250.3000609@softiron.co.uk>
References: <1448726603-17600-1-git-send-email-alan@softiron.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448726603-17600-1-git-send-email-alan@softiron.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Jonathan Corbet <corbet@lwn.net>
Cc: Roy Franz <roy.franz@linaro.org>, linux-efi@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 11/28/2015 11:03 AM, Alan Ott wrote:
> Update documented paths for arm64 files to match current tree.
> ---
>   Documentation/efi-stub.txt | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
> index 7747024..e157469 100644
> --- a/Documentation/efi-stub.txt
> +++ b/Documentation/efi-stub.txt
> @@ -10,12 +10,12 @@ arch/x86/boot/header.S and arch/x86/boot/compressed/eboot.c,
>   respectively. For ARM the EFI stub is implemented in
>   arch/arm/boot/compressed/efi-header.S and
>   arch/arm/boot/compressed/efi-stub.c. EFI stub code that is shared
> -between architectures is in drivers/firmware/efi/efi-stub-helper.c.
> +between architectures is in drivers/firmware/efi/libstub.
>   
>   For arm64, there is no compressed kernel support, so the Image itself
>   masquerades as a PE/COFF image and the EFI stub is linked into the
>   kernel. The arm64 EFI stub lives in arch/arm64/kernel/efi-entry.S
> -and arch/arm64/kernel/efi-stub.c.
> +and drivers/firmware/efi/libstub/arm64-stub.c.
>   
>   By using the EFI boot stub it's possible to boot a Linux kernel
>   without the use of a conventional EFI boot loader, such as grub or

To follow up on this one, it additionally appears that commit 
719e284369d23c3feb02d02ad58b3a516df47806 [1] was premature, as ARM 
support for EFI never fully made it into mainline, and the files 
referenced[2] do not exist anywhere in the history.

Alan.

[1] https://lkml.org/lkml/2014/4/4/401
[2] arch/arm/boot/compressed/efi-header.S, and 
arch/arm/boot/compressed/efi-stub.c
