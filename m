From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] x86/mm/KASLR: EFI region is mistakenly included into
 KASLR VA space for randomization
Date: Fri, 24 Mar 2017 16:46:09 +0800
Message-ID: <20170324084609.GA6807@dhcp-128-65.nay.redhat.com>
References: <1490331592-31860-1-git-send-email-bhe@redhat.com>
 <20170324080833.GA15200@gmail.com>
 <20170324083451.GC30442@x1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170324083451.GC30442@x1>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/24/17 at 04:34pm, Baoquan He wrote:
> On 03/24/17 at 09:08am, Ingo Molnar wrote:
> > > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #4.8+
> > > Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Acked-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Reviewed-by: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Acked-by: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> > > Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> > > Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> > > Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Cc: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> > > Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> > > Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> > > Cc: Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>
> > > Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Cc: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > So I applied this kexec fix and extended the changelog to clearly show why this 
> > fix matters in practice.
> 
> I thought it only impacts kexec, but Dave thought it will impact 1st
> kenrel either.

Yes, I think no need to mention kexec, it is a general issue.

First, the space is reserved for EFI, so kernel should not use it for
kaslr. Second, EFI page tables sync the low kernel page tables into its
own page tables, if others use this space for non-EFI then those part
will be missing.

arch/x86/platform/efi/efi_64.c
efi_sync_low_kernel_mappings() is syncing kernel page tables to efi's.
>From the function comment below:
Add low kernel mappings for passing arguments to EFI functions.

Suppose some arguments use kaslr randomized address which is within efi
ranges then we will hit bugs. But we do not see actual bug reports in
real world yet. This is found during patch review.

Anyway, since this area is EFI reserved, no reason to add it to kaslr
pool.

> > 
> > Also, to make sure I understood it correctly: these addresses are all dynamic on 
> > 64-bit kernels, i.e. we are establishing and then tearing down these page tables 
> > around EFI calls, and they are 'normally' not present at all, right?
> 
> The EFI region is reserved for EFI runtime services virtual mapping, the
> original purpose is to preserve this region so that they can be reused
> by kexec-ed kernel. This was introduced by Boris in commit d2f7cbe7b26a7
> ("x86/efi: Runtime services virtual mapping").
> 
> So it will be establishing and stay there. According to Dave's telling,
> efi will still fetch efi variables or time/date by runtime service by
> switching the efi pgd and entering into efi mode. And then switch back
> to normal OS. Not sure if I am right for efi part in 1st kernel. For 2nd
> kernel, if want to reuse the them, the efi region has to be kept.
> 
> Thanks
> Baoquan

Thanks
Dave
