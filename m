From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [GIT PULL] EFI urgent fix
Date: Fri, 20 Jun 2014 15:19:28 +0100
Message-ID: <20140620141927.GL4179@bivouac.eciton.net>
References: <20140620090008.GU24049@console-pimps.org>
 <20140620092848.GC23939@arm.com>
 <20140620133919.GK4179@bivouac.eciton.net>
 <20140620134938.GY24049@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140620134938.GY24049@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jun 20, 2014 at 02:49:38PM +0100, Matt Fleming wrote:
> On Fri, 20 Jun, at 02:39:19PM, Leif Lindholm wrote:
> > 
> > I did post an alternative patch for one half of this a week before
> > anyone else, but that one seems to have been ignored, even by gmane:
> > http://www.spinics.net/lists/linux-efi/msg03924.html
>  
> Sorry Leif, I don't know why I didn't pick that one up. I do see it in
> my mail archive. Chalk it up to human error.

Well, it seemed to manage to trick at least one computer too...

> > That form will still be required for the 32-bit arm support, since
> > strncmp is not available in the zImage.
> 
> Are you planning on incorporating this fix into the 32-bit arm support
> patch series

Yeah, I'll do that.
Just as soon as I get back off holiday :)

/
    Leif
