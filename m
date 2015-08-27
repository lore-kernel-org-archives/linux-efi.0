From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 04/16] x86/efi: Generating random number in EFI stub
Date: Thu, 27 Aug 2015 12:06:37 +0800
Message-ID: <20150827040637.GA24088@linux-rxt1.site>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-5-git-send-email-jlee@suse.com>
 <20150820141221.GC2567@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150820141221.GC2567-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt, 

Thanks for your reviewing and sorry for my delay.

On Thu, Aug 20, 2015 at 03:12:21PM +0100, Matt Fleming wrote:
> On Tue, 11 Aug, at 02:16:24PM, Lee, Chun-Yi wrote:
> > This patch adds the codes for generating random number array as the
> > HMAC key that will used by later EFI stub codes.
> > 
> > The original codes in efi_random copied from aslr and add the codes
> > to accept input entropy and EFI debugging. In later patch will add
> > the codes to get random number by EFI protocol. The separate codes
> > can avoid impacting aslr function.
>  
> Is there some way we can share the code between aslr and the EFI boot
> stub? People may not review both files when making changes and so bug
> fixes to one might not appear in the other.
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center

The origin design is base on get_random_long() from aslr, so I direct
copy it to efi_random.c then modified it. 
There have some reasons I didn't share the code with aslr:

 - There have some debug_puttstr() for debugging in aslr, but those
   debugging log do not work in EFI stub, and I want put efi_print
   for debugging purpose. I don't want affect the code in aslr, so
   I choice copy get_random_long() to efi_random.c specific for EFI stub.

 - In subsequent patches add EFI random protocol support to
   get_random_longh().

In next version, I will try to extract shared code to misc.c to reuse them
between aslr and efi_random.


Thanks a lot!
Joey Lee
