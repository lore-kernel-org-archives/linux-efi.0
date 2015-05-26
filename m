From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 4/8] efi: move FDT handling to separate object file
Date: Tue, 26 May 2015 19:15:58 +0100
Message-ID: <20150526181558.GB3030@codeblueprint.co.uk>
References: <1431326520-17331-1-git-send-email-ard.biesheuvel@linaro.org>
 <1431326520-17331-5-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431326520-17331-5-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ganapatrao.Kulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 11 May, at 08:41:56AM, Ard Biesheuvel wrote:
> The EFI specific FDT handling is compiled conditionally, and is
> logically independent of the rest of efi.o. So move it to a separate
> file before making changes to it in subsequent patches.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/Makefile  |  1 +
>  drivers/firmware/efi/efi-fdt.c | 93 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/efi.c     | 86 --------------------------------------
>  3 files changed, 94 insertions(+), 86 deletions(-)
>  create mode 100644 drivers/firmware/efi/efi-fdt.c

Sorry for the delay,

Acked-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

-- 
Matt Fleming, Intel Open Source Technology Center
