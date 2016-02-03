From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Make efivarfs entries immutable by default.
Date: Wed, 3 Feb 2016 14:50:05 +0000
Message-ID: <20160203145005.GH10351@bivouac.eciton.net>
References: <1454504567-2826-1-git-send-email-pjones@redhat.com>
 <1454504567-2826-5-git-send-email-pjones@redhat.com>
 <20160203141354.GH2597@codeblueprint.co.uk>
 <20160203141959.GA3319@einval.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160203141959.GA3319-nt0JYOx6u4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve McIntyre <steve-nt0JYOx6u4DQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 03, 2016 at 02:20:04PM +0000, Steve McIntyre wrote:
> On Wed, Feb 03, 2016 at 02:13:54PM +0000, Matt Fleming wrote:
> >On Wed, 03 Feb, at 08:02:47AM, Peter Jones wrote:
> >I see no mention of the benefit of using the immutable flag versus
> >making all protected files read-only.
> >
> >Is it not possible to just make everything that needs protecting 444?
> >That way users can use standard tools if they really, really want to
> >delete/write to a variable. It has the added benefit of protecting
> >users from trashing variables that are important for POST too (as
> >opposed to deleting them altogether).
> 
> Just making them read-only won't stop people trashing things as
> root. They're already owned by root anyway aren't they??

The point is to stop people _accidentally_ triggering
brickness-inducing bugs in completely broken firmware.

This set achieves that.

> Although if we're at the stage of doing things this wat then is there
> much to be gained by having a filesystem interface in the first place?

These systems would be manually brickable regardless of what interface
you implemented, or under which operating system. Probably even from
the UEFI Shell.

/
    Leif
