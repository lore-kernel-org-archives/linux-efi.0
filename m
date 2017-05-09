From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 3/3] arm/arm64: signal SIBGUS and inject SEA Error
Date: Tue, 09 May 2017 15:28:20 +0100
Message-ID: <5911D204.7020304@arm.com>
References: <CAMj-D2BGTDKpOcMu2ip41_MTTj8VDwvs59Ds7yvLHcD8PeQzhg@mail.gmail.com> <5910AAA2.4030304@arm.com> <20170508175416.GA32234@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20170508175416.GA32234@cbox>
Sender: linux-acpi-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: gengdongjiu <gengdj.1984@gmail.com>, Tyler Baicar <tbaicar@codeaurora.org>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, Len Brown <lenb@kernel.org>, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, Sandeepa Prabhu <sandeepa.s.prabhu@gmail.com>, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, Fu Wei <fu.wei@linaro.org>, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Hi Christoffer,

On 08/05/17 18:54, Christoffer Dall wrote:
> On Mon, May 08, 2017 at 06:28:02PM +0100, James Morse wrote:
> I must admit I am losing track of exactly what this proposed API was
> supposed to do.

There are two, and we keep jumping between them!
This is about two notification methods APEI has for arm64, 'SEA' and 'SEI'.

SEA is synchronous and looks like a data abort. Qemu/kvmtool can inject these
today using the KVM_GET/SET_ONE_REG API whenever it wants to.

SEI uses SError, is asynchronous and can be masked. In addition these need to be
consumed/synchronised by the ESB instruction, even when executed by a guest.
Hardware has the necessary bits to drive all this, we need to expose an API to
drive it.

(I try to spell them out each time so I don't confuse SEI with something
synchronous!)


This patch was about SEA. I think you've answered our question:

> However, if it's a question about setting up VCPU registers to a certain
> state and potentially modifying memory, then I think experience has
> shown us (psci) that emulating something in the kernel that userspace
> can have fine-grained control over is a bad idea, and should be left to
> userspace using as generic APIs as possible.
> 
> Furthermore, if I understand what injecting a SEA requires, it is very
> similar to resetting the CPU and loading data into guest memory, which
> QEMU already does today, and there is no reason to introduce additional
> APIs if it can be done using KVM_GET/SET_ONE_REG ioctls.


Thanks,

James
