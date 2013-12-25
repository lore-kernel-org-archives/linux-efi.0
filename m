From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 00/12] kexec kernel efi runtime support
Date: Wed, 25 Dec 2013 11:09:01 +0800
Message-ID: <20131225030901.GA6333@dhcp-16-126.nay.redhat.com>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
 <20131221173515.GE29501@console-pimps.org>
 <1387747621.1848.2.camel@misato.fc.hp.com>
 <20131223073641.GA28919@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131223073641.GA28919-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org" <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org" <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org" <horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org>, "kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org" <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/23/13 at 07:36am, Matt Fleming wrote:
> On Sun, 22 Dec, at 02:27:01PM, Toshi Kani wrote:
> > 
> > The kexec branch is missing the following change, which is required for
> > fast reboot with multi-cpus.
> > 
> >    commit 279f1df915c3a6ed3075d98a849705bf53851f99
> >    Author: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >    Date:   Tue Nov 26 10:25:28 2013 +0800
> > 
> >        kexec: migrate to reboot cpu
> > 
> > With this change added, I confirmed that the branch kernel works fine.
>  
> I can't find that commit in Linus' tree. Where is it from?

Previously it was in Andrew's mm tree, currently it's below commit in linus tree:

commit c97102ba96324da330078ad8619ba4dfe840dbe3
Author: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 18 17:08:31 2013 -0800

    kexec: migrate to reboot cpu
    
    Commit 1b3a5d02ee07 ("reboot: move arch/x86 reboot= handling to generic
    kernel") moved reboot= handling to generic code.  In the process it also
    removed the code in native_machine_shutdown() which are moving reboot
    process to reboot_cpu/cpu0.
    
    I guess that thought must have been that all reboot paths are calling
    migrate_to_reboot_cpu(), so we don't need this special handling.  But
    kexec reboot path (kernel_kexec()) is not calling
    migrate_to_reboot_cpu() so above change broke kexec.  Now reboot can
    happen on non-boot cpu and when INIT is sent in second kerneo to bring
    up BP, it brings down the machine.
    
    So start calling migrate_to_reboot_cpu() in kexec reboot path to avoid
    this problem.
    
    Bisected by WANG Chao.
    
    Reported-by: Matthew Whitehead <mwhitehe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Reported-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Tested-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Tested-by: WANG Chao <chaowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Acked-by: H. Peter Anvin <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
    Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
    Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
    Signed-off-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
