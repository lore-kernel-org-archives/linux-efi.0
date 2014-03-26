From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v3 5/5] xen: Put EFI machinery in place
Date: Wed, 26 Mar 2014 13:53:46 +0000
Message-ID: <20140326135346.GF24856@console-pimps.org>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
 <1395781076-12000-6-git-send-email-daniel.kiper@oracle.com>
 <20140326131214.GC24856@console-pimps.org>
 <5332E4A802000078000025B6@nat28.tlf.novell.com>
 <20140326134617.GE24856@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140326134617.GE24856-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Tang Liang <liang.tang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 26 Mar, at 01:46:17PM, Matt Fleming wrote:
> On Wed, 26 Mar, at 01:31:04PM, Jan Beulich wrote:
> > >>> On 26.03.14 at 14:12, <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> > > 
> > > Is there a reason that you can't just populate an efi_system_table_t
> > > object, which could be used by efi_init(), so that we can save you the
> > > trouble of duplicating all of this code?
> > 
> > Would the generic function cope with all other fields being NULL (or
> > equivalent)?
>  
> I've no idea, but it shouldn't be difficult to make that work. And by
> making it work in the generic code

Guh, hit Send too soon... sorry.

What I was trying to say was that there's a real benefit to keeping all
these idiosyncrasies, such as "This field may be NULL on some platforms,
or this field, or that", in one place, because it gives you an immediate
view of what platforms Linux supports and what assumptions we can make.

It also helps immensely when the time comes to do some refactoring -
because it's all contained in one central place all the use cases are in
front of you.

Obviously this approach doesn't work for super-platform specific stuff,
but it's not clear to me that these patches fall into that category.

-- 
Matt Fleming, Intel Open Source Technology Center
