From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi-bgrt: Switch pr_err() to pr_debug() for invalid
 BGRT
Date: Mon, 29 Jun 2015 15:49:40 +0100
Message-ID: <20150629144940.GF28334@codeblueprint.co.uk>
References: <1435579602-6612-1-git-send-email-matt@codeblueprint.co.uk>
 <20150629131305.GB13113@pd.tnic>
 <20150629140022.GA22374@x>
 <20150629141724.GG12383@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150629141724.GG12383@pd.tnic>
Sender: linux-acpi-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Josh Triplett <josh@joshtriplett.org>, Tom Yan <tom.ty89@gmail.com>, Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 29 Jun, at 04:17:24PM, Borislav Petkov wrote:
> On Mon, Jun 29, 2015 at 07:00:22AM -0700, Josh Triplett wrote:
> > Definitely not FW_BUG.  The field is reserved *now*; it would be
> > legitimate for a new version of the BGRT spec to define one of those
> > bits for something else.
> 
> Which would mean that booting old kernels on new FW which defines those
> reserved bits would cause that warning to fire erroneously.
> 
> So then we probably don't need it at all or we need to check implemented
> BGRT version of the FW running to know which bits are defined by the
> spec and which are reserved...
 
It still makes sense to have the error message because the kernel
literally does not know what the firmware is trying to achieve by
setting those bits.

But I agree with Josh that for the specific case of "reserved bits",
FW_BUG is wrong, because if in some future version of the spec those
bits get used, seeing,

  "[Firmware Bug]: Ignoring BGRT: reserved bits are non-zero 0x3"

is going to confuse the hell outta any firmware engineers, since it's
not the firmware that's buggy, it's just that the kernel lacks support.

This discussion should definitely be summarised in printk.h.

However, other error messages in efi-bgrt.c probably do want to be
sprinkled with FW_* if they represent things that should never happen
ever.

> Also, does the spec really say that reserved bits must be zero? Or it
> doesn't specify their value?

" 1-byte status field indicating current status about the table.
  Bits[7:1] = Reserved (must be zero)
  Bit [0] = Displayed. A one indicates the boot image graphic is
  displayed. "

-- 
Matt Fleming, Intel Open Source Technology Center
