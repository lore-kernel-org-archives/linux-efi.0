From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [edk2] Corrupted EFI region
Date: Thu, 8 Aug 2013 11:17:30 +0100
Message-ID: <20130808101730.GJ2515@console-pimps.org>
References: <51FFD5B0.9080000@redhat.com>
 <20130805164731.GG31845@pd.tnic>
 <52001896.1030509@redhat.com>
 <20130805220808.GC14067@pd.tnic>
 <20130806141036.GD14891@pd.tnic>
 <520116D1.2010000@redhat.com>
 <20130807151935.GJ17920@pd.tnic>
 <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com>
 <20130807201908.GG2515@console-pimps.org>
 <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D5982201-6DC4-469F-812A-74A8402ADEE9-2kanFRK1NckAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Fish <afish-2kanFRK1NckAvxtiuMwx3w@public.gmane.org>
Cc: edk2-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Brian Richardson <brian.richardson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 07 Aug, at 02:10:28PM, Andrew Fish wrote:
> Well the issue I see is I don't think OS X or Windows are doing this.
> So I'm guessing there is some unique thing beings done on the Linux
> side and we don't have good tests to catch bugs in the EFI
> implementations. If the Linux loader hides the bugs and we don't hit
> them with other operating systems they are never going to get fixed.
> It would be good if we could track down some of these issues and make
> a request for some tests that can help catch these issues. The tests
> would be part of UEFI.org, but since some of us play in both worlds we
> can forward the known issues to the UEFI test work group. 

I'm all for helping to develop tests that catch these kind of bugs.
What's the next step?

> Is it possible to have a switch to turn off the not required behavior
> (hiding EFI implementation bugs) so that bad platforms could be
> detected? This would be a good thing to try on platforms at the
> upcoming UEFI Plugfest hosted by the Linux Foundation and the UEFI
> Forum, so the bad behavior can be detected and the vendors can fix the
> issue. 

We don't tend to provide switches for the kernel to turn off workarounds
because users run the risk of inadvertently stopping their machines from
booting correctly. Also, because the major distributions will always
enable the workarounds, the kernel would need to be built manually to
see any kind of informative error message.

What we do have though is the Firmware Testsuite - fwts,

  https://wiki.ubuntu.com/Kernel/Reference/fwts

I know that Brian (Cc'd) has been doing some excellent advocacy work,
getting people at plugfetsts to run this testsuite which tests for
implementation bugs from within a Linux environment.

> PS Also maybe it would be possible to key this work around behavior on
> the EFI/UEFI version. So for example no work-around after UEFI v2.3.1?

That would really depend on who has seen this bug and on which
platforms. Is there a particular reason that mapping the boot services
regions as-is would cause problems?

-- 
Matt Fleming, Intel Open Source Technology Center
