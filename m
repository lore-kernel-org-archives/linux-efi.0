From: Borislav Petkov <bp@alien8.de>
Subject: Re: [GIT PULL] EFI changes for v3.16
Date: Tue, 20 May 2014 13:00:31 +0200
Message-ID: <20140520110031.GD16428@pd.tnic>
References: <20140503130447.GW26088@console-pimps.org>
 <20140519105129.GF4798@console-pimps.org>
 <537A8A03.8060604@zytor.com>
 <20140519231012.GF6311@pd.tnic>
 <537A9EFD.9050208@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <537A9EFD.9050208@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, May 19, 2014 at 05:17:01PM -0700, H. Peter Anvin wrote:
> I thought the whole point of allowing pstore in IRQ context was to
> write oopsen (panics?)

Right, so Tony meant last time we were talking about it that nvram is
too slow for collecting the whole dmesg into it (could mess up timing
and such - although, come to think of it, we do have CONFIG_PRINTK_TIME
so we can sort them if they're out of order...)

So what I'm questioning is whether a single oops/panic can be written
out to nvram reliably too?

Because if not, then the problem we're trying to solve is moot and
beside the point - maybe we should not use EFI as a pstore backend in
irq context at all?

I'm just putting it on the table so that we have talked about it too,
before devising a solution.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
