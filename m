From: jerry.hoemann-VXdhtT5mjnY@public.gmane.org
Subject: Re: [RFC v2 0/2] Early use of boot service memory
Date: Thu, 21 Nov 2013 18:05:15 -0700
Message-ID: <20131122010515.GG1106@anatevka.fc.hp.com>
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
 <20131121230744.GA31592@srcf.ucam.org>
 <20131121233104.GF1106@anatevka.fc.hp.com>
 <20131121233831.GB32121@srcf.ucam.org>
Reply-To: jerry.hoemann-VXdhtT5mjnY@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131121233831.GB32121-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bp-l3A5Bk7waGM@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mingo.kernel.org-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 21, 2013 at 11:38:31PM +0000, Matthew Garrett wrote:
> On Thu, Nov 21, 2013 at 04:31:04PM -0700, jerry.hoemann-VXdhtT5mjnY@public.gmane.org wrote:
> 
> > I tried this back on 3.11 kernel and reserve_crashkernel after free of
> > boot services failed.  I will admit to not digging in too deeply as to
> > why it failed.
> 
> Hm. If the problem is fragmentation, then yeah, I can imagine this 
> causing problems. In that case we could take a two-pass approach - find 
> a gap that *will* be big enough, reserve everything that isn't currently 
> reserved, and then reserve the rest after ExitBootServices()?


Matthew,

Did you really mean EnterVirtualMode (not ExitBootServices?)

One of the difficulties i'm having is that distros and stable releases
want fixes upstream that they just back port.

ExitBootServices is called in different locations dependent upon
release.  The current use is to have linux do ExitBootServices, whereas
EBS used to be done in the boot loaders.  So, i'm concerned that 
such an approach might require legacy boot loader changes.  That would
be a difficult sell.

But,  splitting up what is done where may work.

While the crash kernel space is reserved early in boot,  i don't believe
it is written to until much later (kexec_load??)  So, i don't believe that
we'd loose any boot code/data that might be missed by firmware that tried
to access after ExitBootService.

In one of your earlier emails you mentioned the issue is that linux makes
regions NX.  That would cause problems if FW tried to execute a region
we just reserved.  Unfortunately, i'm not seeing where the kernel is
doing this for crash kernel memory.  Assuming it is making it NX, can
we defer that part?  Or if its not, do we have a problem w/ crash kernel
reservation at all?

Interesting questions, but as I don't have access to a system that has
the firmware defects encountered when efi_reserve_boot_services, it makes
it difficult to test that i don't break them.  Hence, the appealing nature
of quirks.  Don't have to worry about breaking other platforms as they
continue to operate same as before.

I can understand the desire some have to not introducing quirks.
They can be like potato chips.  You can't have just one.  :)  :)



-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann-VXdhtT5mjnY@public.gmane.org
----------------------------------------------------------------------------
