From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 RFC 00/16] EFI stub for ARM
Date: Tue, 13 Aug 2013 11:46:24 -0400
Message-ID: <1376408784.27484.26.camel@t520.redhat.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	 <1376316160.32237.17.camel@t520.redhat.com>
	 <CAFECyb93p3Wct9DWYAzhU2cU1J=F6sN=67Vw3ofXFa8wW0EKrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFECyb93p3Wct9DWYAzhU2cU1J=F6sN=67Vw3ofXFa8wW0EKrw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave Martin <dave.martin-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-08-12 at 18:13 -0700, Roy Franz wrote:
> On Mon, Aug 12, 2013 at 7:02 AM, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> >> * Change FDT memory allocation to retry with a larger allocation if
> >>   first educated guess is inadequate.
> >
> > With this change, it looks like you no longer free the original cmdline
> > and fdt memory. The current flow looks like:
> >
> >   retry:
> >      allocate_memory_for_expanded_fdt
> >      get_memory_map
> >      if (update_fdt() fails) {
> >         free new_fdt and memory_map
> >         goto retry
> >      }
> >
> > So, this keeps the original fdt around and uses it as a starting point
> > for newly allocated expanded fdt. You don't know if the new fdt is big
> > enough until update_fdt() succeeds. But at that point, you already wrote
> > the efi-runtime-mmap property with the memory_map still having the
> > original cmdline and fdt in it.
> >
> > I think you should be able to have an expand_fdt() function which bumps
> > the fdt size and uses the current fdt as the starting point instead of
> > the original fdt. That way you can free the original fdt on the first
> > iteration and free the original cmdline as soon as it is successfully
> > written. Then the last thing you do if get the memory_map and write it.
> >
> > --Mark
> 
> Hi Mark,
> 
> I think this will work with the current FDT fields that are being set
> by the stub.  In earlier
> versions, I was also updating the reserved memory map using
> fdt_add_mem_rsv(), so
> iteratively updating the device tree wouldn't work. The reserved
> regions would change,
> and so the repeated updates would cause there to be repeated and
> incorrect reserved regions.
> I'm inclined to leave it as is, which should correctly update the
> device tree even if methods like
> fdt_add_mem_rsv() are used, with the tradeoff being there will be a
> few more memory regions
> for the kernel to free when it processes the EFI memory map.  The
> kernel already needs to process
> the EFI memory map to free the buffers use to load the kernel and
> initrd, so these buffers will get freed, just not
> by the stub.
> 

Got it. Thanks for the explanation.
