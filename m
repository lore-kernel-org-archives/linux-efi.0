From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 00/10] arm64 EFI patches for 3.19
Date: Mon, 27 Oct 2014 11:50:55 +0000
Message-ID: <20141027115055.GM8768@arm.com>
References: <1413987713-30528-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1413987713-30528-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On Wed, Oct 22, 2014 at 03:21:43PM +0100, Ard Biesheuvel wrote:
> This is a bit of a mixed bag of patches that we would like to see merged for
> 3.19. Most of them have been posted and discussed on linux-efi and/or LAKML
> before, and one of them has even been merged and reverted twice.
> 
> Patches #1 - #4 are fixes for compliance with the UEFI and PE/COFF specs.
> No issues are known that require these patches, so there is no reason to
> pull them into a stable release.
> 
> Patches #5 and #6 address minor issues in the arm64 EFI init code.
> 
> Patches #7 - #10 implement DMI/SMBIOS for arm64, both the existing 32-bit
> version and the upcoming 3.0 version that allows the SMBIOS structure table
> to reside at a physical offset that cannot be encoded in 32-bits. It also
> install a 'Hardware: xxx' string that is printed along with oopses and
> kernel call stack dumps on systems that implement DMI/SMBIOS.
> 
> Please refer to the patches themselves for version history. Acks and/or
> comments appreciated.

It would be helpful for me if you could split this into two series -- one
for the arm64 tree and the other for the efi tree. That would also make the
dependencies clearer, so I know whether any of the arch bits need to go via
Matt.

Cheers,

Will
