From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH V17 00/11] Add UEFI 2.6 and ACPI 6.1 updates for RAS on
 ARM64
Date: Wed, 7 Jun 2017 12:50:12 +0100
Message-ID: <20170607115012.GZ30263@arm.com>
References: <1495225933-4410-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1495225933-4410-1-git-send-email-tbaicar@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, Suzuki.Poulose@arm.
List-Id: linux-efi@vger.kernel.org

On Fri, May 19, 2017 at 02:32:02PM -0600, Tyler Baicar wrote:
> When a memory error, CPU error, PCIe error, or other type of hardware error
> that's covered by RAS occurs, firmware should populate the shared GHES memory
> location with the proper GHES structures to notify the OS of the error.
> For example, platforms that implement firmware first handling may implement
> separate GHES sources for corrected errors and uncorrected errors. If the
> error is an uncorrectable error, then the firmware will notify the OS
> immediately since the error needs to be handled ASAP. The OS will then be able
> to take the appropriate action needed such as offlining a page. If the error
> is a corrected error, then the firmware will not interrupt the OS immediately.
> Instead, the OS will see and report the error the next time it's GHES timer
> expires. The kernel will first parse the GHES structures and report the errors
> through the kernel logs and then notify the user space through RAS trace
> events. This allows user space applications such as RAS Daemon to see the
> errors and report them however the user desires. This patchset extends the
> kernel functionality for RAS errors based on updates in the UEFI 2.6 and
> ACPI 6.1 specifications.

Thanks, I've pushed this out as:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/ras-apei

which I'll merge into for-next/core (and therefore linux-next) either the
end of this week or the beginning of next week. Please take a look if you
get a chance.

Will
