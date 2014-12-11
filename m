From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] Add esrt support.
Date: Thu, 11 Dec 2014 09:08:03 -0500
Message-ID: <20141211140802.GA17171@fenchurch.internal.datastacks.com>
References: <1418163514-22977-1-git-send-email-pjones@redhat.com>
 <1418164082-23534-1-git-send-email-pjones@redhat.com>
 <1418257161.2856.4.camel@ranerica-desk01>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1418257161.2856.4.camel@ranerica-desk01>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Neri, Ricardo" <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Parmeshwr_Prasad-DYMqY+WieiM@public.gmane.org" <Parmeshwr_Prasad-DYMqY+WieiM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Dec 11, 2014 at 12:19:23AM +0000, Neri, Ricardo wrote:
> On Tue, 2014-12-09 at 17:28 -0500, Peter Jones wrote:
> > Add sysfs files for EFI System Resource Table under
> > /sys/firmware/efi/esrt and for each EFI System Resource Entry under
> > entries/ as a subdir.
> > 
> > v2 with suggestions from bpetkov.
> > v3 with me remembering checkpatch.
> 
> Hi Peter,
> 
> I also see compilations errors after applying this patch to v3.18. I am
> using gcc ver gcc version 4.9.2 (Ubuntu 4.9.2-0ubuntu1~14.04) and doing
> make x86_64_defconfig && make:

Alright, then clearly something has gone wrong on my end.  I'll start
with a clean tree and see if I can't reproduce these problems and fix
them.

Thanks.

-- 
        Peter
