From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH] x86/EFI: additional checks in efi_bgrt_init()
Date: Mon, 5 Nov 2012 11:00:48 -0800
Message-ID: <20121105190047.GA9295@jtriplet-mobl1>
References: <5097E8C102000078000A661B@nat28.tlf.novell.com>
 <20121105183751.GA9031@jtriplet-mobl1>
 <20121105184346.GA13508@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121105184346.GA13508-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, mingo-X9Un+BFzKDI@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 05, 2012 at 06:43:46PM +0000, Matthew Garrett wrote:
> On Mon, Nov 05, 2012 at 10:37:52AM -0800, Josh Triplett wrote:
> > On Mon, Nov 05, 2012 at 03:26:41PM +0000, Jan Beulich wrote:
> > > Header length should be validated for all ACPI tables before accessing
> > > any non-header field.
> > > 
> > > The valid flags should also be check, as with it clear there's no point
> > > in trying to go through the rest of the code (and there's no guarantee
> > > that the other table contents are valid/consistent in that case).
> > > 
> > > Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
> > 
> > The length check seems reasonable.  However, Matthew Garrett (already
> > CCed) previously suggested to me that this code should not check the
> > "valid" bit, and should instead present the information to userspace if
> > otherwise valid (such as having image_address != 0).  Matthew?
> 
> Yeah, my interpretation of the spec is that "valid" indicates whether or 
> not the contents represent what's currently on the screen, not whether 
> or not the contents can be interpreted for other reasons.

Given that, in the absence of a real BIOS that interprets the spec
differently than that, it sounds like we should drop the check for the
valid bit.

Jan, have you seen a real BIOS which disagrees with the above
interpretation?  If not, can you resubmit the patch with just the length
check?

- Josh Triplett
