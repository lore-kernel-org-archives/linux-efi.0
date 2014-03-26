From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 3/5] x86: Call efi_memblock_x86_reserve_range()
 on native EFI platform only
Date: Wed, 26 Mar 2014 13:39:42 +0000
Message-ID: <5332E6AE02000078000025F0@nat28.tlf.novell.com>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
 <1395781076-12000-4-git-send-email-daniel.kiper@oracle.com>
 <20140326130009.GB24856@console-pimps.org>
 <5332E2B9020000780000255D@nat28.tlf.novell.com>
 <20140326133119.GD24856@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140326133119.GD24856-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

>>> On 26.03.14 at 14:31, <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Wed, 26 Mar, at 01:22:49PM, Jan Beulich wrote:
>> >>> On 26.03.14 at 14:00, <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
>> > 
>> > This could do with a little bit more explanation. Why is it not
>> > necessary to mark the EFI memory map that was passed to the kernel as
>> > reserved in memblock?
>> 
>> Because that's in memory Dom0 doesn't even see: The EFI memory
>> map is visible to the hypervisor only.
> 
> So where does boot_params.efi_info.efi_memmap point?
> 
> If nowhere (i.e. it's NULL) that's no problem because memblock_reserve()
> handles zero size regions just fine.

That's a question to Daniel - in our implementation (with a separate
Xen kernel that can't run on bare hardware) boot_params as a whole
simply doesn't exist.

Jan
