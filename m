From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: efi: be more paranoid about available space when creating
 variables
Date: Tue, 26 Mar 2013 23:33:55 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF79528@USINDEM103.corp.hds.com>
References: <1364004995.3728.76.camel@deadeye.wl.decadent.org.uk>
 <1364010441.3728.82.camel@deadeye.wl.decadent.org.uk>
 <CAL01qpvaP7_YWS+vhjTskvisCyjxg-28WBAjSQftrSmnCphwdw@mail.gmail.com>
 <1364070731.2553.47.camel@x230.sbx07502.somerma.wayport.net>
 <514E31B0.4030305@intel.com> <20130326035600.GA6209@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130326035600.GA6209-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

>    We should be able to calculate that by simply
>     summing the size of each available variable and subtracting that from
>     the total storage space. With luck this will fix the problem described in
>     https://bugzilla.kernel.org/show_bug.cgi?id=55471 without permitting
>     damage to occur to the machines 68d9298 was attempting to fix.

I like the idea of this patch. It could be a long term solution.

If we can calculate the size of available variables by ourselves,
 we don't need to call QueryVariableInfo().
It makes efivars robust against buggy firmwares.
Also, this patch actually fixes a serious bug, failing boot up.

In theory, QueryVariableInfo() should return accurate values to kernel.
But, it doesn't in practice.

I think creating blacklist will be like playing whac-a-mole, because
we can't anticipate how many buggy firmwares will appear in the future.

Seiji
