From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: efi: be more paranoid about available space when creating
 variables
Date: Tue, 26 Mar 2013 04:35:42 +0000
Message-ID: <20130326043542.GA6841@srcf.ucam.org>
References: <1364004995.3728.76.camel@deadeye.wl.decadent.org.uk>
 <1364010441.3728.82.camel@deadeye.wl.decadent.org.uk>
 <CAL01qpvaP7_YWS+vhjTskvisCyjxg-28WBAjSQftrSmnCphwdw@mail.gmail.com>
 <1364070731.2553.47.camel@x230.sbx07502.somerma.wayport.net>
 <514E31B0.4030305@intel.com>
 <20130326035600.GA6209@srcf.ucam.org>
 <5151248F.2010303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5151248F.2010303-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 26, 2013 at 12:31:11PM +0800, Lingzhu Xiang wrote:
> On 03/26/2013 11:56 AM, Matthew Garrett wrote:
> >     Combined with commit 68d9298 this can cause problems. Some implementations
> >     don't garbage collect until the remaining space is smaller than the maximum
> >     variable size, and as a result check_var_size() will always fail once more
> >     than 50% of the variable store has been used even if most of that space is
> >     marked as available for garbage collection. The user is unable to create
> >     new variables, and deleting variables doesn't increase the remaining space.
> 
> Do you mean they don't garbage collect across reboots?

Only if the remaining space has fallen below a threshold.

> >     The problem that 68d9298 was attempting to avoid was one where certain
> >     platforms fail if the actively used space is greater than 50% of the
> >     available storage space. We should be able to calculate that by simply
> >     summing the size of each available variable and subtracting that from
> >     the total storage space. With luck this will fix the problem described in
> 
> What about the size of variable name, paddings, headers (especially
> authenticated ones) and other internal stuff?

Ah, true, it should at least include the name. As for padding, headers 
etc - these are great questions and ideally we'd get some feedback from 
(say) Samsung as to how much extra data is used in the variables.

> >     https://bugzilla.kernel.org/show_bug.cgi?id=55471 without permitting
> >     damage to occur to the machines 68d9298 was attempting to fix.
> 
> This bug is reporting "query_variable_info sets max_size as zero".
> If that's true, this patch doesn't seem to account for that case.

Oh huh. You're right, I missed that. In which case we should remove that 
chunk - presumably we'll get an error on write then anyway. It does 
appear to have fixed Oleg's problem in the same bug.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
