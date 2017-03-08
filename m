From: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Correct a tiny mistake in code comment
Date: Thu, 9 Mar 2017 01:35:00 +0530
Message-ID: <CACi5LpOXgCfysVdSnaCW=VPGp4VVJm9EKssvGK0T4wZ6ew7cvw@mail.gmail.com>
References: <1488959258-4731-1-git-send-email-bhe@redhat.com>
 <20170308081812.GA12600@dhcp-128-65.nay.redhat.com> <CACi5LpOjxiiCEvdOHGxHj_c+G-W3HKHr8EgOURpZ-cb5XqQnNQ@mail.gmail.com>
 <20170308090955.GB6570@x1> <20170308093555.yrhygjxx4mu562lp@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170308093555.yrhygjxx4mu562lp-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 8, 2017 at 3:05 PM, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
> On Wed, Mar 08, 2017 at 05:09:55PM +0800, Baoquan He wrote:
>> Yes, it looks better. I can repost with this change. Thanks.
>
> No it doesn't:
>
> #define EFI_VA_START     ( -4 * (_AC(1, UL) << 30))
> #define EFI_VA_END       (-68 * (_AC(1, UL) << 30))
>
> That's -4G (the shift by 30) and -68G, respectively.
>
>> > #define EFI_VA_START    _AC(0xfffffffeffffffff, UL)
>> > #define EFI_VA_END    _AC(0xffffffef00000000, UL)
>
> That is something which I need to type into a calculator first.

Right, my point was that this -4G convention stands out, as compared
to the rest of the addressing convention used throughout
'arch/x86/include/asm/pgtable_64_types.h'.

For e.g.:

#define __VMALLOC_BASE    _AC(0xffffc90000000000, UL)
#define __VMEMMAP_BASE    _AC(0xffffea0000000000, UL)
..
#define MODULES_END      _AC(0xffffffffff000000, UL)
..
and so on.

Also it seems inconsistent to the convention used in
'Documentation/x86/x86_64/mm.txt'

As you noted in one of your other comments in this thread, this causes
a confusion as to whether the EFI_VA_END and EFI_VA_START macros need
to be swapped or the comments elsewhere in the x86 code which use
these MACROS are incorrect.

However, I think it is more a matter of code readability and each of
these styles have their own advantages.

I would be happy to cook up a patch to have uniformity in the
addressing conventions used across pgtable_64_types.h (if it is
required at all), but it would be a different topic and not related to
this patch.

Regards,
Bhupesh
