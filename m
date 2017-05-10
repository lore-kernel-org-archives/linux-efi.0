From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 3/3] arm/arm64: signal SIBGUS and inject SEA Error
Date: Wed, 10 May 2017 14:20:55 +0200
Message-ID: <20170510122055.GE28721@cbox>
References: <CAMj-D2BGTDKpOcMu2ip41_MTTj8VDwvs59Ds7yvLHcD8PeQzhg@mail.gmail.com>
 <5910AAA2.4030304@arm.com>
 <20170508175416.GA32234@cbox>
 <5911D204.7020304@arm.com>
 <e8614b38-9c17-bcfc-2239-307ed0f98c94@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e8614b38-9c17-bcfc-2239-307ed0f98c94@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: James Morse <james.morse@arm.com>, gengdongjiu <gengdj.1984@gmail.com>, Tyler Baicar <tbaicar@codeaurora.org>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, Len Brown <lenb@kernel.org>, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, Sandeepa Prabhu <sandeepa.s.prabhu@gmail.com>, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, Fu Wei <fu.wei@linaro.org>, rostedt@goodmis.org, bristot@redhat.coml
List-Id: linux-efi@vger.kernel.org

On Wed, May 10, 2017 at 05:15:04PM +0800, gengdongjiu wrote:
> Thanks James's explanation.
> 
> Hi Christoffer,
> 
> On 2017/5/9 22:28, James Morse wrote:
> > Hi Christoffer,
> > 
> > On 08/05/17 18:54, Christoffer Dall wrote:
> >> On Mon, May 08, 2017 at 06:28:02PM +0100, James Morse wrote:
> >> I must admit I am losing track of exactly what this proposed API was
> >> supposed to do.
> > 
> > There are two, and we keep jumping between them!
> > This is about two notification methods APEI has for arm64, 'SEA' and 'SEI'.
> > 
> > SEA is synchronous and looks like a data abort. Qemu/kvmtool can inject these
> > today using the KVM_GET/SET_ONE_REG API whenever it wants to.
> > 
> > SEI uses SError, is asynchronous and can be masked. In addition these need to be
> > consumed/synchronised by the ESB instruction, even when executed by a guest.
> > Hardware has the necessary bits to drive all this, we need to expose an API to
> > drive it.
> > 
> > (I try to spell them out each time so I don't confuse SEI with something
> > synchronous!)
> > 
> > 
> > This patch was about SEA. I think you've answered our question:
> 
> we are talking about the SEA(synchronous data abort) injection two methods:
> 
> (1)change vcpu registers in the Qemu/kvmtools and using the KVM_GET/SET_ONE_REG API to set.

Yes, if this is possible, why would you want something more?

> (2)using existed in-kernel API "kvm_inject_dabt" to inject through IOCTL command from Qemu.
> 

I'm not really going to consider this, because "use internal API from
userspace" doesn't work.

So this should be:

  (2) Introduce a new API to do X.

I still think you know what my preference is; use the existing API if at
all possible.

Thanks,
-Christoffer
