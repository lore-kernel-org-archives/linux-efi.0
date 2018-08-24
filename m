From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 4.4 103/105] Revert "x86/mm/pat: Ensure cpa->pfn only
 contains page frame numbers"
Date: Fri, 24 Aug 2018 14:19:07 -0700
Message-ID: <20180824211907.GA9593@roeck-us.net>
References: <20171215092305.994559179@linuxfoundation.org>
 <20171215092311.347628971@linuxfoundation.org>
 <CAL1RGDVgShymmT+TJ3mAHEL7n+qoisk6mQ=Tji_T=0d_QA=VKw@mail.gmail.com>
 <1535129126.2902.36.camel@codethink.co.uk>
 <CAL1RGDW1Lo+F5D479Jsi-AFsmjVpdDre_qOFSCwWubG6U=bxeQ@mail.gmail.com>
 <20180824191749.GA15489@kroah.com>
 <CAL1RGDXUx-frpWuuYyc-VrAEoOU2+irGQPRWvoBzO2ZxEPGrww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDXUx-frpWuuYyc-VrAEoOU2+irGQPRWvoBzO2ZxEPGrww@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ben Hutchings <ben.hutchings@codethink.co.uk>, LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, matt@codeblueprint.co.uk, bp@suse.de, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, luto@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, bp@alien8.de, brgerst@gmail.com, davej@codemonkey.org.uk, dvlasenk@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, sai.praneeth.prakhya@intel.com, sds@tycho.nsa.gov, Thomas Gleixner <tglx@linutronix.de>, toshi.kani@hp.com, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Yazen.Ghannam@amd.com, Andi Kleen <ak@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

+Andi Kleen <ak@linux.intel.com>

On Fri, Aug 24, 2018 at 01:04:09PM -0700, Roland Dreier wrote:
> > Ok, so what patch should be reverted?  I'm seeing other reports of
> > problems all around this same area, but I can't figure out exactly what
> > to do.
> 
> Are any of those reports public?  If so can you point me at them, I'm
> curious if the symptoms match up.
> 
> I don't think we want to revert anything.  I think you should pull in
> edc3b9129cec and at least the first three patches that Ben listed:
> 
> 21cdb6b56843 x86/mm: Page align the '_end' symbol to avoid pfn conversion bugs
> b61a76f8850d x86/efi: Map RAM into the identity page table for mixed mode
> 753b11ef8e92 x86/efi: Setup separate EFI page tables in kexec paths
> 
> the first patch takes a bit of massaging (mostly because some of it is
> already touched by 02ff2769edbc, which keeps the changes from
> edc3b9129cec, and so we can drop a good bit when applying).  The other
> three apply cleanly.
> 
> I'm currently testing that and can send you the state of my tree in a bit.
> 
>  - R.
