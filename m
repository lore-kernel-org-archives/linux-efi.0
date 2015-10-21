From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] x86/mm: warn on W+x mappings
Date: Wed, 21 Oct 2015 11:42:42 +0200
Message-ID: <20151021094242.GA12155@gmail.com>
References: <20151006073205.GA11115@gmail.com>
 <5613EAD5.2070405@tycho.nsa.gov>
 <20151012113605.GB7384@pd.tnic>
 <20151012124113.GD2579@codeblueprint.co.uk>
 <20151012124936.GA6260@gmail.com>
 <20151012125548.GE2579@codeblueprint.co.uk>
 <20151012141754.GA6621@gmail.com>
 <20151012144928.GF2579@codeblueprint.co.uk>
 <20151014151807.GA27013@gmail.com>
 <20151014210257.GF2782@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151014210257.GF2782@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Borislav Petkov <bp@alien8.de>, Stephen Smalley <sds@tycho.nsa.gov>, x86@kernel.org, linux-kernel@vger.kernel.org, keescook@chromium.org, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>, linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> > > Right, we could do that, but then we wouldn't be able to support 
> > > creation/updating variables at runtime, such as when you install a 
> > > distribution for the first time, or want to boot a new kernel filename 
> > > directly from the firmware without a boot loader (and need to modify the 
> > > BootXXXX variables).
> > 
> > Do we know the precise position and address range of these variables?
> > 
> > We could map them writable (but not executable), and the rest executable (but 
> > not writable).
>  
> The variables are stored in NVRAM, which we don't map into the kernel virtual 
> address space. [...]

Just curious: is there firmware that memory maps those variables privately?

> [...] We have to initiate the transaction of writing to the variables by 
> executing EFI runtime services.
> 
> We obviously have buffers that we pass to the BIOS that contain variable data, 
> but these should be NX anyway because they're regular kernel allocations.
> 
> > That raises the question whether the same physical page ever mixes variables 
> > and actual code - but the hope would be that it's suffiently page granular for 
> > this to work.
> 
> I don't think that would ever happen.

Ok, that's promising, so how about this then to solve the security weakness the 
new warning unearthed: map the whole EFI range as 'r-x (NX)', but detect writes 
from the page fault handler and transparently allow them to flip over the range to 
'rw-'.

Note that for security reasons we don't allow a subsequent flipping back to NX if 
there's an NX fault on the same page, i.e. this new mechanism is a monotonic 
one-way process that should dynamically 'map out' data pages versus executable 
pages.

It should also be pretty robust, assuming we can take page faults while EFI code 
is executing and is trying to modify EFI data: is that the case?

Thanks,

	Ingo
