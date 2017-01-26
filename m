From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 2/2] arm64: efi: add vmlinux debug link to the Image
 binary
Date: Thu, 26 Jan 2017 18:26:17 +0000
Message-ID: <20170126182453.GA24043@leverpostej>
References: <1485340759-28975-1-git-send-email-ard.biesheuvel@linaro.org>
 <1485340759-28975-3-git-send-email-ard.biesheuvel@linaro.org>
 <20170125115305.GA29027@leverpostej>
 <CAKv+Gu-GQAQU2Ety+rBvZ-9VbUHe+jQQosFJ-63UTQ7pPHHh0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-GQAQU2Ety+rBvZ-9VbUHe+jQQosFJ-63UTQ7pPHHh0Q@mail.gmail.com>
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
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 25, 2017 at 12:00:44PM +0000, Ard Biesheuvel wrote:
> On 25 January 2017 at 11:53, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Wed, Jan 25, 2017 at 10:39:19AM +0000, Ard Biesheuvel wrote:
> >> When building with debugging symbols, take the absolute path to the
> >> vmlinux binary and add it to the special PE/COFF debug table entry.
> >>
> >> These entries are used internally by EDK2 based* debug builds of UEFI
> >> to populate the DebugImageInfo table, which can be used by debuggers
> >> as well as by the OS itself to retrieve information about all loaded
> >> PE/COFF executables. This is highly useful for source level debugging
> >> of the UEFI stub.
> >
> > Does that mean EFI_IMAGE_DEBUG_DIRECTORY_ENTRY and friends are
> > EDK2-specific?
> >
> > Or just that the way EDK2 happens to use those is EDK2-specific?
> 
> Those values are defined by the PE/COFF spec, and I assume that a
> CodeView type entry in the debug table usually contains a NUL
> terminated string as well, given that the EDK2 crowd is very
> Wintel-heavy.

So we don't actually have a definition of the format of a CodeView
entry, and we're guessing?

That does feel a little scary, especially given the fields are named
"Unknown". :(

> The significance of mentioning EDK2 here was that I thought that the
> DebugImageInfo table was a PI construct rather than something
> described in the UEFI spec. But looking more carefully, it seems that
> this table is in fact a UEFI construct, so I should probably drop this
> mention from the commit log

That would probably be for the best, yes.

Thanks,
Mark.
