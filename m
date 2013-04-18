From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Date: Thu, 18 Apr 2013 13:13:35 -0700
Message-ID: <517053EF.2030900@zytor.com>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org> <20130418163325.GA6884@leaf> <5170216C.9020300@zytor.com> <20130418164457.GB6884@leaf> <51704FA8.7060801@console-pimps.org> <1366315083.13667.19.camel@x230.lan> <51705366.8070001@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51705366.8070001-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <darren.hart-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Bryan O'Donoghue <bryan.odonoghue.lkml-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 04/18/2013 01:11 PM, Darren Hart wrote:
>>
>> I would expect that if there are any 32-bit UEFI systems that ship with
>> BGRT support (and Darren makes it sound like that's a possibility),
>> there's a realistic chance of the BGRT ending up allocated above the
>> highmem barrier.
> 
> I can certainly ensure we sit below that barrier on the MinnowBoard. We
> can also speak with the Intel UEFI firmware development teams to see
> about making that a requirement. I don't know if we'll be successful,
> but Matt, Peter, and I have recently coaxed some changes of that nature in.
> 

No, that is the wrong approach.  The HIGHMEM barrier is a Linux kernel
construct and isn't even guaranteed to be the same from one boot *of the
same kernel* to another.  The value 896M is merely the default, but it
can be affected by both compile time and command line options.

	-hpa
