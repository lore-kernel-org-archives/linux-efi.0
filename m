From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] fix setup_efi_pci()
Date: Thu, 17 Jan 2013 15:40:16 +0000
Message-ID: <50F8297002000078000B6E64@nat28.tlf.novell.com>
References: <50F3D70402000078000B530E@nat28.tlf.novell.com>
 <1358425782.8203.413.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358425782.8203.413.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

>>> On 17.01.13 at 13:29, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Mon, 2013-01-14 at 08:59 +0000, Jan Beulich wrote:
>> This fixes three issues:
>> - missing parentheses around a flag test
>> - wrong memory type used for allocation intended to persist post-boot
>> - four similar build warnings on 32-bit (casts between different size
>>   pointers and integers)
>> 
>> Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
>> 
>> ---
>>  arch/x86/boot/compressed/eboot.c |   12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> Jan, could you resubmit items 2 and 3 as separate patches please?

Sure, will do (probably only after rc4 though).

> Item 1 on your list has already been fixed in Linus' tree,

Yet I know I checked the tree right before sending...

Jan

> commit 886d751a2ea99a160f2d0a472231566d9cb0cf58
> Author: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Date:   Thu Dec 20 14:11:33 2012 -0500
> 
>     x86, efi: correct precedence of operators in setup_efi_pci
>     
>     With the current code, the condition in the if() doesn't make much sense 
> due
>     precedence of operators.
>     
>     Signed-off-by: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>     Link: 
> http://lkml.kernel.org/r/1356030701-16284-25-git-send-email-sasha.levi 
>     Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>     Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     Cc: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>     Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>     Signed-off-by: H. Peter Anvin <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center
