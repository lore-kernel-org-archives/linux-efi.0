From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 6/6] x86/efi: introduce EFI_BOOT_SERVICES_WARN
Date: Sun, 14 Sep 2014 16:18:47 +0100
Message-ID: <20140914151847.GK18582@console-pimps.org>
References: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
 <1410633376-8822-7-git-send-email-ricardo.neri-calderon@linux.intel.com>
 <20140914000130.GC18296@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140914000130.GC18296-K5JNixvcfoxupOikMc4+xw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Glenn P. Williamson" <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 14 Sep, at 02:01:30AM, Borislav Petkov wrote:
> On Sat, Sep 13, 2014 at 11:36:16AM -0700, Ricardo Neri wrote:
> > Being more verbose about this kind of illegal access from the firmware
> > increases the likelihood of this kind firmware bugs to be fixed.
> 
> I sincerely hope you're right and, more importantly, how do we make sure
> those warnings get seen in time for a fix to even be possible..?

Some firmware teams do run Linux as part of their validation process,
and have been known to pay attention to the kernel boot messages. So
there's definitely hope there.

But we are also taking a more active approach with the Linux UEFI
Validation project [1], where we consume these kinds of error messages
and turn them into explicit test passes/failures.

We've been attending the UEFI plugfests and trying to work directly with
firmware engineers to bridge that communication gap between firmware and
OS, so that we can fix these kinds of bugs before they appear in the
wild.

[1] - https://01.org/linux-uefi-validation

-- 
Matt Fleming, Intel Open Source Technology Center
