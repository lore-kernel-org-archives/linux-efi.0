From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] acpi, apei: use appropriate pgprot_t to map GHES
 memory
Date: Tue, 25 Aug 2015 10:59:23 +0200
Message-ID: <20150825085923.GA22414@gmail.com>
References: <1439591850-29002-1-git-send-email-zjzhang@codeaurora.org>
 <1439591850-29002-2-git-send-email-zjzhang@codeaurora.org>
 <20150822092429.GB18233@gmail.com>
 <55DB60FA.8050406@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55DB60FA.8050406-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zhang, Jonathan Zhixiong" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel @ vger . kernel . org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi @ vger . kernel . org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Zhang, Jonathan Zhixiong <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:

> 
> 
> On 8/22/2015 2:24 AM, Ingo Molnar wrote:
> >
> >* Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> >
> >>From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> >>
> >>With ACPI APEI firmware first handling, generic hardware error
> >>record is updated by firmware in GHES memory region. On an arm64
> >>platform, firmware updates GHES memory region with uncached
> >>access attribute, and then Linux reads stale data from cache.
> >
> >This paragraph *still* doesn't parse for me. It's not any English
> >I can recognize: what is a 'With ACPI APEI firmware first handling'?
> APEI is ACPI Platform Error Interface; it is part of ACPI spec,
> defining the aspect of hardware error handling. "firmware first
> handling" is a terminology used in APEI. It describes such mechanism
> that when hardware error happens, firmware intersects/handles such
> hardware error, formulates hardware error record and writes the record
> to GHES memory region, notifies the kernel through NMI/interrupt, then
> the kernel GHES driver grabs the error record from the GHES memory
> region.

Argh. So how about translating that to English and putting that misnomer into 
scare quotes, and saying something like:

  If the ACPI APEI firmware handles the error first (called "firmware first 
  handling"), the generic hardware error record is updated by the firmware in the 
  GHES memory region.

( Also note all the missing articles I added for readability. The rest of the 
  changelog is missing articles as well. )

> > ... plus what this changelog still doesn't mention is the most important part 
> > of any bug fix description: how does the user notice this in practice and why 
> > does he care?
>
> The changelog mentioned that Linux would read stale data from cache. When stale 
> data is read, kernel reports there is no new hardware error when there actually 
> is.

Note that this is the most valuable sentence so far, in this whole changelog and 
discussion. And we needed how many emails to get to this point?

obviously saying 'stale data' in itself does not mean much - it could mean a 
harmless inconsistency nobody really cares about, or in fact it could mean 
something more serious:

> [...] This may lead to further damage in various scenarios, such as error 
> propagation caused data corruption.

Please outline this better. How users are affected in practice is far more 
important than any other detail.

Thanks,

	Ingo
