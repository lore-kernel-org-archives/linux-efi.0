From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH V3 02/10] ras: acpi/apei: cper: generic error data entry
 v3 per ACPI 6.1
Date: Fri, 14 Oct 2016 17:39:29 +0100
Message-ID: <20161014163928.GA25194@leverpostej>
References: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
 <1475875882-2604-3-git-send-email-tbaicar@codeaurora.org>
 <3f17d0a8-6b63-5792-903a-341effaae432@arm.com>
 <c17a0c03-5037-d88d-f096-4cc72dbfcb99@codeaurora.org>
 <064dca7d-0625-c0d0-09ae-72ef7abdc63f@arm.com>
 <912acc88-fbaf-2576-8048-1fcc67439600@codeaurora.org>
 <38c7c9ac-e8ad-6fb5-3ee9-3ba85e4b8299@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <38c7c9ac-e8ad-6fb5-3ee9-3ba85e4b8299@arm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: "Baicar, Tyler" <tbaicar@codeaurora.org>, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, james.morse@arm.com, akpm@linux-foundation.org, sandeepa.s.prabhu@gmail.com, shijie.huang@arm.com, paul.gortmaker@windriver.com, tomasz.nowicki@linaro.org, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Dkvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, Richard
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 14, 2016 at 05:28:58PM +0100, Suzuki K Poulose wrote:
> On 13/10/16 20:37, Baicar, Tyler wrote:
> >On 10/13/2016 2:50 AM, Suzuki K Poulose wrote:
> >>Is it always the same endianness as that of the CPU ?
> >
> >It is a fair assumption that the firmware populating this record will
> >use a CPU of the same endianness. There is no mechanism in the spec
> >to indicate otherwise.
> 
> Yep, you are right. The EFI expects the EL2/EL1 to be of the same endianness

To be clear, it is specifically required in the ACPI spec that elements
are in little-endian. Per the ACPI 6.1 spec, page 109:

	All numeric values in ACPI-defined tables, blocks, and
	structures are always encoded in little endian
	format.

Given that CPER, HEST, etc are defined within the ACPI specification,
they are covered by this requirement.

Elements outside of the ACPI spec are not necessarily covered by this
requirement, but their specifications should state their endianness.

Thanks,
Mark.
