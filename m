From: Lenny Szubowicz <lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 08/10] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Date: Thu, 29 Aug 2013 14:14:55 -0400 (EDT)
Message-ID: <1776247498.9768326.1377800095494.JavaMail.root@redhat.com>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com> <1376933171-9854-9-git-send-email-matthew.garrett@nebula.com> <410604531.9664777.1377791856786.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <410604531.9664777.1377791856786.JavaMail.root-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



----- Original Message -----
> From: "Lenny Szubowicz" <lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: "Matthew Garrett" <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
> Sent: Thursday, August 29, 2013 11:57:36 AM
> Subject: Re: [PATCH V2 08/10] kexec: Disable at runtime if the kernel enforces module loading restrictions
> 
> 
> 
> ----- Original Message -----
> > From: "Matthew Garrett" <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> > To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org,
> > "Matthew Garrett"
> > <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> > Sent: Monday, August 19, 2013 1:26:09 PM
> > Subject: [PATCH V2 08/10] kexec: Disable at runtime if the kernel enforces
> > module loading restrictions
> > 
> > kexec permits the loading and execution of arbitrary code in ring 0, which
> > is something that module signing enforcement is meant to prevent. It makes
> > sense to disable kexec in this situation.
> > 
> > Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  kernel/kexec.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/kernel/kexec.c b/kernel/kexec.c
> > index 59f7b55..1a7690f 100644
> > --- a/kernel/kexec.c
> > +++ b/kernel/kexec.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/vmalloc.h>
> >  #include <linux/swap.h>
> >  #include <linux/syscore_ops.h>
> > +#include <linux/module.h>
> >  
> >  #include <asm/page.h>
> >  #include <asm/uaccess.h>
> > @@ -1645,6 +1646,9 @@ int kernel_kexec(void)
> >  		goto Unlock;
> >  	}
> >  
> > +	if (secure_modules())
> > +		return -EPERM;
> > +
> >  #ifdef CONFIG_KEXEC_JUMP
> >  	if (kexec_image->preserve_context) {
> >  		lock_system_sleep();
> > --
> > 1.8.3.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
> 
> Shouldn't that be:
> 
> +	if (secure_modules()) {
> +		error = -EPERM;
> +		goto Unlock;
> +	}
> 
> -Lenny.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Also, in earlier incarnations you disallowed kexec load in secure mode.
But now you allow the load. You then disallow the transfer of control
to the loaded code via kernel_kexec in secure mode.

Even if there might be no risk by having untrusted code remain loaded, why
not prevent it up front?

                            -Lenny.
