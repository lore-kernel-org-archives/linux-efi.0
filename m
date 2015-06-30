From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi-bgrt: Switch pr_err() to pr_debug() for invalid
 BGRT
Date: Tue, 30 Jun 2015 10:31:59 +0100
Message-ID: <20150630093159.GH28334@codeblueprint.co.uk>
References: <1435579602-6612-1-git-send-email-matt@codeblueprint.co.uk>
 <20150629131305.GB13113@pd.tnic>
 <20150629140022.GA22374@x>
 <20150629141724.GG12383@pd.tnic>
 <20150629144940.GF28334@codeblueprint.co.uk>
 <20150629154458.GH12383@pd.tnic>
 <20150629163553.GB1348@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150629163553.GB1348@cloud>
Sender: linux-acpi-owner@vger.kernel.org
To: josh@joshtriplett.org
Cc: Borislav Petkov <bp@alien8.de>, Tom Yan <tom.ty89@gmail.com>, Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 29 Jun, at 09:35:53AM, Josh Triplett wrote:
> On Mon, Jun 29, 2015 at 05:44:58PM +0200, Borislav Petkov wrote:
> > On Mon, Jun 29, 2015 at 03:49:40PM +0100, Matt Fleming wrote:
> > > It still makes sense to have the error message because the kernel
> > > literally does not know what the firmware is trying to achieve by
> > > setting those bits.
> > > 
> > > But I agree with Josh that for the specific case of "reserved bits",
> > > FW_BUG is wrong, because if in some future version of the spec those
> > > bits get used, seeing,
> > > 
> > >   "[Firmware Bug]: Ignoring BGRT: reserved bits are non-zero 0x3"
> > 
> > I still don't see what that message brings if some kernel complains that
> > some bits are !0 then. Are they valid bits which the kernel doesn't know
> > about or are they erroneously set and reserved. This, IMHO, is confusing
> > because the error message is not correct in all cases.
> > 
> > Thus my suggestion to either check the spec version before looking at
> > the bits or find out in some other way which bits are defined and which
> > are reserved and warn only about the reserved ones which are 1b.
> 
> The version is already checked *before* the status bits: if the version
> is not 1, the kernel stops there and ignores the BGRT, before printing a
> message about status.

If we're performing version[1] checks then I think it's fair game to use
FW_BUG, since these bits are reserved for that version.

[1] Note the version of the BGRT table is checked, not the ACPI spec
version, and it's not clear which would get a bump if new bits were
defined for the 'status' field. Historically, new bits have been added
to the EFI memory map without bumping the expected "memory descriptor"
version - a spec version update was considered to be sufficient (see
EFI_MEMORY_RO).

-- 
Matt Fleming, Intel Open Source Technology Center
