From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [edk2] Corrupted EFI region
Date: Mon, 2 Sep 2013 09:19:53 +0100
Message-ID: <20130902081953.GC28598@console-pimps.org>
References: <52001896.1030509@redhat.com>
 <20130805220808.GC14067@pd.tnic>
 <20130806141036.GD14891@pd.tnic>
 <520116D1.2010000@redhat.com>
 <20130807151935.GJ17920@pd.tnic>
 <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com>
 <20130807201908.GG2515@console-pimps.org>
 <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com>
 <20130808101730.GJ2515@console-pimps.org>
 <1AEC7AA8-D49E-485F-A634-31B4F0D07083@apple.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1AEC7AA8-D49E-485F-A634-31B4F0D07083-2kanFRK1NckAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Fish <afish-2kanFRK1NckAvxtiuMwx3w@public.gmane.org>
Cc: edk2-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Brian Richardson <brian.richardson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 08 Aug, at 06:46:02AM, Andrew Fish wrote:
> 
> On Aug 8, 2013, at 3:17 AM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> 
> > On Wed, 07 Aug, at 02:10:28PM, Andrew Fish wrote:
> >> Well the issue I see is I don't think OS X or Windows are doing this.
> >> So I'm guessing there is some unique thing beings done on the Linux
> >> side and we don't have good tests to catch bugs in the EFI
> >> implementations. If the Linux loader hides the bugs and we don't hit
> >> them with other operating systems they are never going to get fixed.
> >> It would be good if we could track down some of these issues and make
> >> a request for some tests that can help catch these issues. The tests
> >> would be part of UEFI.org, but since some of us play in both worlds we
> >> can forward the known issues to the UEFI test work group. 
> > 
> > I'm all for helping to develop tests that catch these kind of bugs.
> > What's the next step?
> > 
> 
> I'll bring this up with UEFI.org.
 
For those attending the UEFI plugfest in New Orleans this would be a
good topic for discussion - figuring out a collaboration process to get
new tests in place.

-- 
Matt Fleming, Intel Open Source Technology Center
