From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 0/2] efivars: reading variables can generate SMIs
Date: Fri, 16 Feb 2018 19:58:56 +0100
Message-ID: <20180216185856.GE29042@pd.tnic>
References: <20180215182208.35003-1-joe.konno@linux.intel.com>
 <CAKv+Gu80pJ5tbGoJqBm8CCKrEZXdkE83c944383KbQ5jREUC0Q@mail.gmail.com>
 <20180216105548.GA29042@pd.tnic>
 <CAKv+Gu8qm2wFxY56-eRLkLZB6fRUCmZbZo=4cvo5e4JDFh01Gg@mail.gmail.com>
 <20180216110821.GB29042@pd.tnic>
 <CAKv+Gu_SD6yWJMGbTwGUWXtrgZKPkpANNaGe1PUruTG9j0yhcg@mail.gmail.com>
 <20180216184832.sqreq5zhar3jqdae@jbkonno-saint14>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180216184832.sqreq5zhar3jqdae@jbkonno-saint14>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Konno <joe.konno@linux.intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matthew Garrett <mjg59@google.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeremy Kerr <jk@ozlabs.org>, Andi Kleen <ak@linux.intel.com>, Tony Luck <tony.luck@intel.com>, Benjamin Drung <benjamin.drung@profitbricks.com>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 16, 2018 at 10:48:32AM -0800, Joe Konno wrote:
>  We may see some other patches or RFCs about caching and/or shadowing
> variable values in efivarfs to reduce the number of direct EFI reads,
> with the goal of reducing how many SMIs are generated.

So if you do the caching scheme, the question about narrowing
permissions becomes moot...

> Any obvious EFI variables that userspace tools have come to depend on--
> those which normal, unprivileged users need to read-- are helpful inputs
> to this discussion.

... which solves the aspect of not breaking userspace nicely.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
