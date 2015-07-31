From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 02/16] x86/efi: Add get and set variable to EFI
 services pointer table
Date: Fri, 31 Jul 2015 18:14:52 +0800
Message-ID: <20150731101452.GE13113@linux-rxt1.site>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <1437056730-15247-3-git-send-email-jlee@suse.com>
 <1438269598.11322.2.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438269598.11322.2.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jul 30, 2015 at 04:19:58PM +0100, Matt Fleming wrote:
> On Thu, 2015-07-16 at 22:25 +0800, Lee, Chun-Yi wrote:
> > Add get variable and set variable function to EFI services pointer
> > table for supporting later functions of hibernate signature
> > verification to keep the HMAC key in efi boot service veriable.
> > 
> > Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> 
> Maybe mention that we want to be able to read/write variables from
> within the EFI boot stub? That's really why you want to add
> {get,set}_variable pointers.
>

I will add more detail for accessing efi boot service
variable is because that will not touched by unauthenticated
codes.
 
> s/veriable/variable/
> 

I will fix the typo.

> Rest of the patch looks good.
> 

Thanks a lot!
Joey Lee
