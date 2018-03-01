From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: Re: [PATCH 0/2] ESRT fixes for relocatable kexec'd kernel
Date: Thu, 1 Mar 2018 11:50:28 +0900
Message-ID: <20180301025026.GK6019@linaro.org>
References: <1519414953-5478-1-git-send-email-tbaicar@codeaurora.org>
 <20180228061901.GJ6019@linaro.org>
 <1f03865f-2d22-8ba1-a276-a6b49d7c14de@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1f03865f-2d22-8ba1-a276-a6b49d7c14de@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeffrey Hugo <jhugo@codeaurora.org>
Cc: Tyler Baicar <tbaicar@codeaurora.org>, ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, sgoel@codeaurora.org, timur@codeaurora.org
List-Id: linux-efi@vger.kernel.org

Hi,

On Wed, Feb 28, 2018 at 08:39:42AM -0700, Jeffrey Hugo wrote:
> On 2/27/2018 11:19 PM, AKASHI Takahiro wrote:
> >Tyler,
> >
> ># I missed catching your patch as its subject doesn't contain arm64.
> >
> >On Fri, Feb 23, 2018 at 12:42:31PM -0700, Tyler Baicar wrote:
> >>Currently on arm64 ESRT memory does not appear to be properly blocked off.
> >>Upon successful initialization, ESRT prints out the memory region that it
> >>exists in like:
> >>
> >>esrt: Reserving ESRT space from 0x000000000a4c1c18 to 0x000000000a4c1cf0.
> >>
> >>But then by dumping /proc/iomem this region appears as part of System RAM
> >>rather than being reserved:
> >>
> >>08f10000-0deeffff : System RAM
> >>
> >>This causes issues when trying to kexec if the kernel is relocatable. When
> >>kexec tries to execute, this memory can be selected to relocate the kernel to
> >>which then overwrites all the ESRT information. Then when the kexec'd kernel
> >>tries to initialize ESRT, it doesn't recognize the ESRT version number and
> >>just returns from efi_esrt_init().
> >
> >I'm not sure what is the root cause of your problem.
> >Do you have good confidence that the kernel (2nd kernel image in this case?)
> >really overwrite ESRT region?
> 
> According to my debug, yes.
> Using JTAG, I was able to determine that the ESRT memory region was getting
> overwritten by the secondary kernel in
> kernel/arch/arm64/kernel/relocate_kernel.S - specifically the "copy_page"
> line of arm64_relocate_new_kernel()
> 
> >To my best knowledge, kexec is carefully designed not to do such a thing
> >as it allocates a temporary buffer for kernel image and copies it to the
> >final destination at the very end of the 1st kernel.
> >
> >My guess is that kexec, or rather kexec-tools, tries to load the kernel image
> >at 0x8f80000 (or 0x9080000?, not sure) in your case. It may or may not be
> >overlapped with ESRT.
> >(Try "-d" option when executing kexec command for confirmation.)
> 
> With -d, I see
> 
> get_memory_ranges_iomem_cb: 0000000009611000 - 000000000e5fffff : System RAM
> 
> That overlaps the ESRT reservation -
> [ 0.000000] esrt: Reserving ESRT space from 0x000000000b708718 to
> 0x000000000b7087f0
> 
> >
> >Are you using initrd with kexec?
> 
> Yes

To make the things clear, can you show me, if possible, the followings:
* dmesg
* /proc/iomem
* the output from "kexec -d", particularly the last part like
    kexec_load: entry = 0x411d7660 flags = 0xb70000
    nr_segments = 3
    segment[0].buf   = 0xffff86613010
    segment[0].bufsz = 0x10e9b48
    segment[0].mem   = 0x40080000
    segment[0].memsz = 0x1156000
    segment[1].buf   = 0xffff86211010
    segment[1].bufsz = 0x20e
    segment[1].mem   = 0x411d6000
    segment[1].memsz = 0x1000
    segment[2].buf   = 0x5045420
    segment[2].bufsz = 0x31b8
    segment[2].mem   = 0x411d7000
    segment[2].memsz = 0x4000

Thanks,
-Takahiro AKASHI

> >
> >Thanks,
> >-Takahiro AKASHI
> >
> >
> >>This causes an early ioremap leak because
> >>the memory allocated for 'va' is never unmapped. So first fix that error
> >>case to properly unmap 'va' before returning.
> >>
> >>This still leaves ESRT unable to initialize in the kexec'd kernel, so now
> >>mark the ESRT memory block as nomap so that this memory is not treated as
> >>System RAM. With this change I'm able to see that the ESRT data is not
> >>overwritten when running a kexec'd kernel.
> >>
> >>Tyler Baicar (2):
> >>   efi/esrt: fix unsupported version initialization failure
> >>   efi/esrt: mark ESRT memory region as nomap
> >>
> >>  drivers/firmware/efi/esrt.c | 10 +++++++++-
> >>  1 file changed, 9 insertions(+), 1 deletion(-)
> >>
> >>-- 
> >>Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
> >>Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
> >>a Linux Foundation Collaborative Project.
> >>
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> -- 
> Jeffrey Hugo
> Qualcomm Datacenter Technologies as an affiliate of Qualcomm Technologies,
> Inc.
> Qualcomm Technologies, Inc. is a member of the
> Code Aurora Forum, a Linux Foundation Collaborative Project.
