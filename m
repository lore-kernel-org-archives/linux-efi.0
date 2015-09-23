From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: add support for UEFIv2.5 Properties table
Date: Wed, 23 Sep 2015 14:54:20 +0100
Message-ID: <20150923135420.GE2867@codeblueprint.co.uk>
References: <1441786096-8514-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1441786096-8514-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 09 Sep, at 10:08:15AM, Ard Biesheuvel wrote:
> Version 2.5 of the UEFI spec introduces a new configuration table
> called the 'EFI Properties table'. Currently, it is only used to
> convey whether the Memory Protection feature is enabled, which splits
> PE/COFF images into separate code and data memory regions.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c | 32 ++++++++++++++++++--------------
>  include/linux/efi.h        | 13 +++++++++++++
>  2 files changed, 31 insertions(+), 14 deletions(-)

Looks good to me. Thanks Ard, applied.

-- 
Matt Fleming, Intel Open Source Technology Center
