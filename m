From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 3/7] Change EFI helper APIs to be more flexible
Date: Tue, 6 Aug 2013 14:53:14 +0100
Message-ID: <20130806135314.GX2515@console-pimps.org>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
 <1375478948-22562-4-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1375478948-22562-4-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 02 Aug, at 02:29:04PM, Roy Franz wrote:
> * Change the EFI helper functions to be more flexible to allow their use
> by other architectures.
> * Pass system table pointer as argument to all functions that use it,
> rather than use a global variable.
> * Change name of __get_map to efi_get_memory_map, and add key pointer argument
> so it can be used to get final memory map before the EFI exitBootServices()
> function is called.
> * Change the handle_ramdisks() to handle_cmdline_files(), and make it more
> generic by taking string to match rather than hardcoding 'initrd='
> so it can be used to load device tree files as well.
> * Add 'min' address parameter to limit low_alloc() alloctions
> * Fix type of chunksize to match EFI function (not checked in x86 code
> as wrappers break type checking.)
> * rename alloc/free functions - low_free() is usable by both low_alloc()
> and high_alloc(), so rename them to be more consistent - efi_low_alloc()
> efi_high_alloc(), and efi_free()
> * Enforce minimum pagesize alignment as expected by EFI allocate_pages().
> * check for 0 size in efi_free.
 
This is way too many changes to include in a single patch, and makes
review fairly difficult. Please split this large patch into smaller
patches.

Not only are smaller patches easier to review, they make it much easier
for you to incorporate any feedback.

-- 
Matt Fleming, Intel Open Source Technology Center
