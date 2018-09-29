From: dwalker@fifo99.com
Subject: Re: [PATCH 0/8] add generic builtin command line
Date: Sat, 29 Sep 2018 11:17:26 -0700
Message-ID: <20180929181725.GB27441@fifo99.com>
References: <1538067309-5711-1-git-send-email-maksym.kokhan@globallogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1538067309-5711-1-git-send-email-maksym.kokhan@globallogic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Maksym Kokhan <maksym.kokhan@globallogic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ralf Baechle <ralf@linux-mips.org>, Paul Burton <paul.burton@mips.com>, James Hogan <jhogan@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Daniel Walker <danielwa@cisco.com>, Andrii Bordunov <aborduno@cisco.com>, Ruslan Bilovol <rbil>
List-Id: linux-efi@vger.kernel.org

On Thu, Sep 27, 2018 at 07:55:08PM +0300, Maksym Kokhan wrote:
> Daniel Walker (7):
>   add generic builtin command line
>   drivers: of: ifdef out cmdline section
>   x86: convert to generic builtin command line
>   arm: convert to generic builtin command line
>   arm64: convert to generic builtin command line
>   mips: convert to generic builtin command line
>   powerpc: convert to generic builtin command line
> 

When I originally submitted these I had a very good conversion with Rob Herring
on the device tree changes. It seemed fairly clear that my approach in these
changes could be done better. It effected specifically arm64, but a lot of other
platforms use the device tree integrally. With arm64 you can reduce the changes
down to only Kconfig changes, and that would likely be the case for many of the
other architecture. I made patches to do this a while back, but have not had
time to test them and push them out.

In terms of mips I think there's a fair amount of work needed to pull out their
architecture specific mangling into something generic. Part of my motivation for
these was to take the architecture specific feature and open that up for all the
architecture. So it makes sense that the mips changes should become part of
that.

The only changes which have no comments are the generic changes, x86, and
powerpc. Those patches have been used at Cisco for years with no issues.
I added those changes into my -next tree for a round of testing. Assuming there
are no issues I can work out the merging with the architecture maintainers.
As for the other changes I think they can be done in time, as long as the
generic parts of upstream the rest can be worked on by any of the architecture
developers.

Daniel
