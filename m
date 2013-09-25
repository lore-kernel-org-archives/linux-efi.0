From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 09/18] Move unicode to ASCII conversion to shared
 function.
Date: Wed, 25 Sep 2013 13:01:29 +0100
Message-ID: <20130925120129.GG21381@console-pimps.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
 <1379889942-3135-10-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1379889942-3135-10-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sun, 22 Sep, at 03:45:33PM, Roy Franz wrote:
> Move the open-coded conversion to a shared function for
> use by all architectures.  Change the allocation to prefer
> a high address for ARM, as this is required to avoid conflicts
> with reserved regions in low memory.  We don't know the specifics
> of these regions until after we process the command line and
> device tree.
> 
> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c       |   43 ++++-------------------
>  drivers/firmware/efi/efi-stub-helper.c |   58 ++++++++++++++++++++++++++++++++
>  2 files changed, 64 insertions(+), 37 deletions(-)

[...]

> +/* Convert the unicode UEFI command line to ASCII to pass to kernel.
> + * Size of memory allocated return in *cmd_line_len.
> + * Returns NULL on error.
> + */

I futzed with the comments in this patch too.

-- 
Matt Fleming, Intel Open Source Technology Center
