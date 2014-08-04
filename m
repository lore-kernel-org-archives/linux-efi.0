From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] efi-bgrt: Add error handling; inform the user when
 ignoring the BGRT
Date: Mon, 4 Aug 2014 13:19:59 +0100
Message-ID: <20140804121959.GG15082@console-pimps.org>
References: <20140730192331.GA23730@jtriplet-mobl1>
 <20140731103110.GC15082@console-pimps.org>
 <20140731161133.GA12663@cloud>
 <20140801091949.GD15082@console-pimps.org>
 <20140801161154.GA1258@thin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140801161154.GA1258@thin>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Srihari Vijayaraghavan <linux.bug.reporting@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Garrett <mjg59@srcf.ucam.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 01 Aug, at 09:11:54AM, Josh Triplett wrote:
> 
> The original bug report was about an allocation failure for a fairly
> reasonable BGRT size.  We can certainly prohibit absurdly huge ones (for
> instance, bigger than the maximum likely screen resolution times 4 bytes
> per pixel), but allocation failures may well occur for smaller sizes,
> and I don't think we want to spew a massive warning for that either.

Oh, dammit, that's my bad. I misread the allocation size and thought it
was huge, but now realise it was only 6MB or so. Sorry Josh.

I was worried that this was the first reported instance of a BGRT
claiming to be valid but with a bogusly large image size. I've never
been so happy to be wrong.

However, the fact that the allocation failed is worth investigating -
this machine appears to have GBs of ram. Perhaps we should switch to
requesting pages directly instead of relying on kmalloc()? 

I appreciate that the BGRT code isn't mission critical or anything like
that, and that failing the alloc isn't the end of the world, but if we
have code in the kernel it should really be as robust as possible. I
don't think trying to kmalloc() ~6MB can claim to be robust.

-- 
Matt Fleming, Intel Open Source Technology Center
