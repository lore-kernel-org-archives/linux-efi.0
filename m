From: gengdongjiu <gengdongjiu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V13 10/10] arm/arm64: KVM: add guest SEA support
Date: Tue, 28 Mar 2017 17:53:38 +0800
Message-ID: <5c7f6092-9358-08ac-5341-2364637c2008__13308.1774031327$1490694955$gmane$org@huawei.com>
References: <1490136425-4324-1-git-send-email-tbaicar@codeaurora.org>
 <1490136425-4324-11-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490136425-4324-11-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm@vg
List-Id: linux-efi@vger.kernel.org

Hi,

On 2017/3/22 6:47, Tyler Baicar wrote:
> +	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
> +
> +	/* The host kernel will handle the synchronous external abort. There
> +	 * is no need to pass the error into the guest.
> +	 */
> +	if (is_abort_synchronous(fault_status))
> +		sea_status = handle_guest_sea((unsigned long)fault_ipa,
> +				    kvm_vcpu_get_hsr(vcpu));
>  
>  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
> -	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu))) {
> +	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu)) && sea_status) {
>  		kvm_inject_vabt(vcpu);
>  		return 1;
>  	}
       After the host kernel correctly handle the synchronous external abort, the sea_status
       will return 0, so the code logical will be continue go-no, whether it is better directly return
       after correctly handle the SEA? such as below.

	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu)) && sea_status) {
  		kvm_inject_vabt(vcpu);
  		return 1;
  	} else
                return 1;

>  
> -	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
> -
>  	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_hsr(vcpu),
>  			      kvm_vcpu_get_hfar(vcpu), fault_ipa);
>  
> -	/* Check the stage-2 fault is trans. fault or write fault */
> -	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
>  	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
