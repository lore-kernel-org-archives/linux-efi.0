From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V15 11/11] arm/arm64: KVM: add guest SEA support
Date: Mon, 8 May 2017 22:22:14 +0200
Message-ID: <20170508202214.gmfy27d6ypv6af4n@pd.tnic>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org>
 <1492556723-9189-12-git-send-email-tbaicar@codeaurora.org>
 <20170508174058.5hbujeblxq5z6iwa@pd.tnic>
 <dade63eb-b231-d7a5-f307-9737d7b088f2@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <dade63eb-b231-d7a5-f307-9737d7b088f2@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Baicar, Tyler" <tbaicar@codeaurora.org>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, rafael@kernel.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, tony.luck@intel.com, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com
List-Id: linux-efi@vger.kernel.org

On Mon, May 08, 2017 at 01:54:44PM -0600, Baicar, Tyler wrote:
> This was discussed in the v12 and v13 patch series. There is existing
> code in kvm_handle_guest_abort for injecting an abort back into the
> guest. We only want to do that if it was an abort that was not handled
> by the firmware first handling. So here we verify that at least one of
> the SEA error sources successfully reported an error record sent from
> the firmware. If there were no errors reported by firmware, then we
> want to continue with the current implementation that will inject the
> virtual abort. (kvm_inject_vabt)

So this needs to be in a comment there. This is generic code in the
sense that it is in drivers/acpi/ and it should say why it is doing that
special thing. I know, SEA is ARM-only, as far as I'm gathering from
reviewing this, but this behavior needs to be documented as it is not
obvious.

Thanks.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
