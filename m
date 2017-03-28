From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH V13 10/10] arm/arm64: KVM: add guest SEA support
Date: Tue, 28 Mar 2017 12:19:43 +0800
Message-ID: <734ab018-2112-eddf-10dc-426f8ebe3848@huawei.com>
References: <1490136425-4324-1-git-send-email-tbaicar@codeaurora.org>
 <1490136425-4324-11-git-send-email-tbaicar@codeaurora.org>
 <20170324160158.GH25903@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170324160158.GH25903@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, Tyler Baicar <tbaicar@codeaurora.org>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kern
List-Id: linux-efi@vger.kernel.org

Hi Tyler,

I have a question for below code.

On 2017/3/25 0:01, Christoffer Dall wrote:
>  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
> -	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu))) {
> +	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu)) && sea_status) {
>  		kvm_inject_vabt(vcpu);
when it is SEA synchronized abort, why here inject a asynchronous abort through kvm_inject_vabt(vcpu) instead of synchronized abort? seem the original kvm source code is also do that, so I am confused about that.
thanks .

>  		return 1;
>  	}
