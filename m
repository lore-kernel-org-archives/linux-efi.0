From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Date: Mon, 3 Jun 2013 15:32:52 +0100
Message-ID: <20130603143252.GB20252@srcf.ucam.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <20130602225620.GA5496@srcf.ucam.org>
 <20130603081148.GB13607@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130603081148.GB13607@nazgul.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, Matt Fleming <matt@console-pimps.org>, Jiri Kosina <jkosina@suse.cz>, X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 03, 2013 at 10:11:48AM +0200, Borislav Petkov wrote:
> On Sun, Jun 02, 2013 at 11:56:20PM +0100, Matthew Garrett wrote:
> > I've just run Windows 8 under a hacked up copy of OVMF that dumps
> > the data passed to SetVirtualAddressMap. It seems that Windows *is*
> > mapping the runtime services to higher addresses - so presumably the
> > 1:1 mapping is in addition to the virtual mapping.
> 
> But but, once we call SetVirtualAddressMap with the set of addresses of
> the runtime services, only those can be used after, right? If so, we
> can't have both (this is at least my understanding)...

We can only pass one set of addresses to SetVirtualAddressMap(), but it 
doesn't seem like there's any intrinsic reason we can't the runtime 
regions mapped to multiple virtual addresses.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
