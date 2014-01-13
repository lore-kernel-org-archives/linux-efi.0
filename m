From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/6] efi: create memory map iteration helper
Date: Mon, 13 Jan 2014 15:17:59 +0000
Message-ID: <20140113151759.GG3256@console-pimps.org>
References: <1389392950-22457-1-git-send-email-msalter@redhat.com>
 <1389392950-22457-2-git-send-email-msalter@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1389392950-22457-2-git-send-email-msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 10 Jan, at 05:29:05PM, Mark Salter wrote:
> There are a lot of places in the kernel which iterate through an
> EFI memory map. Most of these places use essentially the same
> for-loop code. This patch adds a for_each_efi_memory_desc()
> helper to clean up all of the existing duplicate code and avoid
> more in the future.
> 
> Signed-off-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/efi.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 11ce678..9dc5b05 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -618,6 +618,12 @@ extern int efi_set_rtc_mmss(const struct timespec *now);
>  extern void efi_reserve_boot_services(void);
>  extern struct efi_memory_map memmap;
>  
> +/* Iterate through an efi_memory_map */
> +#define for_each_efi_memory_desc(m, md)					   \
> +	for ((md) = (m)->map;						   \
> +	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
> +	     (md) = (void *)(md) + (m)->desc_size)
> +

Err, what? I just picked up your previous patch ("x86/efi: Create memory
map iteration helper") which adds this chunk, and I didn't see a follow
up email telling me not to pick it up.

What's the plan?

-- 
Matt Fleming, Intel Open Source Technology Center
