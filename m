From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v3 3/4] x86/efi: print size in binary units in
 efi_print_memmap
Date: Tue, 26 Jan 2016 11:50:41 +0000
Message-ID: <20160126115041.GA7478@codeblueprint.co.uk>
References: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1453560913-134672-4-git-send-email-andriy.shevchenko@linux.intel.com>
 <1453567445.2470.24.camel@HansenPartnership.com>
 <94D0CD8314A33A4D9D801C0FE68B40295BF3B840@G9W0745.americas.hpqcorp.net>
 <1453748172.2363.36.camel@HansenPartnership.com>
 <CAHp75VdYRzC9TcDpKxq=xddA0zgVk=5_25uXaimn1tOMZVeK4Q@mail.gmail.com>
 <1453751131.2363.54.camel@HansenPartnership.com>
 <CAHp75VeXHoyOgFSb4vzWBmELH_yJx1mSN+quxue=tSZCh5sTXw@mail.gmail.com>
 <94D0CD8314A33A4D9D801C0FE68B40295BF3BBD3@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295BF3BBD3@G9W0745.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 25 Jan, at 08:37:58PM, Elliott, Robert (Persistent Memory) wrote:
> 
> For the UEFI memory map, that was indeed my intention.  I
> don't want it silently round to "20 GiB".  Even rounding
> to "19.999 GiB" is imprecise.

OK, let's just go with your original patch Robert (minus the @ addr
bit) since it's pretty small and does what we want for this specific
case.
