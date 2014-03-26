From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 2/5] efi: Export arch_tables variable
Date: Wed, 26 Mar 2014 14:17:53 +0000
Message-ID: <5332EFA102000078000026CD@nat28.tlf.novell.com>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
 <1395781076-12000-3-git-send-email-daniel.kiper@oracle.com>
 <5332E25F020000780000255A@nat28.tlf.novell.com>
 <20140326140800.GP3454@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140326140800.GP3454-fJNZiO034lp9pOct4yEdx/3oZC3j2Omk@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

>>> On 26.03.14 at 15:08, <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, Mar 26, 2014 at 01:21:19PM +0000, Jan Beulich wrote:
>> >>> On 25.03.14 at 21:57, <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>> > Export arch_tables variable. Xen init function calls efi_config_init()
>> > which takes it as an argument.
>> >
>> > Additionally, put __initdata in place suggested by include/linux/init.h.
>>
>> Which isn't necessarily the most appropriate place.
> 
> Why? If comments in include/linux/init.h are not valid they should be 
> changed.

Because they can't go there uniformly: While on function declarations
you can put them there, on function definitions they need to come
before the function name. And placing attributes between type and
name does - iirc - work consistently for everything.

>> > --- a/include/linux/efi.h
>> > +++ b/include/linux/efi.h
>> > @@ -583,6 +583,8 @@ extern struct efi {
>> >  	struct efi_memory_map *memmap;
>> >  } efi;
>> >
>> > +extern efi_config_table_type_t arch_tables[] __initdata;
>>
>> And section placement annotations are bogus on declarations.
> 
> Hmmm... I am not sure which approach is better. I saw that
> in many places declarations have annotations. Could you
> point me some docs which states (and explains) that this
> is wrong idea.

Just use common sense: Attributes that are of concern to the
caller should go on the declaration. Attributes that only affect
code generation for the function/object in question should go on
the definition.

Jan
