From: gengdongjiu <gengdongjiu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 3/3] arm/arm64: signal SIBGUS and inject SEA Error
Date: Wed, 10 May 2017 20:37:59 +0800
Message-ID: <10cdbd75-2b89-c816-e688-91f111687819@huawei.com>
References: <CAMj-D2BGTDKpOcMu2ip41_MTTj8VDwvs59Ds7yvLHcD8PeQzhg@mail.gmail.com>
 <5910AAA2.4030304@arm.com> <20170508175416.GA32234@cbox>
 <5911D204.7020304@arm.com> <e8614b38-9c17-bcfc-2239-307ed0f98c94@huawei.com>
 <20170510122055.GE28721@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170510122055.GE28721@cbox>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, gengdongjiu <gengdj.1984-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Sandeepa Prabhu <sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, Fu Wei <fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Christoffer,

On 2017/5/10 20:20, Christoffer Dall wrote:
> On Wed, May 10, 2017 at 05:15:04PM +0800, gengdongjiu wrote:
>> Thanks James's explanation.
>>
>> Hi Christoffer,
>>
>> On 2017/5/9 22:28, James Morse wrote:
>>> Hi Christoffer,
>>>
>>> On 08/05/17 18:54, Christoffer Dall wrote:
>>>> On Mon, May 08, 2017 at 06:28:02PM +0100, James Morse wrote:
>>>> I must admit I am losing track of exactly what this proposed API was
>>>> supposed to do.
>>>
>>> There are two, and we keep jumping between them!
>>> This is about two notification methods APEI has for arm64, 'SEA' and 'SEI'.
>>>
>>> SEA is synchronous and looks like a data abort. Qemu/kvmtool can inject these
>>> today using the KVM_GET/SET_ONE_REG API whenever it wants to.
>>>
>>> SEI uses SError, is asynchronous and can be masked. In addition these need to be
>>> consumed/synchronised by the ESB instruction, even when executed by a guest.
>>> Hardware has the necessary bits to drive all this, we need to expose an API to
>>> drive it.
>>>
>>> (I try to spell them out each time so I don't confuse SEI with something
>>> synchronous!)
>>>
>>>
>>> This patch was about SEA. I think you've answered our question:
>>
>> we are talking about the SEA(synchronous data abort) injection two methods:
>>
>> (1)change vcpu registers in the Qemu/kvmtools and using the KVM_GET/SET_ONE_REG API to set.
> 
> Yes, if this is possible, why would you want something more?
  we will use this method.

> 
>> (2)using existed in-kernel API "kvm_inject_dabt" to inject through IOCTL command from Qemu.
>>
> 
> I'm not really going to consider this, because "use internal API from
> userspace" doesn't work.
> 
> So this should be:
> 
>   (2) Introduce a new API to do X.
  you can ignore the second method, now we will not use it.

> 
> I still think you know what my preference is; use the existing API if at
> all possible.
> 
> Thanks,
> -Christoffer
> 
> .
> 
