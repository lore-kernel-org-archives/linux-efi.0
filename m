From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [BUG] can't boot up: unable to handle kernel paging request at
 ffffffffff340003
Date: Wed, 12 Feb 2014 16:39:38 +0000
Message-ID: <20140212163938.GA20717@console-pimps.org>
References: <8738jr5t3e.fsf@redhat.com>
 <20140210175246.GB2887@console-pimps.org>
 <87mwhy8iaj.fsf@redhat.com>
 <20140211131640.GD2887@console-pimps.org>
 <87lhxh69u0.fsf@redhat.com>
 <20140211141846.GA1725@console-pimps.org>
 <1392221703.5612.164.camel@misato.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1392221703.5612.164.camel-RbGIw1UOYPVo/CpIj0byZw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Cc: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 12 Feb, at 09:15:03AM, Toshi Kani wrote:
> 
> Yes, I agree that the table size should be 0x38.  However, ACPI spec
> states that bit0 of status indicates if the boot image graphic is valid.
> This bit is set to 0 (invalid) on the system.  Can you check this bit
> and return when invalid? 

Seems reasonable to me. Anyone know of a reason that wouldn't work?

-- 
Matt Fleming, Intel Open Source Technology Center
