From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH V4 10/10] arm64: KVM: add guest SEA support
Date: Mon, 31 Oct 2016 10:02:07 +0000
Message-ID: <20161031100206.GX1041@n2100.armlinux.org.uk>
References: <1477071013-29563-1-git-send-email-tbaicar@codeaurora.org>
 <1477071013-29563-11-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <1477071013-29563-11-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, robert.moore@intel.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, lenb@kernel.org, harba@codeaurora.org, marc.zyngier@arm.com, punit.agrawal@arm.com, tomasz.nowicki@linaro.org, nkaje@codeaurora.org, rostedt@goodmis.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com
List-Id: linux-efi@vger.kernel.org

The subject line on this patch is misleading - it's not only ARM64
specific...

On Fri, Oct 21, 2016 at 11:30:13AM -0600, Tyler Baicar wrote:
> diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
> index a3d61ad..86e1faa 100644
> --- a/arch/arm/include/asm/system_misc.h
> +++ b/arch/arm/include/asm/system_misc.h
> @@ -24,4 +24,9 @@ extern unsigned int user_debug;
>  
>  #endif /* !__ASSEMBLY__ */
>  
> +inline int handle_guest_sea(unsigned long addr, unsigned int esr)

This needs to be static.

> +{
> +	return -1;
> +}
> +
>  #endif /* __ASM_ARM_SYSTEM_MISC_H */

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
