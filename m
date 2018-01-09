From: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: arm64 crashkernel fails to boot on acpi-only machines due to
 ACPI regions being no longer mapped as NOMAP
Date: Tue, 9 Jan 2018 14:22:38 +0900
Message-ID: <20180109052237.GC18820@linaro.org>
References: <CACi5LpMUnUKxiALAHW9_PE2RYC8GNWLPGpdJ5ca53g=v3rNkfg@mail.gmail.com>
 <20171222083308.cy3vwlyhig22q5ee@fireball>
 <CACi5LpNF5i3Eo7nMLr_z9r4VVbXhDwSJCQoiOh-A_jB6hV0_2Q@mail.gmail.com>
 <20171225032500.GA8877@linaro.org>
 <CACi5LpMzYidDaC0_yfwgVOisH-FqcNViYj+Z54uKfUtHkJKKXA@mail.gmail.com>
 <20171226013217.GA2119@dhcp-128-65.nay.redhat.com>
 <20171226013517.GA2186@dhcp-128-65.nay.redhat.com>
 <20171226022807.GB8877@linaro.org>
 <CACi5LpNRtXh-j9Y9HwRatDZwRMr++-ZeaSnk62vD3btpxsVv7w@mail.gmail.com>
 <20171226065845.GB5354@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171226065845.GB5354-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 26, 2017 at 02:58:45PM +0800, Dave Young wrote:
> On 12/26/17 at 08:26am, Bhupesh Sharma wrote:
> > On Tue, Dec 26, 2017 at 7:58 AM, AKASHI Takahiro
> > <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > > On Tue, Dec 26, 2017 at 09:35:17AM +0800, Dave Young wrote:
> > >> [snip]
> > >> > > > Well, we may be able to change pr_warn() to pr_warn_once() here, but
> > >> > > > I hope that adding "numa=off" to kernel command line should also work.
> > >> > >
> > >> > > Hmm, adding "numa=off" to crashkernel bootargs works, and TBH it was
> > >> > > my initial thought process as well, but I am not sure if this will
> > >> > > cause any regressions on aarch64 systems which use crashdump feature.
> > >> >
> > >> > It should be fine since we use numa=off by default for all other arches
> > >> > ie. x86, ppc64 and s390. Actually disabling numa in kdump kernel can save
> > >> > mm component memory usage.
> > >> >
> > >>
> > >> Forgot to say I means in RHEL and Fedora we use numa=off for kdump..
> > >
> > > Thank you for the clarification.
> > > (It might be better to make numa off automatically if maxcpus == 0 (and 1?).)
> > >
> > 
> > Not sure if we can leave this to the distribution-specific kdump
> > scripts (as the crashkernel boot can be held up for sufficient time
> > and may appear stuck). The distribution scripts may be different (for
> > e.g. ubuntu and RHEL/fedora) across distributions and may have
> > different bootarg options.
> 
> Personally I think distribution should take care of this param as for
> kdump.  But as AKASHI said it could be a issue for 1st kernel with
> nr_cpus=1 booting.  Problem is why we do not see this issue on other
> machines.

The issue won't be kdump-specific. Theoretically, it also takes place
when "mem=" is specified on numa.

Since we can avoid annoying messages by adding "numa=off", I'm reluctant to
suppress most of messages but the first. My suggestion here is to add some
notes in Documentation/kdump/kdump.txt regarding NUMA case.

Thanks,
Takahiro AKASHI


> > 
> > So how about considering a kernel fix only which doesn't require
> > relying on changing the distribution-specific kdump scripts, as we
> > should avoid introducing a regression while trying to fix a regression
> > :)
> > 
> > Just my 2 cents.
> > 
> > Thanks,
> > Bhupesh
> 
> Thanks
> Dave
