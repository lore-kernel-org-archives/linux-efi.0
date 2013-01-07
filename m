From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH] Fix efifb initialisation when the only GOP device
 implements ConOut.
Date: Mon, 7 Jan 2013 19:16:49 +0000
Message-ID: <20130107191648.GA2229@srcf.ucam.org>
References: <1357431222.9270.73.camel@shinybook.infradead.org>
 <1357524250.9270.86.camel@shinybook.infradead.org>
 <1357578923.8203.72.camel@mfleming-mobl1.ger.corp.intel.com>
 <1357581080.2844.17.camel@shinybook.infradead.org>
 <20130107175846.GA385@srcf.ucam.org>
 <1357583795.2844.18.camel@shinybook.infradead.org>
 <20130107184320.GA1400@srcf.ucam.org>
 <1357585971.2844.22.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1357585971.2844.22.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 07, 2013 at 07:12:51PM +0000, David Woodhouse wrote:
> On Mon, 2013-01-07 at 18:43 +0000, Matthew Garrett wrote:
> > The kernel does, the EFI boot stub doesn't. There's probably an argument 
> > for having it fail in that case, but it wouldn't even be able to print 
> > an error message without some gymnastics.
> 
> Printing an error message is simple enough from assembler; you just need
> to call sys_table->con_out->output_string.

I don't think that's guaranteed to do something unless we've set a 
console mode first, but sure, that ought to be an improvement.

>  "Sorry, this kernel cannot boot in " (32|64) "-bit mode this way. Your
> bootloader should have ignored the shiny new EFI handover protocol and
> booted it the old way. It would have worked then, albeit without EFI
> runtime services. Which you probably wouldn't have missed."

"(32|64) bit kernels cannot be booted via the EFI handover 
protocol on (64|32) bit firmware"?

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
