From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: PROBLEM: Kernel panic on EFI BGRT early init code (kernel
 4.11/4.12rc2) [regression]
Date: Fri, 26 May 2017 09:23:42 +0800
Message-ID: <20170526012342.GA3096@dhcp-128-65.nay.redhat.com>
References: <86c36f9b-f633-3354-d676-7693f35dae0d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <86c36f9b-f633-3354-d676-7693f35dae0d-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maniaxx <tripleshiftone-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hello,

On 05/26/17 at 12:49am, Maniaxx wrote:
> PROBLEM: Kernel panic on EFI BGRT early init code (kernel 4.11/4.12rc2)
> [regression]
> 
> Commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7b0a911478c74ca02581d496f732c10e811e894f
> 
> Kernel 4.10 and below are ok. 4.11 and 4.12rc2.r62.g2426125ab4eb freeze.
> Reverting the commit on 4.11 fixes the problem. Hardware report and
> earlyprintk output on the bugtracker.
> https://bugzilla.kernel.org/show_bug.cgi?id=195633
> 
> earlyprintk (text version):
> https://bbs.archlinux.org/viewtopic.php?pid=1713322#p1713322
> 
> Discussions on Arch Linux Forum:
> https://bbs.archlinux.org/viewtopic.php?pid=1713344
> https://bbs.archlinux.org/viewtopic.php?id=226490
> 

Can you try below patch see if it works for you?
https://lkml.org/lkml/2017/5/15/940

Thanks
Dave
