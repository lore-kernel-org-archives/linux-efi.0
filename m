From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] acpi: bgrt: parse BGRT to obtain BMP address before it
 gets clobbered
Date: Tue, 29 Jan 2019 11:11:19 -0500
Message-ID: <20190129161118.yncs67ud56hmjs7a@redhat.com>
References: <20190122150616.850-1-ard.biesheuvel@linaro.org>
 <20190123053141.GA7376@dhcp-128-65.nay.redhat.com>
 <CAKv+Gu9yVSfxfy37Z3xt-Ft70VtNs4YYQfcAvMB2qEdSLHhruw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9yVSfxfy37Z3xt-Ft70VtNs4YYQfcAvMB2qEdSLHhruw@mail.gmail.com>
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
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Graeme Gregory <graeme.gregory@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Leif Lindholm <leif.lindholm@linaro.org>, Al Stone <astone@redhat.com>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, "Hsiung,
 Harry L" <harry.l.hsiung@intel.com>, Dave Young <dyoung@redhat.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Len Brown <lenb@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 23, 2019 at 10:44:47AM +0100, Ard Biesheuvel wrote:
> On Wed, 23 Jan 2019 at 06:31, Dave Young <dyoung@redhat.com> wrote:
> > On 01/22/19 at 04:06pm, Ard Biesheuvel wrote:
> > > The bitmap left in the framebuffer by the firmware is described by an
> > > ACPI table called "BGRT", which describes the size, pixel format and
> > > the address of a BMP image in memory. While the BGRT ACPI table is
> > > guaranteed to reside in a "ACPI reclaim" memory region, which is
> > > never touched by Linux. The BMP image, however, typically resides
> > > in EFI Boot Services Memory, which may have been overwritten by the
> > > time the BGRT discovery routine runs.
> >
> > I vaguely remember boot service memory is reserved on X86,  so this
> > is an issue of arm only?
> 
> No both ARM and x86 are affected. Harry and/or Peter should be able to
> comment on the details.

I've definitely seen an x86 machine with this issue - Michael Kinney has
given me firmware for a MinnowBoard-MAX that results in having this
issue.  I'm don't recall if the image was in boot services memory or
not, but if we need I can test it tomorrow (I'm at my desk at work, it's
at my desk at home.)  In any case, whether or not it was clobbered
seemed to be mostly about the interaction between the memory layout the
firmware picked and luck on the order of what we allocate in kernel.

-- 
  Peter
