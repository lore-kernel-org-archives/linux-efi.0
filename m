From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH v2 00/10] arm64: UEFI support
Date: Tue, 29 Apr 2014 17:41:39 +0100
Message-ID: <20140429164139.GI4179@bivouac.eciton.net>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
 <20140429102817.GE17007@arm.com>
 <20140429114356.GK26088@console-pimps.org>
 <20140429134726.GH17007@arm.com>
 <20140429144713.GL26088@console-pimps.org>
 <535FBD94.9040101@zytor.com>
 <20140429152707.GM26088@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140429152707.GM26088@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Catalin Marinas <catalin.marinas@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "msalter@redhat.com" <msalter@redhat.com>, "grant.likely@linaro.org" <grant.likely@linaro.org>, "roy.franz@linaro.org" <roy.franz@linaro.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, Mark Rutland <Mark.Rutland@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 29, 2014 at 04:27:07PM +0100, Matt Fleming wrote:
> > I'm wondering if it would be better to organize it into a separate topic
> > branch.  We can still take it through tip, if you want, but it would be
> > better than putting it all into one tree.
> 
> Sure, that makes sense. I'll do that.

I've set up a new topic branch, "uefi-for-3.16" on
git://git.linaro.org/people/leif.lindholm/linux.git
Based off tip/x86/efi.

/
    Leif
