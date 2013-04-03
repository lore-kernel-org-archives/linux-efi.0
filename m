From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: Distinguish between "remaining space" and actually
 used space
Date: Wed, 03 Apr 2013 18:12:06 +0100
Message-ID: <515C62E6.1070004@console-pimps.org>
References: <515150EC.7040203@redhat.com>  <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>  <1364829240-26475-2-git-send-email-matthew.garrett@nebula.com>  <515C2A86.6070606@console-pimps.org> <1364996911.19098.9.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364996911.19098.9.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org" <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, "jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org" <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/04/13 14:48, Matthew Garrett wrote:
> On Wed, 2013-04-03 at 14:11 +0100, Matt Fleming wrote:
> 
>> This looks like something that will differ between implementations, and the
>> fact that it's appearing in our code is a sure sign that this isn't the way to
>> go.
> 
> Our choices right now are:
> 
> 1) Break machines that don't garbage collect on every reboot
> 2) Leave Samsungs (and some Lenovos?) vulnerable to bricking
> 3) Maintain a whitelist or blacklist that will inevitably be inadequate,
> either breaking otherwise working machines or risking bricking of broken
> ones
> 4) Attempt to implement something that'll work in all cases

The solution you're proposing has the same downsides as 3) - we risk
having to tweak things either way. The difference is that in the case of
3) the tweaking is adding entries to the whitelist, whereas tweaking
your solution has more chance of introducing further unwanted
regressions because you'd be tweaking an algorithm, an algorithm that
relies on the internal implementation of the variable storage code.

> Dealing with firmware is hard. This fixes (1) without leaving us with
> (2), which seems like a net win.

I'm not convinced that implementing 3) would inevitably lead to 2),
provided that we apply a bit of common sense when adding entries. I'm
not advocating some kind of flag day where we add umpteen machines to
the whitelist.

For reference, I just pushed two patches to the 'whitelist' branch at,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

which should hopefully illustrate the kind of thing that I'm talking about.

-- 
Matt Fleming, Intel Open Source Technology Center
