From: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 10/15] acpi: Ignore acpi_rsdp kernel parameter in a
 secure boot environment
Date: Wed, 20 Feb 2013 08:39:24 -0500
Message-ID: <20130220133924.GF362@hansolo.jdub.homelinux.org>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
 <1359391359-25783-11-git-send-email-matthew.garrett@nebula.com>
 <CABqxG0cJGp7UEREvMW49QA0BfDXPsyEbAuMMLZwcHPdUAKT+Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CABqxG0cJGp7UEREvMW49QA0BfDXPsyEbAuMMLZwcHPdUAKT+Dw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <hidave.darkstar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Feb 17, 2013 at 05:00:23PM +0800, Dave Young wrote:
> On Tue, Jan 29, 2013 at 12:42 AM, Matthew Garrett
> <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:
> > From: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> > This option allows userspace to pass the RSDP address to the kernel.  This
> > could potentially be used to circumvent the secure boot trust model.
> > We ignore the setting if we don't have the CAP_COMPROMISE_KERNEL capability.
> >
> > Signed-off-by: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/acpi/osl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> > index bd22f86..88251d2 100644
> > --- a/drivers/acpi/osl.c
> > +++ b/drivers/acpi/osl.c
> > @@ -246,7 +246,7 @@ early_param("acpi_rsdp", setup_acpi_rsdp);
> >  acpi_physical_address __init acpi_os_get_root_pointer(void)
> >  {
> >  #ifdef CONFIG_KEXEC
> > -       if (acpi_rsdp)
> > +       if (acpi_rsdp && capable(CAP_COMPROMISE_KERNEL))
> 
> 
> This caused an issue in a kdump test even without secure boot enabled.
> Looks like security subsystem init is not initialized yet at this
> point.
> 
> See redhat bug 906225:
> https://bugzilla.redhat.com/show_bug.cgi?id=906225

I've fixed this in a newer revision of the patch.  Basically we can't
rely on capable() working at this point because security_init hasn't
been called yet.  Sigh.

Despite the desire to not sprinkle if (!secure_boot) checks all over,
I'm thinking less and less that using a CAP is going to work.  Maybe
I'll come up with some kind of secure_kernel() function that can be set
per-arch or something and use that instead.  At least that would have
the semantics we're looking for without breaking in various places or
causing unintended side-effects in userspace.

josh
