From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: eboot.c regression allows boot, from v3.7 on- no boot with UEFI,
 only legacy, bisect results
Date: Thu, 3 Apr 2014 22:04:44 +0100
Message-ID: <20140403210444.GB5222@console-pimps.org>
References: <CAEigmK-pY+9XF4V-KRZrbiO8GY5Fs6scE+Ehm1zc5T8V2RiB9g@mail.gmail.com>
 <20140403210342.GA5222@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140403210342.GA5222-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel McLellan <daniel.mclellan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Adding addresses for real this time... )

On Thu, 03 Apr, at 10:03:42PM, Matt Fleming wrote:
> (Adding linux-efi and correct Matthew's address)
> 
> On Fri, 28 Mar, at 04:08:36PM, Daniel McLellan wrote:
> > System: Hewlett-Packard product: HP EliteBook 2570p
> > CPU~Dual core Intel Core i7-3520M CPU (-HT-MCP-)
> > Kernel: 3.12.4-2-hplove x86_64 (64 bit) Desktop: Enlightenment 0.18.99.18202
> > Distro: Arch Linux
> > 
> > 
> > I believe this issue is common to only a few iterations of ivy bridge
> > 
> > https://bbs.archlinux.org/viewtopic.php?id=156670
> > https://bugs.archlinux.org/task/33745?project=1
> > 
> > I had been patching eboot.c to v3.7 with the attached
> > efi_hp_boot.patch, but due to the recent changes in eboot.c (in v3.13)
> > I decided to bisect, and identified the following:
> > 
> > # first bad commit: [dd5fc854de5fd37adfcef8a366cd21a55aa01d3d] EFI:
> > Stash ROMs if they're not in the PCI BAR
> > 
> > My next step is diffing the eboot.c from v3.13.
> > 
> > or would a better path be to check for ivy bridge?
> 
> Daniel, could you try booting a recent kernel, without your patch
> applied and with the earlyprintk=efi,keep kernel parameter.
> 
> Meanwhile I'm going to try and reproduce this error.
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center

-- 
Matt Fleming, Intel Open Source Technology Center
