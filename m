From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH V17 02/11] ras: acpi/apei: cper: add support for generic
 data v3 structure
Date: Fri, 2 Jun 2017 15:13:39 +0100
Message-ID: <20170602141338.GJ6371@arm.com>
References: <1495225933-4410-1-git-send-email-tbaicar@codeaurora.org>
 <1495225933-4410-3-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1495225933-4410-3-git-send-email-tbaicar@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, Suzuki.Poulose@arm.
List-Id: linux-efi@vger.kernel.org

On Fri, May 19, 2017 at 02:32:04PM -0600, Tyler Baicar wrote:
> The ACPI 6.1 spec adds a new revision of the generic error data
> entry structure. Add support to handle the new structure as well
> as properly verify and iterate through the generic data entries.
> 
> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> CC: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> ---
>  drivers/acpi/apei/ghes.c    | 11 +++++------
>  drivers/firmware/efi/cper.c | 37 ++++++++++++++++++++++---------------
>  include/acpi/ghes.h         | 36 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 63 insertions(+), 21 deletions(-)

Given that Boris and Rafael are ok with this series, it makes sense to
take this via arm64, but I need an ack from Ard or Matt on the EFI changes
in this patch and the subsequent one.

Will
