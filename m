From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V3 2/5] efi: Introduce __efi_init attribute
Date: Tue, 4 Sep 2018 22:25:11 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485B981D@ORSMSX114.amr.corp.intel.com>
References: <1536099149-12564-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1536099149-12564-3-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536099149-12564-3-git-send-email-sai.praneeth.prakhya@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
Cc: "Neri, Ricardo" <ricardo.neri@intel.com>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Hi Boris and Ard,

> Buggy firmware could illegally access some efi regions even after the kernel has
> assumed control of the platform. When
> "CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS" is enabled, the efi page fault
> handler will detect and recover from these illegal accesses.
> efi_md_typeattr_format() and memory_type_name are used by the efi page
> fault handler to print information about memory descriptor that was illegally
> accessed. As the page fault handler is present during/after kernel boot it doesn't
> have an __init attribute, but
> efi_md_typeattr_format() has it and thus during kernel build, "WARNING:
> modpost: Found * section mismatch(es)" build warning is observed. To fix it,
> remove __init attribute for efi_md_typeattr_format().
> 
> In order to not keep efi_md_typeattr_format() and memory_type_name
> needlessly when "CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS" is not selected,
> add a new __efi_init attribute whose value changes based on whether the config
> option is selected or not.

In previous versions (i.e. up to V2), where we handled EFI_BOOT_SERVICES_<CODE/DATA> 
regions differently, it made sense to have a separate attribute like __efi_init because many 
function definitions were modified. From V3, do you think it's still OK to have __efi_init or 
should I just remove __init attribute (and not have __efi_init) for efi_md_typeattr_format() 
and memory_type_name because we are just modifying two.

Regards,
Sai
