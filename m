From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v2 2/3] efi: Change abbreviation of EFI_MEMORY_RUNTIME
 from "RUN" to "RT"
Date: Wed, 9 Sep 2015 14:27:10 +0100
Message-ID: <20150909132710.GG4973@codeblueprint.co.uk>
References: <1440609031-14695-1-git-send-email-izumi.taku@jp.fujitsu.com>
 <1440609089-14787-1-git-send-email-izumi.taku@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1440609089-14787-1-git-send-email-izumi.taku@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
To: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org, matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, tony.luck@intel.com, qiuxishi@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, ard.biesheuvel@linaro.org, linux-mm@kvack.org, Peter Jones <pjones@redhat.com>, Laszlo Ersek <lersek@redhat.com>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

On Thu, 27 Aug, at 02:11:29AM, Taku Izumi wrote:
> Now efi_md_typeattr_format() outputs "RUN" if passed EFI memory
> descriptor has EFI_MEMORY_RUNTIME attribute. But "RT" is preferer
> because it is shorter and clearer.
> 
> This patch changes abbreviation of EFI_MEMORY_RUNTIME from "RUN"
> to "RT".
> 
> Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
> ---
>  drivers/firmware/efi/efi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 8124078..25b6477 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -594,8 +594,8 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
>  		snprintf(pos, size, "|attr=0x%016llx]",
>  			 (unsigned long long)attr);
>  	else
> -		snprintf(pos, size, "|%3s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
> -			 attr & EFI_MEMORY_RUNTIME ? "RUN" : "",
> +		snprintf(pos, size, "|%2s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
> +			 attr & EFI_MEMORY_RUNTIME ? "RT" : "",
>  			 attr & EFI_MEMORY_MORE_RELIABLE ? "MR" : "",
>  			 attr & EFI_MEMORY_XP      ? "XP"  : "",
>  			 attr & EFI_MEMORY_RP      ? "RP"  : "",

I know that Ard suggested this change but I don't think I should apply
this and the reason is that developers, particularly distro
developers, come to rely on the output we print for debugging
purposes.

They don't necessarily monitor all the patches getting merged upstream
closely enough to realise that it impacts their debugging strategy. So
when they notice that the output has gone from "RUN" to "RT" they're
naturally going to ask what the difference is... and the answer is "it
looks prettier". That's not a good enough reason.

Obviously if we're printing something that's completely incorrect, or
we can improve the message considerably, then yes, it makes sense to
change it - but that's not the case here.

Thanks for the patch, but sorry, I'm not going to apply this one.

-- 
Matt Fleming, Intel Open Source Technology Center

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
