From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: set PE/COFF file alignment to 512 bytes
Date: Tue, 21 Oct 2014 13:35:26 +0100
Message-ID: <20141021123526.GH12020@console-pimps.org>
References: <1412960335-22905-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1412960335-22905-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 10 Oct, at 06:58:55PM, Ard Biesheuvel wrote:
> Change our PE/COFF header to use the minimum file alignment of
> 512 bytes (0x200), as mandated by the PE/COFF spec v8.3
> 
> Also update the linker script so that the Image file itself is also a
> round multiple of FileAlignment.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> 
> Another one from the PE/COFF rabbit hole. I will follow up next week and repost
> as a coherent series, once I have collected all the feedback.

It appears a though next week never came.

Should I pick up this version and apply ACK tags from the mailing list?
Or are you planning on sending a larger series?

It sounds like this should be tagged for stable, and placed into the EFI
urgent queue?

-- 
Matt Fleming, Intel Open Source Technology Center
