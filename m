From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v1 22/28] KVM: SVM: add SEV launch start command
Date: Thu, 13 Oct 2016 13:12:07 +0200
Message-ID: <96cd2384-e173-09a7-dca5-f6d3b6d11863@redhat.com>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190850830.9523.15876380749386321765.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <147190850830.9523.15876380749386321765.stgit@brijesh-build-machine>
Sender: owner-linux-mm@kvack.org
To: Brijesh Singh <brijesh.singh@amd.com>, simon.guinot@sequanux.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk, linus.walleij@linaro.org, linux-mm@kvack.org, paul.gortmaker@windriver.com, hpa@zytor.com, dan.j.williams@intel.com, aarcange@redhat.com, sfr@canb.auug.org.au, andriy.shevchenko@linux.intel.com, herbert@gondor.apana.org.au, bhe@redhat.com, xemul@parallels.com, joro@8bytes.org, x86@kernel.org, mingo@redhat.com, msalter@redhat.com, ross.zwisler@linux.intel.com, bp@suse.de, dyoung@redhat.com, thomas.lendacky@amd.com, jroedel@suse.de, keescook@chromium.org, toshi.kani@hpe.com, mathieu.desnoyers@efficios.com, devel@linuxdriverproject.org, tglx@linutronix.de, mchehab@kernel.org, iamjoonsoo.kim@lge.com, labbott@fedoraproject.org, tony.luck@intel.com
List-Id: linux-efi@vger.kernel.org



On 23/08/2016 01:28, Brijesh Singh wrote:
> +static int sev_launch_start(struct kvm *kvm,
> +			    struct kvm_sev_launch_start __user *arg,
> +			    int *psp_ret)
> +{
> +	int ret, asid;
> +	struct kvm_sev_launch_start params;
> +	struct psp_data_launch_start *start;
> +
> +	/* Get parameter from the user */
> +	if (copy_from_user(&params, arg, sizeof(*arg)))
> +		return -EFAULT;
> +
> +	start = kzalloc(sizeof(*start), GFP_KERNEL);
> +	if (!start)
> +		return -ENOMEM;
> +
> +	ret = sev_pre_start(kvm, &asid);

You need some locking in sev_asid_{new,free}.  Probably &kvm_lock.  The
SEV_ISSUE_CMD ioctl instead should take &kvm->lock.

Paolo

> +	if (ret)
> +		goto err_1;
> +
> +	start->hdr.buffer_len = sizeof(*start);
> +	start->flags  = params.flags;
> +	start->policy = params.policy;
> +	start->handle = params.handle;
> +	memcpy(start->nonce, &params.nonce, sizeof(start->nonce));
> +	memcpy(start->dh_pub_qx, &params.dh_pub_qx, sizeof(start->dh_pub_qx));
> +	memcpy(start->dh_pub_qy, &params.dh_pub_qy, sizeof(start->dh_pub_qy));
> +
> +	/* launch start */
> +	ret = psp_guest_launch_start(start, psp_ret);
> +	if (ret) {
> +		printk(KERN_ERR "SEV: LAUNCH_START ret=%d (%#010x)\n",
> +			ret, *psp_ret);
> +		goto err_2;
> +	}
> +
> +	ret = sev_post_start(kvm, asid, start->handle, psp_ret);
> +	if (ret)
> +		goto err_2;

Paolo

> +	kfree(start);
> +	return 0;
> +
> +err_2:
> +	sev_asid_free(asid);
> +err_1:
> +	kfree(start);
> +	return ret;
> +}
> +
> +static int amd_sev_issue_cmd(struct kvm *kvm,
> +			     struct kvm_sev_issue_cmd __user *user_data)
> +{
> +	int r = -ENOTTY;
> +	struct kvm_sev_issue_cmd arg;
> +
> +	if (copy_from_user(&arg, user_data, sizeof(struct kvm_sev_issue_cmd)))
> +		return -EFAULT;
> +
> +	switch (arg.cmd) {
> +	case KVM_SEV_LAUNCH_START: {
> +		r = sev_launch_start(kvm, (void *)arg.opaque,
> +					&arg.ret_code);
> +		break;
> +	}
> +	default:
> +		break;
> +	}
> +
> +	if (copy_to_user(user_data, &arg, sizeof(struct kvm_sev_issue_cmd)))
> +		r = -EFAULT;
> +	return r;
> +}
> +
>  static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  	.cpu_has_kvm_support = has_svm,
>  	.disabled_by_bios = is_disabled,
> @@ -5313,6 +5517,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  
>  	.pmu_ops = &amd_pmu_ops,
>  	.deliver_posted_interrupt = svm_deliver_avic_intr,
> +
> +	.sev_issue_cmd = amd_sev_issue_cmd,
>  };
>  
>  static int __init svm_init(void)
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
