From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 01/20] efi: Add support for a UEFI variable
 filesystem
Date: Sun, 4 Nov 2012 21:06:27 +0000
Message-ID: <20121104210627.6f57662a@pyramind.ukuu.org.uk>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	<1351237923-10313-2-git-send-email-matt@console-pimps.org>
	<1351846416.14888.155.camel@mfleming-mobl1.ger.corp.intel.com>
	<20121103002249.63eb4142@pyramind.ukuu.org.uk>
	<20121103002132.GB18691@srcf.ucam.org>
	<1352060878.14888.193.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352060878.14888.193.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> +	if (datasize > remaining_size) {
> +		printk(KERN_ERR "efivars: Variable size too big\n");
> +		return -ENOSPC;

Why the printk - you've handed back a sensible error code. If you do have
a logging result you need to rate limit it as its from the user. I don't
think you need one - -ENOSPC is pretty clear !
