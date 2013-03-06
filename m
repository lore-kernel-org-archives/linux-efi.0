From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: sysfs: cannot create duplicate filename
Date: Wed, 06 Mar 2013 14:29:30 +0000
Message-ID: <1362580170.15011.85.camel@mfleming-mobl1.ger.corp.intel.com>
References: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ@mail.gmail.com>
	 <5135BD66.1030005@redhat.com>
	 <1362575941.15011.56.camel@mfleming-mobl1.ger.corp.intel.com>
	 <bd0c3451a7342302623c09cac09bcbfc@shealevy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bd0c3451a7342302623c09cac09bcbfc-yfkUTty7RcRWk0Htik3J/w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shea-yfkUTty7RcRWk0Htik3J/w@public.gmane.org
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2013-03-06 at 08:35 -0500, shea-yfkUTty7RcRWk0Htik3J/w@public.gmane.org wrote:
> Unrelated to the initial issue, but with the growing number of fixes 
> for buggy firmware out there, maybe we should consider an approach 
> similar to CONFIG_PCI_QUIRKS and the separate drivers/pci/quirks.c, 
> where all of the system specific EFI quirks are isolated and can be 
> compiled out if you know your firmware is good?

Right, the firmware bug spectrum is indeed starting to grow rapidly. I
was hoping we could avoid doing something like PCI quirks because that
whole thing is a mess and I am concerned about an explosion of quirks
that would need to be maintained, some being used in core architecture
code. Upto now, we've been catering for the least common denominator,
which has worked, but obviously isn't ideal.

My plan has always been to try and hold off on introducing something
like quirks until my hand is forced. But it is likely that will happen
sooner rather than later. 

One problem we have though, is clearly identifying machines that suffer
from these bugs because of the cross-pollination of firmware from
Independent BIOS Vendors (IBVs) and OEMs. In theory, we could use the
FirmwareRevision field in the EFI System Table, along with DMI strings
and such.

> Also might be nice to have a separate config option specifically for 
> all the Apple quirks, as their EFI seems to be the worst out there with 
> respect to following standards.

AFAIK, it's that they're based on EFI 1.10, so pre-UEFI days.

-- 
Matt Fleming, Intel Open Source Technology Center
