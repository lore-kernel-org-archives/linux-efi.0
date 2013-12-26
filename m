From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: split efi systab in sysfs
Date: Thu, 26 Dec 2013 10:17:06 +0800
Message-ID: <20131226021705.GC3750@dhcp-16-126.nay.redhat.com>
References: <20131226015308.GA3750@dhcp-16-126.nay.redhat.com>
 <52BB8C8F.1020606@zytor.com>
 <20131226021238.GB3750@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131226021238.GB3750-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

CCing Simon and kexec list

On 12/26/13 at 10:12am, Dave Young wrote:
> On 12/25/13 at 05:55pm, H. Peter Anvin wrote:
> > On 12/25/2013 05:53 PM, Dave Young wrote:
> > > Hi, Matt and Peter
> > > 
> > > Currently /sys/firmware/efi/systab contains multi-lines for efi systab
> > > entries. As previous discussion with Greg, this is not a good in sysfs.
> > > I wonder if there's other users for this file except kexec-tools.
> > > 
> > > If kexec-tools is the only user, maybe I can split it as several files.
> > > In kexec-tools just use /sys/firmware/efi/"$entry_name" and if $entry_name
> > > does not exist then switch to old systab file. 
> > > 
> > 
> > Yes, the sysfs standard is "one entry per datum".  I have no idea about
> > who the user(s) might be, though.
> 
> Even the only known user kexec-tools, for new kernel + old kexec-tools we
> have no way to support, maybe this systab should be kept forever...
