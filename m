From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH V4 0/3] Use mm_struct and switch_mm() instead of manually
Date: Fri, 26 Jan 2018 21:16:43 +0000
Message-ID: <20180126211643.GB6520@codeblueprint.co.uk>
References: <1516309264-23926-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516309264-23926-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Andy Lutomirski <luto@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ravi Shankar <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 18 Jan, at 01:01:04PM, Sai Praneeth Prakhya wrote:
> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
> 
> Presently, in x86, to invoke any efi function like
> efi_set_virtual_address_map() or any efi_runtime_service() the code path
> typically involves read_cr3() (save previous pgd), write_cr3()
> (write efi_pgd) and calling efi function. Likewise after returning from
> efi function the code path typically involves read_cr3() (save efi_pgd),
> write_cr3() (write previous pgd). We do this couple of times in efi
> subsystem of Linux kernel, instead we can use helper function
> efi_switch_mm() to do this. This improves readability and maintainability.
> Also, instead of maintaining a separate struct "efi_scratch" to store/restore
> efi_pgd, we can use mm_struct to do this.
 
FWIW this series looks OK to me.

Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
