From: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Subject: Re: [PATCH] x86, efi: add no_bricked_efi whitelist
Date: Wed, 20 Nov 2013 09:54:03 +0100
Message-ID: <2242165.pl7XBGF5ii@sandpuppy>
References: <528C740A.6010407@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <528C740A.6010407-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org, cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Am Mittwoch, 20. November 2013, 17:34:18 schrieb Yasuaki Ishimatsu:
> By following works, my system very often fails set_variable() to set new
> variable to efi variable storage and shows "efivars: set_variable() failed:
> status=-28" message.
> 
> - commit 68d929862e29a8b52a7f2f2f86a0600423b093cd
>     efi: be more paranoid about available space when creating variables
> - commit 31ff2f20d9003e74991d135f56e503fe776c127c
>     efi: Distinguish between "remaining space" and actually used space
> - commit 8c58bf3eec3b8fc8162fe557e9361891c20758f2
>     x86,efi: Implement efi_no_storage_paranoia parameter
> - commit f8b8404337de4e2466e2e1139ea68b1f8295974f
>     Modify UEFI anti-bricking code
> 
> When booting my system, remaining space of efi variable storage is about
> 5KB. So there is no room that sets a new variable to the storage. On my
> system, trigger of gc is when EFI_OUT_OF_RESOURCES occurs on pre OS
> environment with UEFI. So if EFI_OUT_OF_RESOURCES occurs by the 5Kbyte
> threshold, nvram storage cannot be used until EFI_OUT_OF_RESOURCES occurs
> on pre OS environment with UEFI.
> 
> This patch adds whitelist. If a server is in the whitelist,
> efi_no_storage_paranoia is set to true. And the system can use all efi
> variable storage.
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> CC: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
> CC: Lee, Chun-Y <jlee-IBi9RG/b67k@public.gmane.org>
> CC: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index c7e22ab..9fadf5d 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -116,6 +116,15 @@ static int __init setup_storage_paranoia(char *arg)
>  }
>  early_param("efi_no_storage_paranoia", setup_storage_paranoia);
> 
> +struct no_bricked_efi {
> +	char vendor[100];
> +	u32 revision;
> +};
> +
> +static struct no_bricked_efi efi_whitelist[] __initdata = {
> +	{"FUJITSU LIMITED", 0},

So, no UEFI from Fujitsu on planet earth suffers from such issues?
How can you guarantee that?

Thanks,
//richard
