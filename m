From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] arm64/efi: set PE/COFF section alignment to 4 KB
Date: Fri, 10 Oct 2014 15:09:15 +0100
Message-ID: <20141010140915.GE6004@leverpostej>
References: <1412933124-13018-1-git-send-email-ard.biesheuvel@linaro.org>
 <20141010103301.GC4076@leverpostej>
 <CAKv+Gu9b56r3Ujv342xC5CA3_i4yE6ySd=UjUss2U5Yaho0jAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9b56r3Ujv342xC5CA3_i4yE6ySd=UjUss2U5Yaho0jAQ@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Will Deacon <Will.Deacon@arm.com>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "roy.franz@linaro.org" <roy.franz@linaro.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "msalter@redhat.com" <msalter@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 10, 2014 at 11:37:03AM +0100, Ard Biesheuvel wrote:
> On 10 October 2014 12:33, Mark Rutland <mark.rutland@arm.com> wrote:
> > Hi Ard,
> >
> > On Fri, Oct 10, 2014 at 10:25:24AM +0100, Ard Biesheuvel wrote:
> >> Position independent AArch64 code needs to be linked and loaded at the same
> >> relative offset from a 4 KB boundary, or adrp/add and adrp/ldr pairs will
> >> not work correctly. (This is how PC relative symbol references with a 4 GB
> >> reach are emitted)
> >>
> >> We need to declare this in the PE/COFF header, otherwise the PE/COFF loader
> >> may load the Image and invoke the stub at an offset which violates this rule.
> >
> > Has this been observed happening, or was this just found by inspection?
> >
> 
> This is also something found by inspection, or rather, by the
> discussion going on in the other thread. I am not aware of any PE/COFF
> loaders that may choose an offset that is not 4 KB aligned, even if
> the header we give it appears to allow it.
> 
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >> ---
> >>  arch/arm64/kernel/head.S | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> >> index 0a6e4f924df8..5e83e5b8a9de 100644
> >> --- a/arch/arm64/kernel/head.S
> >> +++ b/arch/arm64/kernel/head.S
> >> @@ -159,7 +159,7 @@ optional_header:
> >>
> >>  extra_header_fields:
> >>       .quad   0                               // ImageBase
> >> -     .long   0x20                            // SectionAlignment
> >> +     .long   0x1000                          // SectionAlignment

Looking at this again, I'm more confused than I was to begin with.

Surely we know exactly where the .text section will be loaded because of
its VirtualAddress? If that were the case, we can drop the .align 12 as
we already load it at the offset any arp or :lo12: immediate will have
been built for.

I don't follow how SectionAlignment interacts with a given section's
VirtualAddress.

Thanks,
Mark.

> >>       .long   0x8                             // FileAlignment
> >>       .short  0                               // MajorOperatingSystemVersion
> >>       .short  0                               // MinorOperatingSystemVersion
> >> @@ -226,7 +226,7 @@ section_table:
> >>       .short  0               // NumberOfRelocations  (0 for executables)
> >>       .short  0               // NumberOfLineNumbers  (0 for executables)
> >>       .long   0xe0500020      // Characteristics (section flags)
> >> -     .align 5
> >> +     .align 12
> >
> > Can we get a comment explaining why stext needs the additional
> > alignment? Something like:
> >
> >         /*
> >          * EFI will load stext onwards at the 4k section alignment
> >          * described in the PE/COFF header. To ensure that instruction
> >          * sequences using an adrp and a :lo12: immediate will function
> >          * correctly at this alignment, we must ensure that stext is
> >          * placed at a 4k boundary in the Image to begin with.
> >          */
> >         .align 12
> >
> 
> OK
> 
> -- 
> Ard.
> 
