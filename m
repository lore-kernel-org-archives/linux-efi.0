From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 1/2] x86/efi: Correct a tiny mistake in code comment
Date: Wed, 8 Mar 2017 16:18:12 +0800
Message-ID: <20170308081812.GA12600@dhcp-128-65.nay.redhat.com>
References: <1488959258-4731-1-git-send-email-bhe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1488959258-4731-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, thgarnie@google.com, keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, akpm@linux-foundation.org
List-Id: linux-efi@vger.kernel.org

On 03/08/17 at 03:47pm, Baoquan He wrote:
> EFI allocate runtime services regions down from EFI_VA_START, -4G.
> It should be top-down handling.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  arch/x86/platform/efi/efi_64.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index a4695da..6cbf9e0 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -47,7 +47,7 @@
>  #include <asm/pgalloc.h>
>  
>  /*
> - * We allocate runtime services regions bottom-up, starting from -4G, i.e.
> + * We allocate runtime services regions top-down, starting from -4G, i.e.

Baoquan, I think original bottom-up is right, it is just considering
-68G as up, see the x86_64 mm.txt. We regard vmalloc as higher address
although from mathematics view it is lower then positive addresses.

>   * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
>   */
>  static u64 efi_va = EFI_VA_START;
> -- 
> 2.5.5
> 

Thanks
Dave
