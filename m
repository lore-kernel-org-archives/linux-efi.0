From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v3 2/3] x86/efi: Retrieve and assign Apple device
 properties
Date: Mon, 7 Nov 2016 11:48:27 +0100
Message-ID: <20161107104827.GA6310@wunner.de>
References: <cover.1478145888.git.lukas@wunner.de>
 <495c463bcb78131bf04ece648719fc8b3e9bd4ba.1478145888.git.lukas@wunner.de>
 <20161103233100.GC8845@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161103233100.GC8845-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,

Thanks a lot for the review and comments!

On Thu, Nov 03, 2016 at 11:31:00PM +0000, Matt Fleming wrote:
> On Thu, 03 Nov, at 11:18:48AM, Lukas Wunner wrote:
> > +	if ((efi_is_64bit() ?
> > +			((apple_properties_protocol_64 *)properties)->version :
> > +			((apple_properties_protocol_32 *)properties)->version)
> > +								   != 0x10000) {
> > +		efi_printk(sys_table, "Unsupported properties proto version\n");
> > +		return;
> > +	}
> 
> It's a minor point, but please don't write the 32/64 code like this.
> Either use two separate functions, like __file_size32() and
> __file_size64(), or if that's two much code duplication stash the
> version field and get_all pointer in stack-local variables at the
> start of the function.

My plan was to introduce an efi_call_proto() macro which hides the
ternary operator similar to efi_call_early(), then use that to
deduplicate the code in the EFI stub.  I wanted to postpone opening
that can of worms until after this series has landed, hence the
not so readable code above.  To address your (valid) objection,
I've now included a commit with the efi_call_proto() macro in v4
and I'll follow up with two separate patches to demonstrate the
attainable code reduction.

So this is probably a bit different to what you had in mind.
If you think this approach isn't well suited for some reason just
let me know.


> > +	if (!memcmp((void *)sys_table->fw_vendor, apple, sizeof(apple))) {
> > +		if (IS_ENABLED(CONFIG_APPLE_PROPERTIES))
> > +			retrieve_apple_device_properties(boot_params);
> > +	}
> > +
> 
> Could you split this off into a setup_apple_properties() function to
> mirror setup_efi_pci()?

We're going to need at least one other Apple-specific quirk to
masquerade as MacOS X to EFI using another proprietary protocol:
On 2013+ MacBook Pros with hybrid graphics the integrated Intel GPU
is invisible to the OS (powered down) unless this identification
scheme is used.  A preliminary patch for this has been floating around
for a while but wasn't mainlined so far for a number of reasons:
https://marc.info/?l=grub-deavel&m=141586614924917&w=2

Conceivably we may need to add further vendor- or device-specific
quirks to the EFI stub in the future, so I've moved this out of
efi_main() and into a new setup_quirks() function.


> > +
> > +		key = kzalloc((key_len - sizeof(key_len)) * 4 + 1, GFP_KERNEL);
> > +		if (!key) {
> > +			dev_err(dev, "cannot allocate property name\n");
> > +			break;
> > +		}
> 
> Could you add a comment to document the kzalloc() size argument above?

Ok, done.  I'm allocating 4 bytes for each character to accommodate UTF-8
code points, plus 1 null byte.  I'm aware that the string may need much
less than 4 bytes per character, but it's only allocated temporarily
and freed after the properties have been assigned to the device.


> > +	if (i != dev_header->prop_count) {
> > +		dev_err(dev, "got %d device properties, expected %u\n", i,
> > +			dev_header->prop_count);
> > +		print_hex_dump(KERN_ERR, pr_fmt(), DUMP_PREFIX_OFFSET,
> > +			16, 1, dev_header, dev_header->len, true);
> > +	} else
> > +		dev_info(dev, "assigning %d device properties\n", i);
> 
> Mismatched braces are frowned upon in the CodingStyle guide. Please
> use braces for both the 'if' and 'else'. Alternatively, return early
> for one of the conditions (and save a level of indentation too).

Good idea, thanks.


> Newline here please.
[...]
> And a newline here.
[...]
> Please sprinkle a few newlines to make this more readable.
[...]
> Newline please.
[...]
> Newline.
[...]
> Newline.
[...]
> Newline.

Yes, sorry, I guess sometimes my "compact code" fetishism becomes a bit
exaggerated.


On Mon, Nov 07, 2016 at 09:37:14AM +0000, Matt Fleming wrote:
> Ideally, I'd like to send the v4.10 material to tip by the end of the
> week.

Yes, thanks for the heads-up, it was already on my radar that you send
out the pull after rc4 so I cooked this up over the weekend.

Best regards,

Lukas
