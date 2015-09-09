From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 06/16] x86/efi: Generating random HMAC key for siging
 hibernate image
Date: Wed, 9 Sep 2015 13:15:45 +0100
Message-ID: <20150909121545.GD4973@codeblueprint.co.uk>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-7-git-send-email-jlee@suse.com>
 <20150820204044.GG2567@codeblueprint.co.uk>
 <20150827090452.GB27415@linux-rxt1.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150827090452.GB27415-empE8CJ7fzk2xCFIczX1Fw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 27 Aug, at 05:04:52PM, joeyli wrote:
> 
> The purpose of checking attribute of hibernation key variable is 
> in case someone created a key variable on runtime environment _before_
> this kernel create boot service variable. That causes EFI stub may load
> a key that from non-secure environment.
> 
> That's why delete non-boot service variable and create new one here.
 
I think bailing is more appropriate in that case, not deleting the
variable. The environment is not what we expected it to be, so we
shouldn't tamper with it.

But I don't feel super strongly about this point. I just wanted to
raise the question of whether it actually makes sense to delete the
variable that we obviously didn't create or whether it makes more
sense to refuse to verify hibernation images.

> > > diff --git a/arch/x86/include/asm/suspend.h b/arch/x86/include/asm/suspend.h
> > > index 2fab6c2..ab463c4 100644
> > > --- a/arch/x86/include/asm/suspend.h
> > > +++ b/arch/x86/include/asm/suspend.h
> > > @@ -3,3 +3,12 @@
> > >  #else
> > >  # include <asm/suspend_64.h>
> > >  #endif
> > > +
> > > +#ifdef CONFIG_HIBERNATE_VERIFICATION
> > > +#include <linux/suspend.h>
> > > +
> > > +struct hibernation_keys {
> > > +	unsigned long hkey_status;
> > > +	u8 hibernation_key[HIBERNATION_DIGEST_SIZE];
> > > +};
> > > +#endif
> > 
> > Have you given any thought to how things are going to work if we
> > change the hash function in the future, or provide a choice? That
> > information doesn't appear anywhere in the above struct.
> > 
> 
> Do you mean the hash function of signing hibernation image changed, so the
> hibernation key also need to re-generate for new length?
 
Yeah, that kind of thing.

> I will add a field in struct to forward the length of hibernation key variable.
> In the future kernel can check the length to handle the change.

Would it also make sense to explicitly record the hash function used
as well as the length?

-- 
Matt Fleming, Intel Open Source Technology Center
