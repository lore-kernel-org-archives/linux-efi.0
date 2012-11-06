From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH] x86/EFI: additional checks in efi_bgrt_init()
Date: Tue, 6 Nov 2012 04:55:02 -0800
Message-ID: <20121106125502.GA29931@leaf>
References: <5097E8C102000078000A661B@nat28.tlf.novell.com>
 <20121105183751.GA9031@jtriplet-mobl1>
 <20121105184346.GA13508@srcf.ucam.org>
 <20121105190047.GA9295@jtriplet-mobl1>
 <5098DEF202000078000A695F@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5098DEF202000078000A695F-ce6RLXgGx+vWGUEhTRrCg1aTQe2KTcn/@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, mingo-X9Un+BFzKDI@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 06, 2012 at 08:57:06AM +0000, Jan Beulich wrote:
> The question here is how to properly invalidate that data then:
> So far I was assuming that clearing the valid bit would be the way
> to go, as the specification says nothing on e.g. the image address
> being zero having any specific meaning. I need to do that in Xen,
> at least for the time being, as I'm not inclined to postpone
> indefinitely the use of boot services memory for normal memory
> allocations (which we would have to do if we wanted Dom0 to
> be able to access the image pointed to here).

This doesn't postpone the use of boot services memory indefinitely; the
BGRT driver copies the image out, and the kernel then frees boot
services memory.  That does introduce a delay in the use of boot
services memory, but not an indefinite one.

> I was quite bad a design decision to allow (and even suggest)
> the image to live in boot services memory - one can't generally
> expect the ACPI parser to become available in an OS before
> setting up memory allocation. To Linux this already has turned
> out to be a problem, on Xen dealing with this would turn out
> even more cumbersome.

What problems has this caused?

- Josh Triplett
