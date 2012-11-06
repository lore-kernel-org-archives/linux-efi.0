From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] x86/EFI: additional checks in efi_bgrt_init()
Date: Tue, 06 Nov 2012 08:57:06 +0000
Message-ID: <5098DEF202000078000A695F@nat28.tlf.novell.com>
References: <5097E8C102000078000A661B@nat28.tlf.novell.com>
 <20121105183751.GA9031@jtriplet-mobl1>
 <20121105184346.GA13508@srcf.ucam.org>
 <20121105190047.GA9295@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121105190047.GA9295@jtriplet-mobl1>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: mingo-X9Un+BFzKDI@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

>>> On 05.11.12 at 20:00, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> On Mon, Nov 05, 2012 at 06:43:46PM +0000, Matthew Garrett wrote:
>> On Mon, Nov 05, 2012 at 10:37:52AM -0800, Josh Triplett wrote:
>> > On Mon, Nov 05, 2012 at 03:26:41PM +0000, Jan Beulich wrote:
>> > > Header length should be validated for all ACPI tables before accessing
>> > > any non-header field.
>> > > 
>> > > The valid flags should also be check, as with it clear there's no point
>> > > in trying to go through the rest of the code (and there's no guarantee
>> > > that the other table contents are valid/consistent in that case).
>> > > 
>> > > Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
>> > 
>> > The length check seems reasonable.  However, Matthew Garrett (already
>> > CCed) previously suggested to me that this code should not check the
>> > "valid" bit, and should instead present the information to userspace if
>> > otherwise valid (such as having image_address != 0).  Matthew?
>> 
>> Yeah, my interpretation of the spec is that "valid" indicates whether or 
>> not the contents represent what's currently on the screen, not whether 
>> or not the contents can be interpreted for other reasons.

That would be nice to get clarified.

> Given that, in the absence of a real BIOS that interprets the spec
> differently than that, it sounds like we should drop the check for the
> valid bit.
> 
> Jan, have you seen a real BIOS which disagrees with the above
> interpretation?

I would first have to check the rest of the data when the "valid"
bit is clear on the two system I have (out of which one may not
support BGRT at all).

The question here is how to properly invalidate that data then:
So far I was assuming that clearing the valid bit would be the way
to go, as the specification says nothing on e.g. the image address
being zero having any specific meaning. I need to do that in Xen,
at least for the time being, as I'm not inclined to postpone
indefinitely the use of boot services memory for normal memory
allocations (which we would have to do if we wanted Dom0 to
be able to access the image pointed to here).

I was quite bad a design decision to allow (and even suggest)
the image to live in boot services memory - one can't generally
expect the ACPI parser to become available in an OS before
setting up memory allocation. To Linux this already has turned
out to be a problem, on Xen dealing with this would turn out
even more cumbersome.

> If not, can you resubmit the patch with just the length check?

Sure - once clarified.

Jan
