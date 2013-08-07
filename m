From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH 04/17] Rename memory allocation/free functions
Date: Wed, 7 Aug 2013 14:09:06 +0100
Message-ID: <20130807130906.GD2515@console-pimps.org>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
 <1375847113-24884-5-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1375847113-24884-5-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com, linux@arm.linux.org.uk, leif.lindholm@linaro.org, dave.martin@arm.com
List-Id: linux-efi@vger.kernel.org

On Tue, 06 Aug, at 08:45:00PM, Roy Franz wrote:
> Rename them to be more similar, as low_free() could be used to free
> memory allocated by both high_alloc() and low_alloc().
> high_alloc() -> efi_high_alloc()
> low_alloc()  -> efi_low_alloc()
> low_free()   -> efi_free()
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  arch/x86/boot/compressed/eboot.c       |   19 ++++++++++---------
>  drivers/firmware/efi/efi-stub-helper.c |   16 ++++++++--------
>  2 files changed, 18 insertions(+), 17 deletions(-)

[...]

> @@ -163,10 +163,10 @@ fail:
>  }
>  
>  /*
> - * Allocate at the lowest possible address.
> + * Allocate at the lowest possible address, that is not below 'min'
>   */
> -static efi_status_t low_alloc(efi_system_table_t *sys_table_arg,
> -		unsigned long size, unsigned long align,
> +static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
> +			      unsigned long size, unsigned long align,
>  			      unsigned long *addr)
>  {
>  	unsigned long map_size, desc_size;

Whoops, did this change to the comment slip in from some other patch?

-- 
Matt Fleming, Intel Open Source Technology Center
