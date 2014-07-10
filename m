From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi: Include a .bss section within the PE/COFF headers
Date: Thu, 10 Jul 2014 11:34:31 +0100
Message-ID: <20140710103431.GE15932@console-pimps.org>
References: <1404942094-29447-1-git-send-email-mbrown@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1404942094-29447-1-git-send-email-mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas =?iso-8859-1?Q?B=E4chler?= <thomas-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 09 Jul, at 10:41:34PM, Michael Brown wrote:
> The PE/COFF headers currently describe only the initialised-data
> portions of the image, and result in no space being allocated for the
> uninitialised-data portions.  Consequently, the EFI boot stub will end
> up overwriting unexpected areas of memory, with unpredictable results.
> 
> Fix by including a .bss section in the PE/COFF headers (functionally
> equivalent to the init_size field in the bzImage header).
> 
> Signed-off-by: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
> ---
>  arch/x86/boot/header.S      | 26 ++++++++++++++++++++++----
>  arch/x86/boot/tools/build.c | 37 +++++++++++++++++++++++++++++--------
>  2 files changed, 51 insertions(+), 12 deletions(-)

Yeah ouch, that's a particularly bad bug. Thanks Michael, this fix looks
great.

I've placed this in the urgent EFI queue and tagged it for stable.

Thomas, the patch in question is here this one,

  http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=urgent&id=db0f1ff0ee1750cc52ead0ba1ddf95c47b3bd133

it would be good if you could carry it in archlinux for some additional
testing. I suspect this fix may solve some of the problems people have
reported in,

  https://bugzilla.kernel.org/show_bug.cgi?id=68761

Let me know if you'd like a backported version.

-- 
Matt Fleming, Intel Open Source Technology Center
