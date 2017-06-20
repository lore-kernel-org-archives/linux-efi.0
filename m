From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH V17 00/11] Add UEFI 2.6 and ACPI 6.1 updates for RAS on
 ARM64
Date: Tue, 20 Jun 2017 09:49:32 +0100
Message-ID: <20170620084931.GB30664@arm.com>
References: <1495225933-4410-1-git-send-email-tbaicar@codeaurora.org>
 <20170607115012.GZ30263@arm.com>
 <20170620063439.GS658@rric.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <20170620063439.GS658@rric.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Robert Richter <robert.richter@cavium.com>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, Tyler Baicar <tbaicar@codeaurora.org>, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, rafael@kernel.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, bp@alien8.de, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, tony.luck@intel.com, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bri
List-Id: linux-efi@vger.kernel.org

Hi Robert,

On Tue, Jun 20, 2017 at 08:34:39AM +0200, Robert Richter wrote:
> On 07.06.17 12:50:12, Will Deacon wrote:
> 
> > Thanks, I've pushed this out as:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/ras-apei
> >
> > which I'll merge into for-next/core (and therefore linux-next) either the
> > end of this week or the beginning of next week. Please take a look if you
> > get a chance.
> 
> any reason why there was a roll back of for-next/core?
> 
>  + 0870f692c2ed...e27c7fa015d6 for-next/core -> arm64/for-next/core  (forced update)
> 
> Is it because for-next/ras-apei goes through tip?

No, it's because the RAS stuff ran into horrible conflicts with the UUID
tree:

https://lkml.org/lkml/2017/6/16/22

Tyler should be rebasing that soon, so hopefully I can requeue that stuff
this week.

Will
