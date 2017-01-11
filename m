From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 8/8] efi: Add EFI_SECURE_BOOT bit [ver #6]
Date: Wed, 11 Jan 2017 14:51:38 +0000
Message-ID: <20170111145138.GB29649@codeblueprint.co.uk>
References: <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
 <148120026820.5854.13036556358308461345.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148120026820.5854.13036556358308461345.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Thu, 08 Dec, at 12:31:08PM, David Howells wrote:
> From: Josh Boyer <jwboyer@fedoraproject.org>
> 
> UEFI machines can be booted in Secure Boot mode.  Add a EFI_SECURE_BOOT bit
> that can be passed to efi_enabled() to find out whether secure boot is
> enabled.
> 
> This will be used by the SysRq+x handler, registered by the x86 arch, to find
> out whether secure boot mode is enabled so that it can be disabled.
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  arch/x86/kernel/setup.c |   15 +++++++++++++++
>  include/linux/efi.h     |    1 +
>  2 files changed, 16 insertions(+)

Before we add more efi.flags bits I'd like this series to include the
patch that makes use of EFI_SECURE_BOOT. Alternatively, you move this
last patch to a new series.
