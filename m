From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v1 24/28] KVM: SVM: add SEV_LAUNCH_FINISH command
Date: Thu, 13 Oct 2016 13:16:33 +0200
Message-ID: <b7c63f07-7056-30db-0cd0-d103d51c4ff2@redhat.com>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190853894.9523.16890031242057232592.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <147190853894.9523.16890031242057232592.stgit@brijesh-build-machine>
Sender: owner-linux-mm@kvack.org
To: Brijesh Singh <brijesh.singh@amd.com>, simon.guinot@sequanux.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk, linus.walleij@linaro.org, linux-mm@kvack.org, paul.gortmaker@windriver.com, hpa@zytor.com, dan.j.williams@intel.com, aarcange@redhat.com, sfr@canb.auug.org.au, andriy.shevchenko@linux.intel.com, herbert@gondor.apana.org.au, bhe@redhat.com, xemul@parallels.com, joro@8bytes.org, x86@kernel.org, mingo@redhat.com, msalter@redhat.com, ross.zwisler@linux.intel.com, bp@suse.de, dyoung@redhat.com, thomas.lendacky@amd.com, jroedel@suse.de, keescook@chromium.org, toshi.kani@hpe.com, mathieu.desnoyers@efficios.com, devel@linuxdriverproject.org, tglx@linutronix.de, mchehab@kernel.org, iamjoonsoo.kim@lge.com, labbott@fedoraproject.org, tony.luck@intel.com
List-Id: linux-efi@vger.kernel.org



On 23/08/2016 01:28, Brijesh Singh wrote:
> +
> +	/* Iterate through each vcpus and set SEV KVM_SEV_FEATURE bit in
> +	 * KVM_CPUID_FEATURE to indicate that SEV is enabled on this vcpu
> +	 */
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		svm_cpuid_update(vcpu);
> +

Do you need another call to sev_init_vmcb here?

Paolo

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
