From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v3 2/5] efi: Add embedded peripheral firmware support
Date: Wed, 25 Apr 2018 17:55:57 +0000
Message-ID: <20180425175557.GY14440@wotan.suse.de>
References: <20180408174014.21908-1-hdegoede@redhat.com>
 <20180408174014.21908-3-hdegoede@redhat.com>
 <20180423211143.GZ14440@wotan.suse.de>
 <71e6a45a-398d-b7a4-dab0-8b9936683226@redhat.com>
 <1524586021.3364.20.camel@linux.vnet.ibm.com>
 <20180424234219.GX14440@wotan.suse.de>
 <1524632409.3371.48.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1524632409.3371.48.camel@linux.vnet.ibm.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Stephen Boyd <sboyd@kernel.org>, Vikram Mulukutla <markivx@codeaurora.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Martijn Coenen <maco@android.com>, Todd Kjos <tkjos@android.com>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, platform-driver-x86@vger.kernel.org, David Howells <dhowells@redhat.com>, Peter Jones <pjones@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, devel@driverdev.osuosl.org, nbroeking@me.com, x86@kernel.org, linux-security-module@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@infradead.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Kees Cook <keescook@chromium.org>, linux-arm-msm@vger.kernel.org, Torsten Duwe <duwe@suse.de>, Josh Triplett <josh@joshtriplett.org>, Chris Wright <chrisw@sous-sol.org>, Hans de Goede <hdegoede@redhat.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, bjorn.andersson@linaro.org, Kalle Valo <kvalo@codeaurora.org>, Alan Cox <alan@linux.intel.com>, mfuzzey@parkeon.com, Ard
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 25, 2018 at 01:00:09AM -0400, Mimi Zohar wrote:
> On Tue, 2018-04-24 at 23:42 +0000, Luis R. Rodriguez wrote:
> > On Tue, Apr 24, 2018 at 12:07:01PM -0400, Mimi Zohar wrote:
> > > On Tue, 2018-04-24 at 17:09 +0200, Hans de Goede wrote:
> > > > On 23-04-18 23:11, Luis R. Rodriguez wrote:
> > > > > Hans, please see use of READING_FIRMWARE_PREALLOC_BUFFER, we'll n=
eed a new ID
> > > > > and security for this type of request so IMA can reject it if the=
 policy is
> > > > > configured for it.
> > > > =

> > > > Hmm, interesting, actually it seems like the whole existence
> > > > of READING_FIRMWARE_PREALLOC_BUFFER is a mistake, =

> > =

> > request_firmware_into_buf() was merged without my own review, however,
> > the ID thing did get review from Mimi:
> > =

> > https://patchwork.kernel.org/patch/9074611/
> > =

> > The ID is not for IMA alone, its for any LSM to decide what to do.
> > Note Mimi asked for READING_FIRMWARE_DMA if such buffer was in DMA,
> > otherise READING_FIRMWARE_PREALLOC_BUFFER was suggested.
> > =

> > Mimi why did you want a separate ID for it back before?
> =

> The point of commit a098ecd2fa7d ("firmware: support loading into a
> pre-allocated buffer") is to avoid reading the firmware into kernel
> memory and then copying it "to it's final resting place". =A0My concern
> is that if the device driver has access to the buffer, it could access
> the buffer prior to the firmware's signature having been verified by
> the kernel.

If request_firmware_into_buf() is used and the firmware was found in
/lib/firmware/ paths then the driver will *not* use the firmware prior
to any LSM doing any firmware signature verification because
kernel_read_file_from_path() and in turn security_kernel_read_file().

The firmware API has a fallback mechanism [0] though, and if that is used t=
hen
security_kernel_post_read_file() is used once the firmware is loaded through
the sysfs interface *prior* to handing the firmware data to the driver. As
Hans noted though security_kernel_post_read_file() currently *only* uses
READING_FIRMWARE, so this needs to be fixed. Also note though that LSMs
get a hint of what is going to happen *soon* prior to the fallback
mechanism kicking on as we travere the /lib/firmware/ paths for direct
filesystem loading.

If this is not sufficient to cover LSM appraisals *one* option could be to
have security_kernel_read_file() return a special error of some sort
for READING_FIRMWARE_PREALLOC_BUFFER so that kernel_read_file_from_path()
users could *know* to fatally give up.

Currently the device drivers using request_firmware_into_buf() can end up
getting the buffer with firmware stashed in it without having the kernel do=
 any
firmware signature verification at all through its LSMs. The LSM hooks adde=
d to
the firmware loader long ago by Kees via commit 6593d9245bc66 ("firmware_cl=
ass:
perform new LSM checks") on v3.17 added an LSM for direct filesystem lookup=
s,
but on the fallback mechanism seems to have only added a post LSM hook
security_kernel_fw_from_file().

There is also a custom fallback mechanism [1] which can be used if the path=
 to
the firmware may be out of the /lib/firmware/ paths or perhaps the firmware
requires some very custom fetching of some sort. The only thing this does
though is just *not* issue a uevent when we don't find the firmware and also
sets the timeout to a practically never-ending value. The custom fallback
mechanism is only usable for request_firmware_nowait() though. In retrospect
the custom fallback mechanism is pure crap and these days we've acknowledged
that even in crazy custom firmware fetching cases folks should be able to
accomplish this by relying on uevents and using the firmwared [2] or forking
it, or a different similar proprietary similar solution, which would just
monitor for uevents for firmware and just Do The Right Thing (TM).

Consider some mobile devices which may want to fetch it from some custom
partition which only it can know how to get.

There is a kernel config option which enables the fallback mechanism always,
This is now easily readable as follows:

drivers/base/firmware_loader/fallback_table.c

struct firmware_fallback_config fw_fallback_config =3D {
	.force_sysfs_fallback =3D IS_ENABLED(CONFIG_FW_LOADER_USER_HELPER_FALLBACK=
),
	.loading_timeout =3D 60,
	.old_timeout =3D 60,
};

Even if this is used we always do direct fs lookups first.

Android became the primary user of CONFIG_FW_LOADER_USER_HELPER_FALLBACK.

It would be good for us to hear from Android folks if their current use of
request_firmware_into_buf() is designed in practice to *never* use the dire=
ct
filesystem firmware loading interface, and always rely instead on the
fallback mechanism.

That would answer help your appraisal question in practice today.

[0] https://www.kernel.org/doc/html/latest/driver-api/firmware/fallback-mec=
hanisms.html
[1] https://www.kernel.org/doc/html/latest/driver-api/firmware/fallback-mec=
hanisms.html#firmware-custom-fallback-mechanism
[2] https://github.com/teg/firmwared

> In tightly controlled environments interested in limiting which signed
> firmware version is loaded, require's the device driver not having
> access to the buffer until after the signature has been verified by
> the kernel (eg. IMA-appraisal).

We may need more work for this for request_firmware_into_buf().

> > I should note now that request_firmware_into_buf() and its
> > READING_FIRMWARE_PREALLOC_BUFFER was to enable a driver on memory const=
rained
> > devices. The files are large (commit says 16 MiB).
> > =

> > I've heard of larger possible files with remoteproc and with Android us=
ing
> > the custom fallback mechanism -- which could mean a proprietary tool
> > fetching firmware from a random special place on a device.
> > =

> > I could perhaps imagine an LSM which may be aware of such type of
> > arrangement may want to do its own vetting of some sort, but this
> > would not be specific to READING_FIRMWARE_PREALLOC_BUFFER, but rather
> > the custom fallback mechaism.
> > =

> > Whether or not the buffer was preallocated by the driver seems a little
> > odd for security folks to do something different with it. Security LSM
> > folks please chime in.
> > =

> > I could see a bit more of a use case for an ID for firmware scraped
> > from EFI, which Hans' patch will provide. But that *also* should get
> > good review from other LSM folks.
> > =

> > One of the issues with accepting more IDs loosely is where do we
> > stop though? If no one really is using READING_FIRMWARE_PREALLOC_BUFFER
> > I'd say lets remove it. Likewise, for this EFI thing I'd like an idea
> > if we really are going to have users for it.
> > =

> > If its of any help --
> > =

> > drivers/soc/qcom/mdt_loader.c is the only driver currently using
> > request_firmware_into_buf() however I'll note qcom_mdt_load() is used i=
n many
> > other drivers so they are wrappers around request_firmware_into_buf():
> > =

> > drivers/gpu/drm/msm/adreno/a5xx_gpu.c:   * adreno_request_fw() handles =
this, but qcom_mdt_load() does
> > drivers/gpu/drm/msm/adreno/a5xx_gpu.c:          ret =3D qcom_mdt_load(d=
ev, fw, fwname, GPU_PAS_ID,
> > drivers/gpu/drm/msm/adreno/a5xx_gpu.c:          ret =3D qcom_mdt_load(d=
ev, fw, newname, GPU_PAS_ID,
> > drivers/media/platform/qcom/venus/firmware.c:   ret =3D qcom_mdt_load(d=
ev, mdt, fwname, VENUS_PAS_ID, mem_va, mem_phys,
> > drivers/remoteproc/qcom_adsp_pil.c:     return qcom_mdt_load(adsp->dev,=
 fw, rproc->firmware, adsp->pas_id,
> > drivers/remoteproc/qcom_wcnss.c:        return qcom_mdt_load(wcnss->dev=
, fw, rproc->firmware, WCNSS_PAS_ID,
> > =

> > Are we going to add more IDs for more types of firmware?
> > What type of *different* decisions could LSMs take if the firmware
> > was being written to a buffer? Or in this new case that is coming
> > up, if the file came scraping EFI, would having that information
> > be useful?
> > =

> > > > As such the current IMA code (from v4.17-rc2) actually does
> > > > not handle READING_FIRMWARE_PREALLOC_BUFFER at all, =

> > > =

> > > Right, it doesn't yet address READING_FIRMWARE_PREALLOC_BUFFER, but
> > > should.
> > > =

> > > Depending on whether the device requesting the firmware has access to
> > > the DMA memory, before the signature verification, =

> > =

> > It would seem from the original patch review about READING_FIRMWARE_PRE=
ALLOC_BUFFER
> > that this is not a DMA buffer.
> =

> The call sequence:
> qcom_mdt_load() ->=A0qcom_scm_pas_init_image() ->=A0dma_alloc_coherent()
> =

> If dma_alloc_coherent() isn't allocating a DMA buffer, then the
> function name is misleading/confusing.

Hah, by *definition* the device *and* processor has immediate access
to data written *immediately* when dma_alloc_coherent() is used. From
Documentation/DMA-API.txt:

-----------------------------------------------------------------------
Part Ia - Using large DMA-coherent buffers                                 =
     =

------------------------------------------                                 =
     =

                                                                           =
     =

::                                                                         =
     =

                                                                           =
     =

        void *                                                             =
     =

        dma_alloc_coherent(struct device *dev, size_t size,                =
     =

                           dma_addr_t *dma_handle, gfp_t flag)             =
     =

                                                                           =
     =

Consistent memory is memory for which a write by either the device or      =
     =

the processor can immediately be read by the processor or device           =
     =

without having to worry about caching effects.  (You may however need      =
     =

to make sure to flush the processor's write buffers before telling         =
     =

devices to read that memory.)  =

------------------------------------------------------------------------

Is ptr below

	ret =3D request_firmware_into_buf(&seg_fw, fw_name, dev,  =

					ptr, phdr->p_filesz); =


Also part of the DMA buffer allocated earlier via:

        ret =3D qcom_scm_pas_init_image(pas_id, fw->data, fw->size);       =
       =


Android folks?

> > The device driver should have access to the buffer pointer with write g=
iven
> > that with request_firmware_into_buf() the driver is giving full write a=
ccess to
> > the memory pointer so that the firmware API can stuff the firmware it f=
inds
> > there.
> > =

> > Firmware signature verification would be up to the device hardware to d=
o upon
> > load *after* request_firmware_into_buf().
> =

> We're discussing the kernel's signature verification, not the device
> hardware's signature verification. =A0Can the device driver access the
> buffer, before IMA-appraisal has verified the firmware's signature?

It will depend on the above question.

  Luis

> =

> Mimi
> =

> > =

> >   Luis
> > =

> > > will determine how
> > > IMA-appraisal addresses READING_FIRMWARE_PREALLOC_BUFFER.
> > > =

> > > Mimi
> > > =

> > > > here
> > > > are bits of code from: security/integrity/ima/ima_main.c:
> > > > =

> > > > static int read_idmap[READING_MAX_ID] =3D {
> > > >          [READING_FIRMWARE] =3D FIRMWARE_CHECK,
> > > >          [READING_MODULE] =3D MODULE_CHECK,
> > > >          [READING_KEXEC_IMAGE] =3D KEXEC_KERNEL_CHECK,
> > > >          [READING_KEXEC_INITRAMFS] =3D KEXEC_INITRAMFS_CHECK,
> > > >          [READING_POLICY] =3D POLICY_CHECK
> > > > };
> > > > =

> > > > int ima_post_read_file(struct file *file, void *buf, loff_t size,
> > > > 	...
> > > >          if (!file && read_id =3D=3D READING_FIRMWARE) {
> > > >                  if ((ima_appraise & IMA_APPRAISE_FIRMWARE) &&
> > > >                      (ima_appraise & IMA_APPRAISE_ENFORCE))
> > > >                          return -EACCES; /* INTEGRITY_UNKNOWN */
> > > >                  return 0;
> > > >          }
> > > > =

> > > > Which show that the IMA code is not handling
> > > > READING_FIRMWARE_PREALLOC_BUFFER as it should (I believe it
> > > > should handle it the same as READING_FIRMWARE).
> > > > =

> > > > Now we could fix that, but the only user of
> > > > READING_FIRMWARE_PREALLOC_BUFFER is the code which originally
> > > > introduced it:
> > > > =

> > > > https://patchwork.kernel.org/patch/9162011/
> > > > =

> > > > So I believe it might be better to instead replace it
> > > > with just READING_FIRMWARE and find another way to tell
> > > > kernel_read_file() that there is a pre-allocated buffer,
> > > > perhaps the easiest way there is that  *buf must be
> > > > NULL when the caller wants kernel_read_file() to
> > > > vmalloc the mem. This would of course require auditing
> > > > all callers that the buf which the pass in is initialized
> > > > to NULL.
> > > > =

> > > > Either way adding a third READING_FIRMWARE_FOO to the
> > > > kernel_read_file_id enum seems like a bad idea, from
> > > > the IMA pov firmware is firmware.
> > > > =

> > > > What this whole exercise has shown me though is that
> > > > I need to call security_kernel_post_read_file() when
> > > > loading EFI embedded firmware. I will add a call to
> > > > security_kernel_post_read_file() for v4 of the patch-set.
> > > > =

> > > > > Please Cc Kees in future patches.
> > > > =

> > > > Will do.
> > > > =

> > > > Regards,
> > > > =

> > > > Hans
> > > > =

> > > =

> > > =

> > =

> =

> =


-- =

Do not panic
