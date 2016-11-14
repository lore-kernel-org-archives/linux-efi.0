From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 0/2] Honey, I shrunk the EFI stub
Date: Mon, 14 Nov 2016 16:32:31 +0100
Message-ID: <20161114153231.GB10141@wunner.de>
References: <cover.1478510356.git.lukas@wunner.de>
 <20161112205514.GA2373@codeblueprint.co.uk>
 <20161114111906.GA9938@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161114111906.GA9938-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 14, 2016 at 12:19:06PM +0100, Lukas Wunner wrote:
> On Sat, Nov 12, 2016 at 08:55:14PM +0000, Matt Fleming wrote:
> > On Mon, 07 Nov, at 12:17:00PM, Lukas Wunner wrote:
> > > Another oddity is that info_sz is declared u32 in __file_size32(),
> > > yet the spec says that the third argument to EFI_FILE_PROTOCOL.GetInfo()
> > > is of type UINTN, which I assume is 64 bit regardless of mixed-mode,
> > > or am I missing something?  Patch [1/2] uses an unsigned long instead.
> > 
> > UINTN is an unsigned value of native width as seen by the firmware. On
> > 32-bit firmware that's 32-bits and 64-bit firmware 64-bits.
> > 
> > Using 'u32' in __file_size32() is correct, unsigned long is not.
> 
> Okay since this is all little endian, it should be okay to have a
> 64 bit wide variable on the stack whose address is passed to GetInfo()
> as BufferSize argument.  But I guess I need to initialize it to 0
> upon declaration so that the upper 32 bit are zeroed out in mixed mode,
> right?  That would be a bug in patch [1/2] then.

Oh the info_sz variable *is* already initialized to 0 before the first
invocation of GetInfo().  So the patch should be fine, reviewed it
once more with the explanations in mind that you provided and couldn't
see anything else that would cause issues in mixed-mode.

Thanks,

Lukas
