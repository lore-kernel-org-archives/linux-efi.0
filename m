From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH 4.4 103/105] Revert "x86/mm/pat: Ensure cpa->pfn only
 contains page frame numbers"
Date: Fri, 24 Aug 2018 10:08:28 -0700
Message-ID: <CAL1RGDW1Lo+F5D479Jsi-AFsmjVpdDre_qOFSCwWubG6U=bxeQ@mail.gmail.com>
References: <20171215092305.994559179@linuxfoundation.org> <20171215092311.347628971@linuxfoundation.org>
 <CAL1RGDVgShymmT+TJ3mAHEL7n+qoisk6mQ=Tji_T=0d_QA=VKw@mail.gmail.com> <1535129126.2902.36.camel@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1535129126.2902.36.camel@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ben Hutchings <ben.hutchings@codethink.co.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, matt@codeblueprint.co.uk, bp@suse.de, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, luto@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, bp@alien8.de, brgerst@gmail.com, davej@codemonkey.org.uk, dvlasenk@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, sai.praneeth.prakhya@intel.com, sds@tycho.nsa.gov, Thomas Gleixner <tglx@linutronix.de>, toshi.kani@hp.com, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Yazen.Ghannam@amd.com
List-Id: linux-efi@vger.kernel.org

> See
> <https://lore.kernel.org/lkml/1512686629.18523.217.camel@codethink.co.uk/T/#u>.

Thanks!  I'm not using SGI UV and I'm not using kexec, so I guess I
sidestepped most of those issues.  Greg, I think we need to unrevert
the cpa->pfn change (otherwise the L1TF fix probably gets pretty
messy) and I guess pull in the other patches that Ben mentions.

 - R.
