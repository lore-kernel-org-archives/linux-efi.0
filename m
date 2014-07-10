From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: Include a .bss section within the PE/COFF
 headers
Date: Thu, 10 Jul 2014 15:48:32 +0100
Message-ID: <20140710144832.GH15932@console-pimps.org>
References: <1404991581-31210-1-git-send-email-mbrown@fensystems.co.uk>
 <1404991581-31210-2-git-send-email-mbrown@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1404991581-31210-2-git-send-email-mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Jul, at 12:26:20PM, Michael Brown wrote:
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
>  arch/x86/boot/tools/build.c | 38 ++++++++++++++++++++++++++++++--------
>  2 files changed, 52 insertions(+), 12 deletions(-)

Thanks Michael, applied.

-- 
Matt Fleming, Intel Open Source Technology Center
