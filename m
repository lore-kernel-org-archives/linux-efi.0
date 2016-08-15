From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi-bgrt: remove the check of the version field
Date: Mon, 15 Aug 2016 13:56:43 +0100
Message-ID: <20160815125643.GG30909@codeblueprint.co.uk>
References: <20160809052546.31462-1-icenowy@aosc.xyz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160809052546.31462-1-icenowy@aosc.xyz>
Sender: linux-kernel-owner@vger.kernel.org
To: Icenowy Zheng <icenowy@aosc.xyz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, Dave Young <dyoung@redhat.com>, Josh Boyer <jwboyer@redhat.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-efi@vger.kernel.org

On Tue, 09 Aug, at 01:25:46PM, Icenowy Zheng wrote:
> Some broken firmwares have a wrongly filled version field in BGRT table.
> (See http://wiki.osdev.org/Broken_UEFI_implementations )
> 
> As we know, these firmwares can also provide correct BGRT image, although
> the table is wrong.
> 
> After removing the check of the version field, the kernel can now extract
> the image correctly, and the information is also correct.
> 
> Tested on a Thinkpad E531 (68854UC).
> 
> Signed-off-by: Icenowy Zheng <icenowy@aosc.xyz>
> ---
>  arch/x86/platform/efi/efi-bgrt.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
> index 6a2f569..f492ea0 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -47,11 +47,6 @@ void __init efi_bgrt_init(void)
>  		       bgrt_tab->header.length, sizeof(*bgrt_tab));
>  		return;
>  	}
> -	if (bgrt_tab->version != 1) {
> -		pr_notice("Ignoring BGRT: invalid version %u (expected 1)\n",
> -		       bgrt_tab->version);
> -		return;
> -	}
>  	if (bgrt_tab->status & 0xfe) {
>  		pr_notice("Ignoring BGRT: reserved status bits are non-zero %u\n",
>  		       bgrt_tab->status);

This would be less scary if we checked for known broken and known good
version values instead of removing the check altogether, i.e. 0 and 1.

The whole point of the version field is that it tells us about the
layout of the BGRT table, so it's not exactly a useless check.
