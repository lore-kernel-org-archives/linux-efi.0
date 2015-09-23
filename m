From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 2/2] efi: introduce EFI_NX_PE_DATA bit and set it from
 properties table
Date: Wed, 23 Sep 2015 17:55:23 +0100
Message-ID: <20150923165523.GG2867@codeblueprint.co.uk>
References: <20150923141817.GF2867@codeblueprint.co.uk>
 <1443018574-21702-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443018574-21702-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 23 Sep, at 07:29:34AM, Ard Biesheuvel wrote:
> UEFI v2.5 introduces a runtime memory protection feature that splits
> PE/COFF runtime images into separate code and data regions. Since this
> may require special handling by the OS, allocate a EFI_xxx bit to
> keep track of whether this feature is currently active or not.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> 
> @Matt:
> here's v2 of 2/2 only, with your comments addressed.
> 
> Thanks,
> Ard.
> 
> 
>  drivers/firmware/efi/efi.c | 18 ++++++++++++++++++
>  include/linux/efi.h        |  1 +
>  2 files changed, 19 insertions(+)

Thanks Ard, applied!

-- 
Matt Fleming, Intel Open Source Technology Center
