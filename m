From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] Map in physical addresses in efi_map_region_fixed
Date: Tue, 16 Aug 2016 15:29:33 +0200
Message-ID: <20160816132933.GA11106@nazgul.tnic>
References: <1470441575-96065-1-git-send-email-athorlton@sgi.com>
 <20160815124258.GF30909@codeblueprint.co.uk>
 <20160815150709.GA6085@nazgul.tnic>
 <20160816123028.GN30909@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160816123028.GN30909@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, Dave Young <dyoung@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Aug 16, 2016 at 01:30:28PM +0100, Matt Fleming wrote:
> That's impossible, because that would mean we loaded the kexec kernel
> over the top of physical pages of EFI services. We still need to be
> able to invoke EFI services from kexec - we just can't change their
> virtual mappings.

Which would mean that whatever comes second - kexec reservation or 1:1
mappings - won't work.

> This is because of the way that the SGI firmware works and that the
> "new" virtual address mappings are usable on SGI+kexec now.

My only issue is that we probably should've aimed for avoiding that...

> No, some Apple platforms will not boot if SetVirtualAddressMap()
> passes 1:1 mappings, and we only enter the firmware via the 1:1
> mappings for EFI mixed mode calls. We're still using the virtual
> runtime mappings in the commit you reference below most of the time.

... but reasons like the above are making us run the kexec kernel with
the exact-same mappings as the boot kernel. Probably not really a big
deal since we have our own pagetable...

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
