From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 1/2] efi: export efi_capsule_supported() function
 symbol
Date: Mon, 5 Oct 2015 15:13:50 +0200
Message-ID: <20151005131350.GA26329@nazgul.tnic>
References: <1444076155-19295-1-git-send-email-hock.leong.kweh@intel.com>
 <1444076155-19295-2-git-send-email-hock.leong.kweh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444076155-19295-2-git-send-email-hock.leong.kweh@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Fleming Matt <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Oct 06, 2015 at 04:15:54AM +0800, Kweh, Hock Leong wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> 
> This patch export efi_capsule_supported() function symbol for capsule
> kernel module to use.
> 
> Cc: Matt Fleming <matt.fleming@intel.com>
> Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
> ---
>  drivers/firmware/efi/capsule.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
> index d8cd75c0..738d437 100644
> --- a/drivers/firmware/efi/capsule.c
> +++ b/drivers/firmware/efi/capsule.c
> @@ -101,6 +101,7 @@ out:
>  	kfree(capsule);
>  	return rv;
>  }
> +EXPORT_SYMBOL_GPL(efi_capsule_supported);

So this one is still a separate patch.

If you're going to ignore review comments, maybe I should stop wasting
my time reviewing your stuff...

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
