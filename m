From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH 4.4 103/105] Revert "x86/mm/pat: Ensure cpa->pfn only
 contains page frame numbers"
Date: Wed, 29 Aug 2018 12:58:00 -0700
Message-ID: <CAL1RGDWKujPp-O5RnxBsBvEe8yf-bNXSN1fa4DtY4b5-fQH2rQ@mail.gmail.com>
References: <20171215092305.994559179@linuxfoundation.org> <20171215092311.347628971@linuxfoundation.org>
 <CAL1RGDVgShymmT+TJ3mAHEL7n+qoisk6mQ=Tji_T=0d_QA=VKw@mail.gmail.com>
 <1535129126.2902.36.camel@codethink.co.uk> <CAL1RGDW1Lo+F5D479Jsi-AFsmjVpdDre_qOFSCwWubG6U=bxeQ@mail.gmail.com>
 <20180824191749.GA15489@kroah.com> <CAL1RGDXUx-frpWuuYyc-VrAEoOU2+irGQPRWvoBzO2ZxEPGrww@mail.gmail.com>
 <35e0f79b-6fac-5027-6377-67dbe2a293b9@roeck-us.net> <20180825150723.GA10230@kroah.com>
 <c2e61e43-6cd5-567a-8c3c-3cc3ff456c31@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <c2e61e43-6cd5-567a-8c3c-3cc3ff456c31@roeck-us.net>
Sender: stable-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ben Hutchings <ben.hutchings@codethink.co.uk>, LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, matt@codeblueprint.co.uk, bp@suse.de, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, luto@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, bp@alien8.de, brgerst@gmail.com, davej@codemonkey.org.uk, dvlasenk@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, sai.praneeth.prakhya@intel.com, sds@tycho.nsa.gov, Thomas Gleixner <tglx@linutronix.de>, toshi.kani@hp.com, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Yazen.Ghannam@amd.com
List-Id: linux-efi@vger.kernel.org

> > Perhaps just the patch that Andi posted to the stable list helps out
> > here?
> >
>
> For reference:
>
> https://www.spinics.net/lists/stable/msg253357.html
>
> That would be the most straightforward and simple fix, so I would prefer
> to go with it if it works.

Sorry for being slow, it turned out to take a slightly bigger stack of
patches to get everything working.

I agree, Andi's simple fix is better anyway.

 - R.
