From: Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH] correct call to free_pages to specify memory size in
 pages, not bytes.
Date: Fri, 26 Jul 2013 15:58:53 +0100
Message-ID: <51F28EAD.2080705@intel.com>
References: <1374713324-23670-1-git-send-email-roy.franz@linaro.org> <1374713324-23670-2-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1374713324-23670-2-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roy Franz <roy.franz@linaro.org>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 25/07/13 01:48, Roy Franz wrote:
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  arch/x86/boot/compressed/eboot.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index d606463..b7388a4 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -225,7 +225,7 @@ static void low_free(unsigned long size, unsigned long addr)
>  	unsigned long nr_pages;
>  
>  	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
> -	efi_call_phys2(sys_table->boottime->free_pages, addr, size);
> +	efi_call_phys2(sys_table->boottime->free_pages, addr, nr_pages);
>  }
>  
>  static void find_bits(unsigned long mask, u8 *pos, u8 *size)

Thanks Roy. I pulled this into my urgent queue, as it's obviously a bug
and I don't fancy our chances if we ask the firmware to free more memory
than it initially allocated.
