From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: [PATCH v2 07/12] ARM: split off core mapping logic from
 create_mapping
Date: Mon, 16 Nov 2015 19:45:28 +0000
Message-ID: <20151116194528.GI8644@n2100.arm.linux.org.uk>
References: <1447698757-8762-1-git-send-email-ard.biesheuvel@linaro.org>
 <1447698757-8762-8-git-send-email-ard.biesheuvel@linaro.org>
 <20151116185519.GE8644@n2100.arm.linux.org.uk>
 <CAKv+Gu-P45_S2aHE2Dr=i-2e29-DvmSBR_JWec=JPcZeTMn02Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-P45_S2aHE2Dr=i-2e29-DvmSBR_JWec=JPcZeTMn02Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryan Harkin <ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 16, 2015 at 08:01:03PM +0100, Ard Biesheuvel wrote:
> On 16 November 2015 at 19:55, Russell King - ARM Linux
> <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org> wrote:
> > I'm slightly worried about this.  Generally, these functions setup
> > global mappings.  If you're wanting to have a private set of page
> > tables for UEFI, and those private page tables contain global
> > mappings which are different from the mappings in the kernel's page
> > tables, then you need careful break-TLBflush-make handling when
> > switching from the kernel's page tables to the private UEFI ones,
> > and vice versa.
> >
> > Has this aspect been considered?
> 
> Yes. The UEFI mappings are all below 1 GB, and the top kernel end is
> reused as we do for ordinary userland page tables. The switch to the
> UEFI page tables performs a full TLB flush. What it does not do is
> break before make, as far as I can tell, so any pointers regarding how
> to implement that would be appreciated (this is implemented in 11/12)

What matters is whether they are global mappings or not.  If they are,
when the TLB can contain conflicting entries.  If they are non-global
mappings, they will be tagged with the ASID which makes them unique
to each mm.

The simple solution is to ensure that they're non-global, and then you
don't need to even worry about flushing the TLB when switching.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
