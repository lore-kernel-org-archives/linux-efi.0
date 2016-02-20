From: Robert Richter <robert.richter@caviumnetworks.com>
Subject: Re: [PATCH v11 00/10] arm64, numa: Add numa support for arm64
 platforms
Date: Sat, 20 Feb 2016 11:39:59 +0100
Message-ID: <20160220103959.GC4914@rric.localdomain>
References: <1455930799-5371-1-git-send-email-ddaney.cavm@gmail.com>
 <CAKv+Gu8FRdif_WDZPqs7gHxXMu=6SqDd6A54dQc1KWuGwxpf0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8FRdif_WDZPqs7gHxXMu=6SqDd6A54dQc1KWuGwxpf0w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: David Daney <ddaney.cavm@gmail.com>, Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Frank Rowand <frowand.list@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>
List-Id: linux-efi@vger.kernel.org

On 20.02.16 09:20:05, Ard Biesheuvel wrote:
> On 20 February 2016 at 02:13, David Daney <ddaney.cavm@gmail.com> wrote:
> > From: David Daney <david.daney@cavium.com>
> >
> > v11:
> >         - Dropped cleanup patches for other architectures, they will be
> >           submitted as a separate set after more testing.
> >
> >         - Added patch set from Ard Biesheuvel that are needed to make
> >           the whole thing actually work.  Previously this was a
> >           separate set.
> >
> 
> This series is out of date, unfortunately. The EFI init code is now
> (as of v4.5-rc1) shared between ARM and arm64, which means that any
> changes you make must be made on both sides. This applies to the split
> between parsing the EFI dt nodes and performing the actual EFI init,
> but also to the early_init_dt_add_memory_arch() changes. I am happy to
> have a go at this, but first I need a clear statement from whoever
> maintains that area that keeping memory nodes *just* for the
> annotations (and otherwise ignore them) is the way forward (Rob?
> Grant?)

Wasn't there the approach to check for consistency between efi tables
and devicetree? Thus, DT is actually not ignored but rather checked if
it is in sync with efi tables.

-Robert
