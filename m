From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 07/16] efi: Make efi_status_to_err() public
Date: Thu, 27 Aug 2015 17:06:26 +0800
Message-ID: <20150827090626.GC27415@linux-rxt1.site>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-8-git-send-email-jlee@suse.com>
 <20150820150706.GE2567@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150820150706.GE2567-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Aug 20, 2015 at 04:07:06PM +0100, Matt Fleming wrote:
> On Tue, 11 Aug, at 02:16:27PM, Lee, Chun-Yi wrote:
> > Moved the function of transferring EFI status to kernel error for
> > later used by EFI stub.
>  
> Might I suggest:
> 
>  "Move the function for converting EFI status to kernel error values
>   from drivers/firmware/efi/ to include/linux/efi.h for use by the x86
>   EFI stub in an upcoming patch."
> 
> ?
> 

Thanks for your suggestion, I will follow it.

> > Reviewed-by: Jiri Kosina <jkosina-IBi9RG/b67k@public.gmane.org>
> > Tested-by: Jiri Kosina <jkosina-IBi9RG/b67k@public.gmane.org>
> > Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> > ---
> >  drivers/firmware/efi/vars.c | 33 ---------------------------------
> >  include/linux/efi.h         | 33 +++++++++++++++++++++++++++++++++
> >  2 files changed, 33 insertions(+), 33 deletions(-)
> 
> The patch content is fine,
> 
> Reviewed-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 

Thanks

> -- 
> Matt Fleming, Intel Open Source Technology Center

Joey Lee
