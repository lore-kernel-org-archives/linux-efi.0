From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2] efi, x86: Add a "debug" option to the efi= cmdline
Date: Thu, 5 Feb 2015 15:28:58 +0100
Message-ID: <20150205142858.GH23980@pd.tnic>
References: <54AAA723.1070605@redhat.com>
 <54BF3DCA.4070708@jonmasters.org>
 <20150121100633.GC12173@pd.tnic>
 <20150126104936.GB3320@codeblueprint.co.uk>
 <20150130164309.GG1451@pd.tnic>
 <20150205031846.GA1903@darkstar.redhat.com>
 <20150205081143.GA23980@pd.tnic>
 <20150205084139.GA23146@dhcp-16-198.nay.redhat.com>
 <20150205104441.GC23980@pd.tnic>
 <20150205124507.GB20082@linuxteamdev.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150205124507.GB20082@linuxteamdev.amer.dell.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parmeshwr Prasad <parmeshwr_prasad@dell.com>
Cc: Matt Fleming <matt@console-pimps.org>, Dave Young <dyoung@redhat.com>, Jon Masters <jonathan@jonmasters.org>, Laszlo Ersek <lersek@redhat.com>, linux-efi <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt.fleming@intel.com>, Ricardo Neri <ricardo.neri-calderon@linux.intel.com>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 05, 2015 at 07:45:10AM -0500, Parmeshwr Prasad wrote:
> It is better if we add some printk from efifb messages.
> Please review the below patch.

First of all, we saw you patch.

Then,

> From 7fbac896ab87f1b37646ac2f49bb8216ec330642 Mon Sep 17 00:00:00 2001
> From: Parmeshwr Prasad <parmeshwr_prasad@dell.com>
> Date: Wed, 4 Feb 2015 06:50:32 -0500
> Subject: [PATCH] efi, x86: Add a debug option to the efi= cmdline

yours has the same Subject as mine. This is not how we do patches.
Consult Documentation/SubmittingPatches about how to do them properly.

What is more, your patch doesn't have a commit message. But it needs one.

Fix all that, send it as a *separate* patch after mine has been applied
and people will take a look then.

> 
> Signed-off-by: Parmeshwr Prasad <parmeshwr_prasad@dell.com>
> ---
>  drivers/video/fbdev/efifb.c | 49 +++++++++++++++++++++++++--------------------
>  1 file changed, 27 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index 4bfff34..505bc56 100644
> --- a/drivers/video/fbdev/efifb.c
> +++ b/drivers/video/fbdev/efifb.c
> @@ -145,7 +145,8 @@ static int efifb_probe(struct platform_device *dev)
>                 printk(KERN_DEBUG "efifb: invalid framebuffer address\n");
>                 return -ENODEV;
>         }
> -       printk(KERN_INFO "efifb: probing for efifb\n");
> +       if (efi_enabled(EFI_DBG))
> +               printk(KERN_INFO "efifb: probing for efifb\n");

If we're going to use the "efifb" prefix, change those to pr_info and
define pr_fmt - lotsa examples in the kernel sources.

More importantly, you'd need a consensus from people that the printks in
efifb are really not interesting and should be behind efi=debug.

HTH.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
