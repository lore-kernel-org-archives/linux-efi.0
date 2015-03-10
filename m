From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Tue, 10 Mar 2015 12:26:52 +0000
Message-ID: <20150310122652.GA17573@codeblueprint.co.uk>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AC95C@PGSMSX102.gar.corp.intel.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD@PGSMSX102.gar.corp.intel.com>
 <20150306213912.GA8020@fenchurch.internal.datastacks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150306213912.GA8020-FS9oOTXHwv9t4tGkRPVz9tcb/sdHg95EuydrBrBl+0sAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 06 Mar, at 04:39:12PM, Peter Jones wrote:
> 
> So again: do we really need or want to do this?

One thing that we totally lose the ability to do is use the capsule
interface for things *other* than firmware updates, e.g.

 https://lkml.org/lkml/2013/10/16/327 

Also, requiring embedded or custom OS to include fwupdate into their
existing boot solutions is a bit heavy handed when literally all they
want to do is cat a binary blob to a sysfs file.

I don't see why we can't have both solutions.

Another thing is that ESRT isn't going to be supported by every
platform.

So, for the sysfs interface, let's not allow loading from /lib. Let's
not require a userland tool. Let's just do,

  # echo /path/to/my/awesome/capsule.bin > /sys/../capsule

and be done with it.

Hmmm?

-- 
Matt Fleming, Intel Open Source Technology Center
