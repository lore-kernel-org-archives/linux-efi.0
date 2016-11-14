From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 0/2] Honey, I shrunk the EFI stub
Date: Mon, 14 Nov 2016 12:19:06 +0100
Message-ID: <20161114111906.GA9938@wunner.de>
References: <cover.1478510356.git.lukas@wunner.de>
 <20161112205514.GA2373@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161112205514.GA2373-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Nov 12, 2016 at 08:55:14PM +0000, Matt Fleming wrote:
> On Mon, 07 Nov, at 12:17:00PM, Lukas Wunner wrote:
> > Demonstrate the code reduction attainable by efi_call_proto()
> > which was proffered in a patch I've posted a few minutes ago.
> > 
> > For this to work, all three protocol variants (_32_t and _64_t for x86
> > and _t for ARM) need to be declared as typedefs.  The declaration and
> > naming of protocols in include/linux/efi.h currently isn't consistent,
> > some are declared as typedefs and some aren't, some use a "_t" suffix
> > and some don't.  These inconsistencies need to be straightened out
> > when converting to efi_call_proto().  It should be noted that checkpatch
> > complains about newly introduced typedefs.  It would be possible to
> > retool efi_call_proto() to work without typedef declarations as long
> > as it's done consistently.
>  
> This is probably v4.11 material. We *may* be able to get this into
> v4.10 if I review and merge this soon, but it definitely isn't going
> to be included in the imminent pull request.
> 
> I do like the general idea though.

Yes, this was posted quite late in the cycle so I didn't expect it
to make it into 4.10 really.  It was meant as a demonstration,
I can respin this into a series that deduplicates these redundancies
more thoroughly, but I wanted to gauge the reaction of the community
first.  Ard should probably also weigh in since it touches ARM code.

By the way, you mentioned that you have a MacBook2,1, is this the
Late 2006 version and would you be able to test changes to the
efistub on that machine?  I was thinking about obtaining such a
machine myself on ebay since right now I can only test x86_64,
not mixed mode.  If noone else is able to perform tests I might
just do that.  (Only the Late 2006 version uses mixed mode, the
Mid 2007 has a native 64-bit EFI.)


> > In __file_size32() all protocol calls are currently cast to unsigned long,
> > which is 64 bit when compiled on x86_64.  Matt has said that the register
> > needs to be loaded with a 32 bit address, so it looks to me like this is
> > currently broken for mixed-mode.  Patch [1/2] should fix this.  E.g.:
> > 
> > 	efi_file_handle_32_t *h, *fh = __fh;
> > [...]
> > 	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
> > 				 &info_sz, NULL);
> 
> There's a subtle distinction here between 32-bit address and 32-bit
> value. A 64-bit value can be a valid 32-bit address, provided that the
> upper 32-bits are zero, e.g. 0x00000000ffffffff.
> 
> So when I say "32-bit address" I really just mean some value where
> only the lower 32-bits are important.
> 
> That is why using unsigned long in mixed-mode is OK for the early call
> code.
>  
> > Another oddity is that info_sz is declared u32 in __file_size32(),
> > yet the spec says that the third argument to EFI_FILE_PROTOCOL.GetInfo()
> > is of type UINTN, which I assume is 64 bit regardless of mixed-mode,
> > or am I missing something?  Patch [1/2] uses an unsigned long instead.
> 
> UINTN is an unsigned value of native width as seen by the firmware. On
> 32-bit firmware that's 32-bits and 64-bit firmware 64-bits.
> 
> Using 'u32' in __file_size32() is correct, unsigned long is not.

Okay since this is all little endian, it should be okay to have a
64 bit wide variable on the stack whose address is passed to GetInfo()
as BufferSize argument.  But I guess I need to initialize it to 0
upon declaration so that the upper 32 bit are zeroed out in mixed mode,
right?  That would be a bug in patch [1/2] then.

Thanks,

Lukas
