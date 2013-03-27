From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: efi: be more paranoid about available space when creating variables
Date: Wed, 27 Mar 2013 09:10:42 +0000
Message-ID: <5152B792.1070104@console-pimps.org>
References: <1364004995.3728.76.camel@deadeye.wl.decadent.org.uk> <1364010441.3728.82.camel@deadeye.wl.decadent.org.uk> <CAL01qpvaP7_YWS+vhjTskvisCyjxg-28WBAjSQftrSmnCphwdw@mail.gmail.com> <1364070731.2553.47.camel@x230.sbx07502.somerma.wayport.net> <514E31B0.4030305@intel.com> <20130326035600.GA6209@srcf.ucam.org> <A5ED84D3BB3A384992CBB9C77DEDA4D41AF79528@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF79528-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26/03/13 23:33, Seiji Aguchi wrote:
> If we can calculate the size of available variables by ourselves,
>  we don't need to call QueryVariableInfo().
> It makes efivars robust against buggy firmwares.
> Also, this patch actually fixes a serious bug, failing boot up.
> 
> In theory, QueryVariableInfo() should return accurate values to kernel.
> But, it doesn't in practice.

Exactly and this patch is *still* relying on the output of
QueryVariableInfo(). I doubt DataSize will be accurate everywhere either.

> I think creating blacklist will be like playing whac-a-mole, because
> we can't anticipate how many buggy firmwares will appear in the future.

You wouldn't need to reimplement the workaround for every broken
machine, you just add the machine's identifiers to the list. And no, we
can't anticipate the firmware bugs we'll see in the future which is why
we need to solve this on a case-by-case basis.

-- 
Matt Fleming, Intel Open Source Technology Center
