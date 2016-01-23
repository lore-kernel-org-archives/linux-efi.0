From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v3 3/4] x86/efi: print size in binary units in
 efi_print_memmap
Date: Sat, 23 Jan 2016 20:29:26 +0000
Message-ID: <20160123202926.460b284f@lxorguk.ukuu.org.uk>
References: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1453560913-134672-4-git-send-email-andriy.shevchenko@linux.intel.com>
	<1453567445.2470.24.camel@HansenPartnership.com>
	<CAHp75Vdc9=uotvaf4pQfRoViyWuEXhXjZH7GVWEG79AquPVi5A@mail.gmail.com>
	<1453572775.2470.56.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453572775.2470.56.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>, Robert Elliott <elliott@hpe.com>
List-Id: linux-efi@vger.kernel.org

All a bit revisionist. Everyone else on the planet was upset about it
because it broke things like calculating bit density because the prefixes
for the bit capacity are not in metric form. BIPM (keeper of the SI
units) never approved powers of two as an interpretation. IEC came into
line in 1999, ISO followed.

Disk sizes have been decimal since at least the 1970s. The original IBM
10MB hard disc for example was 10MB not 10MiB.

Powers of two are only validly referred to as KiB, MiB, GiB as of all
current standard body positions. Powers of 10 based units are kB, MB, GB)

(The best one is CD and DVD: DVD uses the proper definition, CD uses MiB,
although given the multiple sector sizes and encodings on CD it's all
manure anyway)

Alan
