From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi-bgrt: Add error handling; inform the user when
 ignoring the BGRT
Date: Fri, 1 Aug 2014 10:19:49 +0100
Message-ID: <20140801091949.GD15082@console-pimps.org>
References: <20140730192331.GA23730@jtriplet-mobl1>
 <20140731103110.GC15082@console-pimps.org>
 <20140731161133.GA12663@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140731161133.GA12663@cloud>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Srihari Vijayaraghavan <linux.bug.reporting-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Including akpm, the __GFP_NOWARN police)

On Thu, 31 Jul, at 09:11:33AM, Josh Triplett wrote:
> 
> I started to add an explicit limit, but any reasonable limit (large
> enough for modern screens) would be large enough that there's still a
> non-trivial possibility of allocation failure.  And I think it makes
> sense for BGRT image allocation to be non-fatal and minimally noisy
> (just a single-line error, not a scary-looking allocation warning),
> considering the highly optional and cosmetic nature of BGRT.  So, I
> believe __GFP_NOWARN makes sense.

Yes, I agree that we don't want to trigger the page allocator warning,
but I don't agree that passing __GFP_NOWARN is OK, which is why I'm
advocating some size limit checks.

We need to distinguish between "Your BGRT image size is huge, and
assumed buggy" and "Your BGRT looks valid, but we ran out of memory".

We've already got enough problems with the EFI code because we silently
paper over bugs, and using the page allocator's failure path as a way to
check for buggy BGRT images just doesn't make any sense to me at all.

If we get the limit wrong, it's not the end of the world, we can change
it later, but it's a safe bet that if the firmware engineers start
seeing "BGRT is buggy" in the kernel log they're going to start a
dialogue with us.

Original patch,

  https://lkml.org/lkml/2014/7/30/543

-- 
Matt Fleming, Intel Open Source Technology Center
