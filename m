From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 2/2] arm64: Add software workaround for Falkor erratum
 1041
Date: Fri, 1 Dec 2017 11:24:58 +0000
Message-ID: <20171201112457.GE18083@arm.com>
References: <1511824680-16397-1-git-send-email-shankerd@codeaurora.org>
 <1511824680-16397-3-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1511824680-16397-3-git-send-email-shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 27, 2017 at 05:18:00PM -0600, Shanker Donthineni wrote:
> The ARM architecture defines the memory locations that are permitted
> to be accessed as the result of a speculative instruction fetch from
> an exception level for which all stages of translation are disabled.
> Specifically, the core is permitted to speculatively fetch from the
> 4KB region containing the current program counter 4K and next 4K.
> 
> When translation is changed from enabled to disabled for the running
> exception level (SCTLR_ELn[M] changed from a value of 1 to 0), the
> Falkor core may errantly speculatively access memory locations outside
> of the 4KB region permitted by the architecture. The errant memory
> access may lead to one of the following unexpected behaviors.
> 
> 1) A System Error Interrupt (SEI) being raised by the Falkor core due
>    to the errant memory access attempting to access a region of memory
>    that is protected by a slave-side memory protection unit.
> 2) Unpredictable device behavior due to a speculative read from device
>    memory. This behavior may only occur if the instruction cache is
>    disabled prior to or coincident with translation being changed from
>    enabled to disabled.
> 
> The conditions leading to this erratum will not occur when either of the
> following occur:
>  1) A higher exception level disables translation of a lower exception level
>    (e.g. EL2 changing SCTLR_EL1[M] from a value of 1 to 0).
>  2) An exception level disabling its stage-1 translation if its stage-2
>     translation is enabled (e.g. EL1 changing SCTLR_EL1[M] from a value of 1
>     to 0 when HCR_EL2[VM] has a value of 1).
> 
> To avoid the errant behavior, software must execute an ISB immediately
> prior to executing the MSR that will change SCTLR_ELn[M] from 1 to 0.
> 
> Signed-off-by: Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
> Changes since v3:
>   Rebased to kernel v4.15-rc1.
> Changes since v2:
>   Repost the corrected patches.
> Changes since v1:
>   Apply the workaround where it's required.
> 
>  Documentation/arm64/silicon-errata.txt |  1 +
>  arch/arm64/Kconfig                     | 12 +++++++++++-
>  arch/arm64/include/asm/assembler.h     | 19 +++++++++++++++++++
>  arch/arm64/include/asm/cpucaps.h       |  3 ++-
>  arch/arm64/kernel/cpu-reset.S          |  1 +
>  arch/arm64/kernel/cpu_errata.c         | 16 ++++++++++++++++
>  arch/arm64/kernel/efi-entry.S          |  2 ++
>  arch/arm64/kernel/head.S               |  1 +
>  arch/arm64/kernel/relocate_kernel.S    |  1 +
>  arch/arm64/kvm/hyp-init.S              |  1 +

This is an awful lot of code just to add an ISB instruction prior to
disabling the MMU. Why do you need to go through the alternatives framework
for this? Just do it with an #ifdef; this isn't a fastpath.

Will
