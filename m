From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
Date: Tue, 12 Mar 2013 19:54:33 +0000
Message-ID: <1363118073.15011.275.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>
	 <5138FAD9.7050504@zytor.com> <20130307205915.GF24233@thinkpad-t410>
	 <1362694529.15011.211.camel@mfleming-mobl1.ger.corp.intel.com>
	 <513911F9.8050308@zytor.com> <20130311211750.GB8440@thinkpad-t410>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130311211750.GB8440@thinkpad-t410>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-03-11 at 16:17 -0500, Seth Forshee wrote:
> Here's a patch that does the command line option. I'm happy with either
> one.

I like the idea, but isn't the logic backwards? I would have expected
s/EFI_VARS_PSTORE_DEFAULT_DISABLE/EFI_VARS_PSTORE/g and then 'default y'
in the Kconfig file to maintain backward compatibility?

Is there a reason that wouldn't work?

I know that Linus has previously denounced setting new Kconfig symbols
to 'y' by default, but I think there's a case here for doing exactly
that since the previous behaviour was always enabled. The networking
folks did something similar recently, where they introduced new Kconfig
symbols for existing functionality that was previously on by default.

[...]

> +#ifdef CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
> +static bool efivars_pstore_disable = true;
> +#else
> +static bool efivars_pstore_disable = false;
> +#endif
> +module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
> +

static bool efivars_pstore_enable = IS_ENABLED(CONFIG_EFI_VARS_PSTORE) ?
