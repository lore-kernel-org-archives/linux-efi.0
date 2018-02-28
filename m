From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: Re: [PATCH 0/2] ESRT fixes for relocatable kexec'd kernel
Date: Wed, 28 Feb 2018 15:19:03 +0900
Message-ID: <20180228061901.GJ6019@linaro.org>
References: <1519414953-5478-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1519414953-5478-1-git-send-email-tbaicar@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, jhugo@codeaurora.org, sgoel@codeaurora.org, timur@codeaurora.org
List-Id: linux-efi@vger.kernel.org

Tyler,

# I missed catching your patch as its subject doesn't contain arm64.

On Fri, Feb 23, 2018 at 12:42:31PM -0700, Tyler Baicar wrote:
> Currently on arm64 ESRT memory does not appear to be properly blocked off.
> Upon successful initialization, ESRT prints out the memory region that it
> exists in like:
> 
> esrt: Reserving ESRT space from 0x000000000a4c1c18 to 0x000000000a4c1cf0.
> 
> But then by dumping /proc/iomem this region appears as part of System RAM
> rather than being reserved:
> 
> 08f10000-0deeffff : System RAM
> 
> This causes issues when trying to kexec if the kernel is relocatable. When
> kexec tries to execute, this memory can be selected to relocate the kernel to
> which then overwrites all the ESRT information. Then when the kexec'd kernel
> tries to initialize ESRT, it doesn't recognize the ESRT version number and
> just returns from efi_esrt_init().

I'm not sure what is the root cause of your problem.
Do you have good confidence that the kernel (2nd kernel image in this case?)
really overwrite ESRT region?
To my best knowledge, kexec is carefully designed not to do such a thing
as it allocates a temporary buffer for kernel image and copies it to the
final destination at the very end of the 1st kernel.

My guess is that kexec, or rather kexec-tools, tries to load the kernel image
at 0x8f80000 (or 0x9080000?, not sure) in your case. It may or may not be
overlapped with ESRT.
(Try "-d" option when executing kexec command for confirmation.)

Are you using initrd with kexec?

Thanks,
-Takahiro AKASHI


> This causes an early ioremap leak because
> the memory allocated for 'va' is never unmapped. So first fix that error
> case to properly unmap 'va' before returning.
> 
> This still leaves ESRT unable to initialize in the kexec'd kernel, so now
> mark the ESRT memory block as nomap so that this memory is not treated as
> System RAM. With this change I'm able to see that the ESRT data is not
> overwritten when running a kexec'd kernel.
> 
> Tyler Baicar (2):
>   efi/esrt: fix unsupported version initialization failure
>   efi/esrt: mark ESRT memory region as nomap
> 
>  drivers/firmware/efi/esrt.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> -- 
> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project.
> 
