From: Shiju Jose <shiju.jose@huawei.com>
Subject: RE: [RFC PATCH V1 v4.10-rc3 1/1] acpi: apei: handle GSIV
 notification type
Date: Thu, 2 Mar 2017 13:45:51 +0000
Message-ID: <86258A5CC0A3704780874CF6004BA8A62DCAC378@lhreml502-mbs>
References: <86258A5CC0A3704780874CF6004BA8A62DCAB57E@lhreml502-mbs>
 <58B579A1.90109@arm.com> <43507f99-d80b-6409-d249-b9b18425a1da@linaro.org>
 <58B6FF09.6030306@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <58B6FF09.6030306@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, Hanjun Guo <hanjun.guo@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "fu.wei@linaro.org" <fu.wei@linaro.org>, Gabriele Paoloni <gabriele.paoloni@huawei.com>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "wangxiongfeng (C)" <wangxiongfeng2@huawei.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, eun.taik.lee@sa
List-Id: linux-efi@vger.kernel.org

Hi James,

> -----Original Message-----
> From: James Morse [mailto:james.morse@arm.com]
> Sent: 01 March 2017 17:04
> To: Hanjun Guo; Shiju Jose
> Cc: christoffer.dall@linaro.org; marc.zyngier@arm.com;
> pbonzini@redhat.com; rkrcmar@redhat.com; linux@armlinux.org.uk;
> catalin.marinas@arm.com; will.deacon@arm.com; rjw@rjwysocki.net;
> lenb@kernel.org; matt@codeblueprint.co.uk; robert.moore@intel.com;
> lv.zheng@intel.com; nkaje@codeaurora.org; zjzhang@codeaurora.org;
> mark.rutland@arm.com; akpm@linux-foundation.org;
> eun.taik.lee@samsung.com; sandeepa.s.prabhu@gmail.com;
> labbott@redhat.com; shijie.huang@arm.com; rruigrok@codeaurora.org;
> paul.gortmaker@windriver.com; tn@semihalf.com; fu.wei@linaro.org;
> rostedt@goodmis.org; bristot@redhat.com; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> acpi@vger.kernel.org; linux-efi@vger.kernel.org; devel@acpica.org;
> Suzuki.Poulose@arm.com; punit.agrawal@arm.com; astone@redhat.com;
> harba@codeaurora.org; Tyler Baicar; joe@perches.com; John Garry;
> Gabriele Paoloni; Guohanjun (Hanjun Guo); wangxiongfeng (C); Zhengqiang
> (turing)
> Subject: Re: [RFC PATCH V1 v4.10-rc3 1/1] acpi: apei: handle GSIV
> notification type
> 
> Hi Hanjun,
> 
> On 01/03/17 08:27, Hanjun Guo wrote:
> > On 2017/2/28 21:22, James Morse wrote:
> >> On 27/02/17 18:19, Shiju Jose wrote:
> >>> Add a new GHES error source handling function for GSIV(Global
> System
> >>> Interrupt Vector).
> >>> If an error source's notification type is GSIV, then this handling
> >>> function can be registered into the GSIV handler and it can parse
> >>> and report error information when they occur.
> >>
> >> I'm missing some of the story here, but how is GSIV different from
> >> 'External Interrupt'? I'm guessing something other than the CPU
> takes this 'interrupt'...
> >
> > Yes, it's the same from CPU side (they are interrupts!), but there is
> > history behind them and the usage is different.
> >
> > I think External Interrupt was introduced before ACPI is available on
> > ARM (hardware reduced platforms), so I guess it was used for errors
> > reported to OS which were not using SCI mechanism, for example, some
> > IO error reporting.
> >
> > For External Interrupt, we don't use the ACPI event system, so for
> the
> > firmware, it just report the errors associate with the interrupt
> > number, the kernel map the interrupt number and install the irq
> > handler for it.
> >
> > For GSIV based event, it was introduced for hardware reduced platform
> > in recent ACPI revision, and ARM64 is one of its consumers. When
> > errors are reported via GSIV, ACPI event notification needs to be
> > implemented and requires the platform to define a hardware error
> > device
> > (PNP0C33) in ACPI namespace, and also a generic event device ACPI0013.
> 
> Okay, so for APEI this really means PNP0C33 was Notify()d. 'SCI' means
> the same but the route they take to get into APEI is different.
> 
> 
> > For example, if we are using SPI (ARM GIC) 100 to report errors,
> there
> > is a ACPI0013 driver in drivers/acpi/evged.c to register the irq,
> when
> 
> Aha, this is where the interrupt-magic happens.
> 
> 
> > error happened and trigger the interrupt, ACPI0013 driver will notify
> > the error device (PNP0C33), then error device driver
> > (drivers/acpi/hed.c) will process the error data form APEI table...
> 
> 
> >> The GHES GSIV code below is identical to the behaviour of the SCI
> >> Notification type... are these two names for the same thing? (I'm
> >> confused!)
> >
> > SCI is also an 'interrupt' but it's a special irq number for ACPI
> > event, and it has GPE (general purpose event) registers behind it,
> > which is used only on Intel platforms. SCI based event use
> > Method(\_GPE._L0x) to notify the error device (PNP0C33), but GSIV is
> > used for HW-reduced platform which has no GPEs.
> 
> > Hope it can clarify something :)
> 
> Yes thanks! (the mist is slowly clearing...)
> 
> If ACPI_HEST_NOTIFY_SCI and ACPI_HEST_NOTIFY_GSIV both mean 'receive
> notification from PNP0C33', is there any point having separate lists
> and add/remove functions for them?
> 
> Instead, could we rename Linux's ghes_notifier_sci() and ghes_sci list
> to describe 'hed' instead, then group the two case statements together?
> There would be no need to add a selectable CONFIG_ACPI_APEI_GSIV, as
> SCI is already built-in and this way the code added is tiny. The only
> thing we would lose is the name 'GSIV' in the not-supported error
> message which we don't need if its always supported.

This method was tested ok. However we were not sure about reusing/changing the 
existing ghes_notifier_sci() for gsiv will be accepted. 
Thus added a separate handling function ghes_notifier_gsiv() for gsiv.       

Thanks,
Shiju
> 
> 
> Thanks,
> 
> James
