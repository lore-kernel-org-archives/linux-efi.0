From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: PROBLEM: Kernel panic on EFI BGRT early init code (kernel
 4.11/4.12rc2) [regression]
Date: Sat, 27 May 2017 13:14:27 +0800
Message-ID: <20170527051427.GA3492@dhcp-128-65.nay.redhat.com>
References: <86c36f9b-f633-3354-d676-7693f35dae0d@gmail.com>
 <20170526012342.GA3096@dhcp-128-65.nay.redhat.com>
 <a32eea98-9576-1ee7-c27a-b165204d825f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a32eea98-9576-1ee7-c27a-b165204d825f-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maniaxx <tripleshiftone-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Seems efi list was dropped, it if is intended not to cc public list
please let me know.

On 05/26/17 at 03:04pm, Maniaxx wrote:
> On 26.05.2017 at 03:23 wrote Dave Young:
> > Hello,
> >
> > On 05/26/17 at 12:49am, Maniaxx wrote:
> >> PROBLEM: Kernel panic on EFI BGRT early init code (kernel 4.11/4.12rc2)
> >> [regression]
> >>
> >> Commit:
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7b0a911478c74ca02581d496f732c10e811e894f
> >>
> >> Kernel 4.10 and below are ok. 4.11 and 4.12rc2.r62.g2426125ab4eb freeze.
> >> Reverting the commit on 4.11 fixes the problem. Hardware report and
> >> earlyprintk output on the bugtracker.
> >> https://bugzilla.kernel.org/show_bug.cgi?id=195633
> >>
> >> earlyprintk (text version):
> >> https://bbs.archlinux.org/viewtopic.php?pid=1713322#p1713322
> >>
> >> Discussions on Arch Linux Forum:
> >> https://bbs.archlinux.org/viewtopic.php?pid=1713344
> >> https://bbs.archlinux.org/viewtopic.php?id=226490
> >>
> > Can you try below patch see if it works for you?
> > https://lkml.org/lkml/2017/5/15/940
> >
> > Thanks
> > Dave
> >
> Hello,
> doesn't work. Probably because the condition isn't met (i do have an EFI
> system). At least 4 people reported the problem and if i see it right
> all of them have Asus/Asrock boards. The BGRT init (at least on my side)
> always crashed with an Oops (on 4.10 and below) but never panic'd/froze.

Can you double check it works before the commit of below? If machine
boots fine then check /sys/firmware/acpi/bgrt/image see if it exists or
not. One possible reason is bgrt init code bail out for some reason but
not in new code.

If old code boots fine but without correct /sys/firmware/acpi/bgrt/*
then probably you can debug why it is not created then we can get some
clue about this report.

BTW if you can manange to save full kernel log it would be also helpful.

commit 7b0a911478c74ca02581d496f732c10e811e894f
Author: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Tue Jan 31 13:21:40 2017 +0000

    efi/x86: Move the EFI BGRT init code to early init code

> 
> -Maniaxx
> 

Thanks
Dave
