From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Date: Mon, 03 Jun 2013 07:38:02 -0700
Message-ID: <1370270282.2910.9.camel@dabdike>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
	 <20130602225620.GA5496@srcf.ucam.org> <20130603081148.GB13607@nazgul.tnic>
	 <1370269642.2910.4.camel@dabdike> <20130603143010.GA20252@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130603143010.GA20252@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>, Matt Fleming <matt@console-pimps.org>, Jiri Kosina <jkosina@suse.cz>, X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-06-03 at 15:30 +0100, Matthew Garrett wrote:
> On Mon, Jun 03, 2013 at 07:27:22AM -0700, James Bottomley wrote:
> 
> > That's correct.  I think not calling SetVirtualAddressMap() and just
> > using a 1:1 mapping is far safer (having looked at what tianocore does
> > for SetVirtualAddressMap()).  The chances are that all the UEFI bioses
> > are only tested with windows, so the pointer chases it has to do to
> > switch address maps only work with the operations windows does.
> 
> Windows calls SetVirtualAddressMap(), so the only way these systems have 
> been tested is with SetVirtualAddressMap().

I know, but that's not what I said.

If you look at the implementation, SetVirtualAddressMap() does a massive
pointer chase through the images.  It not only tries to relocate the
text and data, but it also tries to relocate all the users of the data.
Some of these sources of data are boot time and some runtime.  Those
both need to be relocated by a separate pointer chase.  What we saw with
the QueryVariableInfo() problem was that a boot time pointer wasn't
relocated.  That's got to mean that windows only calls QueryVariableInfo
from runtime.

My point is that if we elect to call SetVirtualAddressMap() we'll be
restricted to only making the calls at boot time that windows does
otherwise we'll end up with these unrelocated pointers.  That's a huge
nasty verification burden on us.  Alternatively, if we never call
SetVirtualAddressMap() it seems to me that we just don't have to worry
about pointer relocation issues.  Thus, I think it would be better we
use the 1:1 mapping instead of calling SetVirtualAddressMap().

James
