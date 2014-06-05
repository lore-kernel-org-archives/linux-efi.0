From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Only pass mapped RAM regions to free_bootmem_late()
Date: Thu, 5 Jun 2014 19:07:50 +0100
Message-ID: <CADknwL7t3phPTnr6YFUduVVJ_=qaN3uWexhQ3LWj71U5Mh-zjA@mail.gmail.com>
References: <1401974854-7716-1-git-send-email-matt@console-pimps.org>
	<20140605160102.3c58481e@www.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140605160102.3c58481e-+KEw/ACL1GZE/aiTQr5FLb0Ud+EcFu5g@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 5 June 2014 16:01, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org> wrote:
> On Thu,  5 Jun 2014 14:27:34 +0100
> Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
>
>> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> free_bootmem_late() expects to only be passed RAM regions that the
>> kernel can access, and that have a corresponding 'struct page'. It's
>> possible for regions in the EFI memory map to reside in address ranges
>> for which pfn_to_page() doesn't work, for instance when running on an
>> i386 system with CONFIG_HIGHMEM=n.
>>
>> This is in fact the case for one of Alan's machines where some of the
>> EFI boot services pages live in highmem, and running a kernel without
>> CONFIG_HIGHMEM enabled results in the following oops,
>>
>>  BUG: unable to handle kernel paging request at f7f1f080
>>  IP: [<c17fba96>] __free_pages_bootmem+0x5a/0xb8
>>  *pdpt = 0000000001887001 *pde = 0000000001984067 *pte = 000000000 0000000
>>  Oops: 0002 [#1] SMP
>
> No improvement, and the if case is never true 8(

Argh, dammit. OK, back to the drawing board. Thanks for testing.
