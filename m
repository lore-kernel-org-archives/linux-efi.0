From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH] efi: Work around ia64 build problem with ESRT driver.
Date: Fri, 5 Jun 2015 12:23:13 -0700
Message-ID: <20150605192313.GA20232@roeck-us.net>
References: <20150605191329.GA23480@redhat.com>
 <1433531694-24439-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433531694-24439-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jun 05, 2015 at 03:14:54PM -0400, Peter Jones wrote:
> So, I'm told this problem exists in the world:
> ----------------------------------------------
> Subject: Build error in -next due to 'efi: Add esrt support'
> 
> Building ia64:defconfig ... failed
> --------------
> Error log:
> 
> drivers/firmware/efi/esrt.c:28:31: fatal error: asm/early_ioremap.h: No
> such file or directory
> ----------------------------------------------
> 
> I'm not really sure how it's okay that we have things in asm-generic on
> some platforms but not others - is having it the same everywhere not the
> whole point of asm-generic?
> 
> That said, ia64 doesn't have early-ioremap.h .  So instead, since it's
> difficult to imagine new IA64 machines with UEFI 2.5, just don't build
> this code there.
> 
> To me this looks like a workaround - doing something like:
> 
> generic-y += early_ioremap.h
> 
> in arch/ia64/include/asm/Kbuild would appear to be more correct, but
> ia64 has its own early_memremap() decl in arch/ia64/include/asm/io.h ,
> and it's a macro.  So adding the above /and/ requiring that asm/io.h be
> included /after/ asm/early_ioremap.h in all cases would fix it, but
> that's pretty ugly as well.  Since I'm not going to spend the rest of my
> life rectifying ia64 headers vs "generic" headers that aren't generic,
> it's much simpler to just not build there.
> 
> Note that I've only actually tried to build this patch on x86_64, but
> esrt.o still gets built there, and that would seem to demonstrate that
> the conditional building is working correctly at all the places the code
> built before.  I no longer have any ia64 machines handy to test that the
> exclusion actually works there.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The ia64:defconfig build passes with this patch, so

Reviewed-by: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
(Compile-)Tested-by: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>

Guenter
