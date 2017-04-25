From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V15 04/11] efi: parse ARM processor error
Date: Tue, 25 Apr 2017 18:31:01 +0200
Message-ID: <20170425163101.oygshqqz2ik6te3f@pd.tnic>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org>
 <1492556723-9189-5-git-send-email-tbaicar@codeaurora.org>
 <20170421175527.fjwnqd22jz7br5yu@pd.tnic>
 <e54c9893-446f-9e77-b78b-2548d394719b@codeaurora.org>
 <20170424175240.3nvhbxzwicxnk6og@pd.tnic>
 <b39e05d4-fcec-ec26-5aa9-895655eb513c@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <b39e05d4-fcec-ec26-5aa9-895655eb513c@codeaurora.org>
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
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, rafael@kernel.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, tony.luck@intel.com, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawe
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 25, 2017 at 10:05:31AM -0600, Baicar, Tyler wrote:
> That seems like something that should be done outside of these patches (if
> added to the kernel at all). The decoding for this information would all be
> vendor specific, so I'm not sure if we want to pollute the EFI code with
> vendor specific error decoding. Currently we are using the RAS Daemon user
> space tool for the decoding of this information since vendors can easily
> pick up this tool and add an extension for their vendor specific parsing.
> These prints will only happen when the firmware supports the vendor specific
> error information anyway.

The same questions apply here: what do you do if the machine panics
because the error is fatal and you can't get it to run any userspace?
Wouldn't it be good to decode the whole error?

Right now we photograph screens on Intel x86 and feed the typed MCA info
by hand to mcelog. Hardly an optimal situation.

On AMD, there's a decoder which actually can dump the decoded critical
error. (Or could - that's in flux again :-\).

So yes, if stuff is too vendor-specific then you probably don't
want to decode it (or add a vendor-specific decoding module like
edac_mce_amd.ko, for example). But the tables from the UEFI spec,
documenting IP-specific error types which should be valid for most if
not all ARM64 implementations adhering to the spec, would be useful to
decode.

In general, the more we can decode the error in the kernel and the less
we need an external help to do so, the better.

Thanks.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
