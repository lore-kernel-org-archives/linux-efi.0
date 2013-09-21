From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86 efi: bugfix interrupt disabling sequence
Date: Sat, 21 Sep 2013 16:41:27 +0100
Message-ID: <20130921154127.GD21381@console-pimps.org>
References: <1379525333-4373-1-git-send-email-bemk@redhat.com>
 <20130920152859.GC21381@console-pimps.org>
 <1379708486.12705.131.camel@dhcp-128-237.ams.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1379708486.12705.131.camel-0VdLhd/A9PkhetGgFr3ssPXAX3CI6PSWQQ4Iyu8u01E@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Kuivenhoven <bemk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 20 Sep, at 10:21:26PM, Bart Kuivenhoven wrote:
> Well, isn't it so, that the kernel expects a setup in which interrupts
> are disabled before the decompressed image is loaded?
 
Yes, but I wasn't advocating leaving interrupts enabled, rather, because
interrupts are disabled we don't need to build an empty IDT, which will
never be used.

> What we can do is remove the lidt instruction and IDT pointer, but that
> still doesn't change anything with regards to the kernels expectations.
> 
> And no, I haven't witnessed a triple fault, this is purely theoretical,
> with a very slim chance of it actually happening. That does not mean
> that it can't happen though.
 
Right, but the answer to my question will dictate how aggressively we
apply your patch - whether it goes in the 'urgent' queue to be pushed
quickly or whether we give it more testing. Patches that fix serious
issues that users are hitting tend to make it into the next release. For
patches that fix theoretical bugs, we'll usually put it through more
strenuous testing first.

-- 
Matt Fleming, Intel Open Source Technology Center
