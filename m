From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL v4 0/6] EFI page table isolation
Date: Sun, 29 Nov 2015 09:18:20 +0100
Message-ID: <20151129081820.GA24006@gmail.com>
References: <1448658575-17029-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448658575-17029-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, Dave Jones <davej@codemonkey.org.uk>, Denys Vlasenko <dvlasenk@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> Folks,
> 
> This patch series is a response to the report that the EFI region
> mappings trigger warnings when booting with CONFIG_DEBUG_WX enabled.
> They allocate a new page table structure and ensure that all the
> mappings we require during EFI runtime calls are only setup there.
> 
> It turns out that it still makes sense to share some page table
> entries with 'swapper_pg_dir', just not the entries where we need to
> allow security lax permissions. Sharing entries is useful for memory
> hotplug, for example.
> 
> When writing this series I discovered a number of bugs in the existing
> code that only became apparent when we stopped using 'trampoline_pgd'
> which already mapped a bunch of things for us. I've put those bug
> fixes at the start of the series.
> 
> Further testing would be very much appreciated as this is a
> notoriously funky area of the EFI code.

Ok, this series looks great to me - I've applied this to tip:x86/efi and will push 
it out to linux-next after it passes some local testing.

There should be time enough before v4.5 to figure out potential bugs.

Thanks,

	Ingo
