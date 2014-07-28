From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efi: Include a .bss section within the PE/COFF headers
Date: Mon, 28 Jul 2014 15:54:36 -0700
Message-ID: <53D6D4AC.9010704@zytor.com>
References: <1406553713-7479-1-git-send-email-mbrown@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406553713-7479-1-git-send-email-mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 07/28/2014 06:21 AM, Michael Brown wrote:
> commit c7fb93ec51d462ec3540a729ba446663c26a0505 upstream
> 
> The PE/COFF headers currently describe only the initialised-data
> portions of the image, and result in no space being allocated for the
> uninitialised-data portions.  Consequently, the EFI boot stub will end
> up overwriting unexpected areas of memory, with unpredictable results.
> 
> Fix by including a .bss section in the PE/COFF headers (functionally
> equivalent to the init_size field in the bzImage header).
> 
> Signed-off-by: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Just FYI: please enclose the email addresses in angle brackets even if
there is no plain name.  Otherwise you have a tendency to break various
people's scripts in unpredictable ways.

	-hpa
