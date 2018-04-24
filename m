From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v3 2/5] efi: Add embedded peripheral firmware support
Date: Tue, 24 Apr 2018 23:42:19 +0000
Message-ID: <20180424234219.GX14440@wotan.suse.de>
References: <20180408174014.21908-1-hdegoede@redhat.com>
 <20180408174014.21908-3-hdegoede@redhat.com>
 <20180423211143.GZ14440@wotan.suse.de>
 <71e6a45a-398d-b7a4-dab0-8b9936683226@redhat.com>
 <1524586021.3364.20.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1524586021.3364.20.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>, Alan Cox <alan@linux.intel.com>, Kees Cook <keescook@chromium.org>
Cc: Hans de Goede <hdegoede@redhat.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@br>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 24, 2018 at 12:07:01PM -0400, Mimi Zohar wrote:
> On Tue, 2018-04-24 at 17:09 +0200, Hans de Goede wrote:
> > Hi,
> > 
> > On 23-04-18 23:11, Luis R. Rodriguez wrote:
> > > Hans, please see use of READING_FIRMWARE_PREALLOC_BUFFER, we'll need a new ID
> > > and security for this type of request so IMA can reject it if the policy is
> > > configured for it.
> > 
> > Hmm, interesting, actually it seems like the whole existence
> > of READING_FIRMWARE_PREALLOC_BUFFER is a mistake, 

request_firmware_into_buf() was merged without my own review, however,
the ID thing did get review from Mimi:

https://patchwork.kernel.org/patch/9074611/

The ID is not for IMA alone, its for any LSM to decide what to do.
Note Mimi asked for READING_FIRMWARE_DMA if such buffer was in DMA,
otherise READING_FIRMWARE_PREALLOC_BUFFER was suggested.

> > the IMA
> > framework really does not care if we are loading the firmware
> > into memory allocated by the firmware-loader code, or into
> > memory allocated by the device-driver requesting the firmware.

That's up to LSM folks to decide. We have these so far:

#define __kernel_read_file_id(id) \                                             
        id(UNKNOWN, unknown)            \                                       
        id(FIRMWARE, firmware)          \                                       
        id(FIRMWARE_PREALLOC_BUFFER, firmware)  \                               
        id(MODULE, kernel-module)               \                               
        id(KEXEC_IMAGE, kexec-image)            \                               
        id(KEXEC_INITRAMFS, kexec-initramfs)    \                               
        id(POLICY, security-policy)             \                               
        id(X509_CERTIFICATE, x509-certificate)  \                               
        id(MAX_ID, )  

The first type of IDs added was about type of files the kernel
LSMs may want to do different things for.

Mimi why did you want a separate ID for it back before?

I should note now that request_firmware_into_buf() and its
READING_FIRMWARE_PREALLOC_BUFFER was to enable a driver on memory constrained
devices. The files are large (commit says 16 MiB).

I've heard of larger possible files with remoteproc and with Android using
the custom fallback mechanism -- which could mean a proprietary tool
fetching firmware from a random special place on a device.

I could perhaps imagine an LSM which may be aware of such type of
arrangement may want to do its own vetting of some sort, but this
would not be specific to READING_FIRMWARE_PREALLOC_BUFFER, but rather
the custom fallback mechaism.

Whether or not the buffer was preallocated by the driver seems a little
odd for security folks to do something different with it. Security LSM
folks please chime in.

I could see a bit more of a use case for an ID for firmware scraped
from EFI, which Hans' patch will provide. But that *also* should get
good review from other LSM folks.

One of the issues with accepting more IDs loosely is where do we
stop though? If no one really is using READING_FIRMWARE_PREALLOC_BUFFER
I'd say lets remove it. Likewise, for this EFI thing I'd like an idea
if we really are going to have users for it.

If its of any help --

drivers/soc/qcom/mdt_loader.c is the only driver currently using
request_firmware_into_buf() however I'll note qcom_mdt_load() is used in many
other drivers so they are wrappers around request_firmware_into_buf():

drivers/gpu/drm/msm/adreno/a5xx_gpu.c:   * adreno_request_fw() handles this, but qcom_mdt_load() does
drivers/gpu/drm/msm/adreno/a5xx_gpu.c:          ret = qcom_mdt_load(dev, fw, fwname, GPU_PAS_ID,
drivers/gpu/drm/msm/adreno/a5xx_gpu.c:          ret = qcom_mdt_load(dev, fw, newname, GPU_PAS_ID,
drivers/media/platform/qcom/venus/firmware.c:   ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID, mem_va, mem_phys,
drivers/remoteproc/qcom_adsp_pil.c:     return qcom_mdt_load(adsp->dev, fw, rproc->firmware, adsp->pas_id,
drivers/remoteproc/qcom_wcnss.c:        return qcom_mdt_load(wcnss->dev, fw, rproc->firmware, WCNSS_PAS_ID,

Are we going to add more IDs for more types of firmware?
What type of *different* decisions could LSMs take if the firmware
was being written to a buffer? Or in this new case that is coming
up, if the file came scraping EFI, would having that information
be useful?

> > As such the current IMA code (from v4.17-rc2) actually does
> > not handle READING_FIRMWARE_PREALLOC_BUFFER at all, 
> 
> Right, it doesn't yet address READING_FIRMWARE_PREALLOC_BUFFER, but
> should.
> 
> Depending on whether the device requesting the firmware has access to
> the DMA memory, before the signature verification, 

It would seem from the original patch review about READING_FIRMWARE_PREALLOC_BUFFER
that this is not a DMA buffer.

The device driver should have access to the buffer pointer with write given
that with request_firmware_into_buf() the driver is giving full write access to
the memory pointer so that the firmware API can stuff the firmware it finds
there.

Firmware signature verification would be up to the device hardware to do upon
load *after* request_firmware_into_buf().

  Luis

> will determine how
> IMA-appraisal addresses READING_FIRMWARE_PREALLOC_BUFFER.
> 
> Mimi
> 
> > here
> > are bits of code from: security/integrity/ima/ima_main.c:
> > 
> > static int read_idmap[READING_MAX_ID] = {
> >          [READING_FIRMWARE] = FIRMWARE_CHECK,
> >          [READING_MODULE] = MODULE_CHECK,
> >          [READING_KEXEC_IMAGE] = KEXEC_KERNEL_CHECK,
> >          [READING_KEXEC_INITRAMFS] = KEXEC_INITRAMFS_CHECK,
> >          [READING_POLICY] = POLICY_CHECK
> > };
> > 
> > int ima_post_read_file(struct file *file, void *buf, loff_t size,
> > 	...
> >          if (!file && read_id == READING_FIRMWARE) {
> >                  if ((ima_appraise & IMA_APPRAISE_FIRMWARE) &&
> >                      (ima_appraise & IMA_APPRAISE_ENFORCE))
> >                          return -EACCES; /* INTEGRITY_UNKNOWN */
> >                  return 0;
> >          }
> > 
> > Which show that the IMA code is not handling
> > READING_FIRMWARE_PREALLOC_BUFFER as it should (I believe it
> > should handle it the same as READING_FIRMWARE).
> > 
> > Now we could fix that, but the only user of
> > READING_FIRMWARE_PREALLOC_BUFFER is the code which originally
> > introduced it:
> > 
> > https://patchwork.kernel.org/patch/9162011/
> > 
> > So I believe it might be better to instead replace it
> > with just READING_FIRMWARE and find another way to tell
> > kernel_read_file() that there is a pre-allocated buffer,
> > perhaps the easiest way there is that  *buf must be
> > NULL when the caller wants kernel_read_file() to
> > vmalloc the mem. This would of course require auditing
> > all callers that the buf which the pass in is initialized
> > to NULL.
> > 
> > Either way adding a third READING_FIRMWARE_FOO to the
> > kernel_read_file_id enum seems like a bad idea, from
> > the IMA pov firmware is firmware.
> > 
> > What this whole exercise has shown me though is that
> > I need to call security_kernel_post_read_file() when
> > loading EFI embedded firmware. I will add a call to
> > security_kernel_post_read_file() for v4 of the patch-set.
> > 
> > > Please Cc Kees in future patches.
> > 
> > Will do.
> > 
> > Regards,
> > 
> > Hans
> > 
> 
> 

-- 
Do not panic
