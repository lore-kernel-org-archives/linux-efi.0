From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 4/6] arm64: mm: dump: make page table dumping reusable
Date: Tue, 31 May 2016 14:25:08 +0100
Message-ID: <20160531132508.GJ24936@arm.com>
References: <1461343688-8552-1-git-send-email-ard.biesheuvel@linaro.org>
 <1461343688-8552-5-git-send-email-ard.biesheuvel@linaro.org>
 <20160425110757.GI16065@arm.com>
 <20160513125606.GB4088@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160513125606.GB4088@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, May 13, 2016 at 01:56:07PM +0100, Mark Rutland wrote:
> On Mon, Apr 25, 2016 at 12:07:57PM +0100, Will Deacon wrote:
> > Hi Ard, Mark,
> > 
> > On Fri, Apr 22, 2016 at 06:48:06PM +0200, Ard Biesheuvel wrote:
> > > From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> > > 
> > > For debugging purposes, it would be nice if we could export page tables
> > > other than the swapper_pg_dir to userspace. To enable this, this patch
> > > refactors the arm64 page table dumping code such that multiple tables
> > > may be registered with the framework, and exported under debugfs.
> > > 
> > > Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > > ---
> > >  arch/arm64/include/asm/ptdump.h | 44 ++++++++++++++++++++
> > >  arch/arm64/mm/dump.c            | 32 ++++++++------
> > >  2 files changed, 64 insertions(+), 12 deletions(-)
> > 
> > Could you reorder this with patch 3, please? I'm unsure about the benefit
> > of the very specific string literal changes, but the ptdump stuff here
> > certainly looks beneficial.
> 
> I'm sure this is far too late, but for posterity I've rebased patch 4
> below atop of pathes 1 & 2 as queued in the arm64 for-next/core branch,
> without patch 3. It builds cleanly, and I've given it a spin on
> Juno.
> 
> Will, I guess I should rebase and resend this after we hit v4.7-rc1?

Yes, please.

Will
