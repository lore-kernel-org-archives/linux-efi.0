From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Correct a tiny mistake in code comment
Date: Wed, 8 Mar 2017 17:45:05 +0800
Message-ID: <20170308094505.GC6570@x1>
References: <1488959258-4731-1-git-send-email-bhe@redhat.com>
 <20170308081812.GA12600@dhcp-128-65.nay.redhat.com>
 <CACi5LpOjxiiCEvdOHGxHj_c+G-W3HKHr8EgOURpZ-cb5XqQnNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACi5LpOjxiiCEvdOHGxHj_c+G-W3HKHr8EgOURpZ-cb5XqQnNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bp-l3A5Bk7waGM@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 03/08/17 at 02:30pm, Bhupesh Sharma wrote:
> Hi Dave,
> 
> On Wed, Mar 8, 2017 at 1:48 PM, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On 03/08/17 at 03:47pm, Baoquan He wrote:
> >> - * We allocate runtime services regions bottom-up, starting from -4G, i.e.
> >> + * We allocate runtime services regions top-down, starting from -4G, i.e.
> >
> > Baoquan, I think original bottom-up is right, it is just considering
> > -68G as up, see the x86_64 mm.txt. We regard vmalloc as higher address
> > although from mathematics view it is lower then positive addresses.
> 
> I think you have a valid point, but I think the -4G convention is
> probably too confusing to read and may lead to issues when we use this
> for future feature addition as well. It would be more useful to use
> the macros similar to the MODULES_{} addresses we use currently in
> 'arch/x86/include/asm/pgtable_64_types.h':
> 
> #define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
> #define MODULES_END      _AC(0xffffffffff000000, UL)
> #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
> 
> May be we can use the following convention for the EFI_VA_{} addresses
> as per 'http://lxr.free-electrons.com/source/Documentation/x86/x86_64/mm.txt#L19':
> 
> #define EFI_VA_START    _AC(0xfffffffeffffffff, UL)
> #define EFI_VA_END    _AC(0xffffffef00000000, UL)

Isn't it like this:

#define EFI_VA_START    _AC(0xffffffff00000000, UL)
#define EFI_VA_END    _AC(0xffffffef00000000, UL)

Just make them be equal to value which computer stores -4G and -68G?

You can see in arch/x86/platform/efi/efi_64.c, it's using efi_va minus
size directly, here size should be 4K, page aligned. 

	efi_va -= size;

Above formula has considered the open interval attribute of
EFI_VA_START. Making EFI_VA_START be 0xfffffffeffffffff could be wrong.

Right?
