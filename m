From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Date: Thu, 6 Jun 2013 22:07:05 +0200
Message-ID: <20130606200705.GO20972@pd.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-4-git-send-email-bp@alien8.de>
 <20130606104224.GH30420@console-pimps.org>
 <20130606132603.GD20972@pd.tnic>
 <20130606175052.GA1285@srcf.ucam.org>
 <20130606185140.GK20972@pd.tnic>
 <20130606193548.GA2946@srcf.ucam.org>
 <20130606194134.GN20972@pd.tnic>
 <20130606195450.GA3252@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130606195450.GA3252@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matt Fleming <matt@console-pimps.org>, Linux EFI <linux-efi@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>, X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 06, 2013 at 08:54:50PM +0100, Matthew Garrett wrote:
> We want both to be available when we're making the call, but I think
> we should probably enter via the high addresses. The only reason we're
> doing this at all is that some systems don't update all of their
> pointers from physical mode, and we'd prefer them to work rather than
> fault...

Actually, we do the 1:1 thing so that EFI runtime works in a kexec
kernel too. Which won't work if we use the high addresses.

However, if we can use the 1:1 map *after* SetVirtualAddressMap() has
been called with the high mappings, then my issue is solved - we drop
to using 1:1 in the kexec kernel only. But I don't think that is the
case...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
