From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: [PATCH v2 11/12] ARM: wire up UEFI init and runtime support
Date: Mon, 16 Nov 2015 19:01:56 +0000
Message-ID: <20151116190156.GH8644@n2100.arm.linux.org.uk>
References: <1447698757-8762-1-git-send-email-ard.biesheuvel@linaro.org>
 <1447698757-8762-12-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447698757-8762-12-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 16, 2015 at 07:32:36PM +0100, Ard Biesheuvel wrote:
> +static inline void efi_set_pgd(struct mm_struct *mm)
> +{
> +	if (unlikely(mm->context.vmalloc_seq != init_mm.context.vmalloc_seq))
> +		__check_vmalloc_seq(mm);
> +
> +	cpu_switch_mm(mm->pgd, mm);
> +
> +	flush_tlb_all();
> +	if (icache_is_vivt_asid_tagged())
> +		__flush_icache_all();
> +}

I don't think that's sufficient.  There's a gap between switching the mm
and flushing the TLBs where we could have different global TLB entries
from those in the page tables - and that can cause problems with CPUs
which speculatively prefetch.  Some CPUs raise exceptions for this...

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
