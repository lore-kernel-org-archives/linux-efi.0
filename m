From: Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC PATCH 0/2] efi: add contents of LinuxExtraArgs EFI var to
 command line
Date: Fri, 13 Jul 2018 10:56:04 +0100
Message-ID: <20180713095604.GD32020@arm.com>
References: <20180704154919.18564-1-ard.biesheuvel@linaro.org>
 <4bd9bee6-f2b9-3197-c205-fec104fd1090@infradead.org>
 <CAKv+Gu9+RYbtD8Ce_AW_1jvTei6dC5LwiiMgSUWDKLs8f7S+eA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9+RYbtD8Ce_AW_1jvTei6dC5LwiiMgSUWDKLs8f7S+eA@mail.gmail.com>
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
Cc: Mark Rutland <mark.rutland@arm.com>, linux-efi <linux-efi@vger.kernel.org>, Geoff Levand <geoff@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Riku Voipio <riku.voipio@linaro.org>, Mark Salter <msalter@redhat.com>, Leif Lindholm <leif.lindholm@linaro.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, James Morse <james.morse@arm.com>, Hanjun Guo <hanjun.guo@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Ian Campbell <ijc@debian.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jul 13, 2018 at 08:15:26AM +0200, Ard Biesheuvel wrote:
> On 13 July 2018 at 00:22, Geoff Levand <geoff@infradead.org> wrote:
> > Hi Ard,
> >
> > On 07/04/2018 08:49 AM, Ard Biesheuvel wrote:
> >>   efi/libstub: taken contents of LinuxExtraArgs UEFI variable into
> >>     account
> >
> > To me this seems an overly complicated interface to the kernel, and
> > still doesn't in itself solve the problem at hand -- make the
> > generic distro kernel with APEI support run on m400 systems.
> >
> > As for me, I'd prefer something like my original patch.  It fixes
> > that problem, it is simple and self contained, and is very clear
> > in what it does.  Also, there is a limited life.  When the time
> > comes an announcement is made to the mailing lists 'Linux-XYZ will
> > no longer support the m400 Moonshot'.  Then, when the Linux-XYZ-rc1
> > merge window opens a patch goes in that removes the
> > acpi_fixup_m400_quirks() routine.
> >
> 
> Actually, that is a very good point. One of the issues I have with
> these quirks is that the burden is on the maintainers to keep them
> around forever, unless they can prove that it is no longer needed.
> 
> This is not my call to make, but I would be much less averse to this
> being merged if we could agree upfront on an expiration time of, say,
> 2 years (or more?), after which it will be removed (unless anyone
> makes a very good case for why it needs to be retained). This should
> be mentioned in the kernel log as well when the quirk is triggered.

The problem with that is it all falls apart when somebody who wasn't
involved in the initial discussion crops up after we remove the quirk to
complain that their machine broke. In such a situation, we don't have a
leg to stand on in my opinion.

Will
