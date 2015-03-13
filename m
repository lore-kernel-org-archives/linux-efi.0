From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Fri, 13 Mar 2015 15:42:13 +0100
Message-ID: <20150313144213.GA19009@kroah.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AC95C@PGSMSX102.gar.corp.intel.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD@PGSMSX102.gar.corp.intel.com>
 <20150306213912.GA8020@fenchurch.internal.datastacks.com>
 <20150310122652.GA17573@codeblueprint.co.uk>
 <20150310152155.GB1208@fenchurch.internal.datastacks.com>
 <CALCETrXMvDqMvRf2yzRvpjHQB5pip5zNiihAccCc9Sm5UWGysg@mail.gmail.com>
 <20150310154000.GD1208@fenchurch.internal.datastacks.com>
 <CALCETrUDuTt_BK1JSFU=_EEujpm1ekzmkte-c3vxuRW7hWPUPQ@mail.gmail.com>
 <20150312224754.GD24174@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150312224754.GD24174-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 12, 2015 at 10:47:54PM +0000, Matt Fleming wrote:
> On Tue, 10 Mar, at 08:51:59AM, Andy Lutomirski wrote:
> > 
> > I'm not 100% happy with write(2) (which is all we have in sysfs) for
> > two reasons:
> > 
> > 1. If we write a file name, eww.  That's more complicated, requires
> > temporary files, has annoying mount namespace issues, etc.
> > 
> > 2. If we write the full contents, we need to do it in a single call to
> > write.  That means that we can't use cat, which mostly defeats the
> > purpose.  In fact, using cat could be actively harmful.
> 
> At this point I'd really like Greg to chime in.
> 
> In principal, I'm not stricly opposed to using a simple char device
> provided that it's not essentially a copy and paste of code from
> drivers/base/firmware_class.c.
> 
> Greg?

Yes, I don't want a character driver here for this if at all possible.
Just stick with the firmware download code, it's there and should work
"as-is" for your stuff.

thanks,

greg k-h
