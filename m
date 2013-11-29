From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH V5 1/6] efi-stub.txt updates for ARM
Date: Fri, 29 Nov 2013 10:36:49 +0000
Message-ID: <20131129103649.GA11775@console-pimps.org>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
 <1385595115-21488-2-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1385595115-21488-2-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dave.martin-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 27 Nov, at 03:31:50PM, Roy Franz wrote:
> Update efi-stub.txt documentation to be more general
> and not x86 specific.  Add ARM only "dtb=" command
> line option description.
> 
> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  Documentation/efi-stub.txt |   27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)
> 

[...]

> -respectively.
> +respectively.  For ARM the EFI stub is implemented in
> +arch/arm/boot/compressed/efi-header.S and
> +arch/arm/boot/compressed/efi-stub.c.  EFI stub code that is shared
> +between architectures is in drivers/firmware/efi/efi-stub-helper.c.
  
No double spaces between full-stop and the beginning of a sentence
please. That convention isn't used anywhere else in this file.

> +For the ARM architecture, we also need to be able to provide a device
> +tree to the kernel.  This is done with the "dtb=" command line option,
> +and is process in the same manner as the "initrd=" option that is described

         ^^ processed ?

-- 
Matt Fleming, Intel Open Source Technology Center
