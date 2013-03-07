From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
Date: Thu, 7 Mar 2013 14:59:15 -0600
Message-ID: <20130307205915.GF24233@thinkpad-t410>
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>
 <5138FAD9.7050504@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5138FAD9.7050504-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 07, 2013 at 12:38:49PM -0800, H. Peter Anvin wrote:
> On 03/07/2013 09:40 AM, Seth Forshee wrote:
> > We know that with some firmware implementations writing too much data to
> > UEFI variables can lead to bricking machines. Recent changes attempt to
> > address this issue, but for some it may still be prudent to avoid
> > writing large amounts of data until the solution has been proven on a
> > wide variety of hardware.
> > 
> > Crash dumps or other data from pstore can potentially be a large data
> > source. Add a new option, CONFIG_EFI_VARS_PSTORE, which can be set to N
> > to avoid using efivars as a backend to pstore.
> 
> What about a command line option?

That could be done. I'm assuming you want this instead of a config
option, defaulted to on?

How would you feel about a config option for the default value of the
command line option? I intend to default this to off in Ubuntu for a
while as a colleague's machine was recently bricked on two different
occasions after the kernel oopsed. The config option would simplify
things a bit for us, though we could always carry a patch changing the
default value.

> > -#ifdef CONFIG_PSTORE
> > +#if defined(CONFIG_PSTORE) && defined(CONFIG_EFI_VARS_PSTORE)
> 
> Redundant.

Yes, good point.

Thanks,
Seth
