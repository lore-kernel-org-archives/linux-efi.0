From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH v3 2/5] efi: Add embedded peripheral firmware support
Date: Thu, 7 Jun 2018 09:33:07 -0700
Message-ID: <20180607163307.GO510@tuxbook-pro>
References: <20180408174014.21908-1-hdegoede@redhat.com>
 <20180408174014.21908-3-hdegoede@redhat.com>
 <20180423211143.GZ14440@wotan.suse.de>
 <71e6a45a-398d-b7a4-dab0-8b9936683226@redhat.com>
 <1524586021.3364.20.camel@linux.vnet.ibm.com>
 <20180424234219.GX14440@wotan.suse.de>
 <1524632409.3371.48.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1524632409.3371.48.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>, Alan Cox <alan@linux.intel.com>, Kees Cook <keescook@chromium.org>, Hans de Goede <hdegoede@redhat.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>And
List-Id: linux-efi@vger.kernel.org

On Tue 24 Apr 22:00 PDT 2018, Mimi Zohar wrote:
> On Tue, 2018-04-24 at 23:42 +0000, Luis R. Rodriguez wrote:
> > On Tue, Apr 24, 2018 at 12:07:01PM -0400, Mimi Zohar wrote:
> > > On Tue, 2018-04-24 at 17:09 +0200, Hans de Goede wrote:
[..]
> > > > As such the current IMA code (from v4.17-rc2) actually does
> > > > not handle READING_FIRMWARE_PREALLOC_BUFFER at all, 
> > > 
> > > Right, it doesn't yet address READING_FIRMWARE_PREALLOC_BUFFER, but
> > > should.
> > > 
> > > Depending on whether the device requesting the firmware has access to
> > > the DMA memory, before the signature verification, 
> > 
> > It would seem from the original patch review about READING_FIRMWARE_PREALLOC_BUFFER
> > that this is not a DMA buffer.
> 
> The call sequence:
> qcom_mdt_load() -> qcom_scm_pas_init_image() -> dma_alloc_coherent()
> 

qcom_mdt_load() is passed a struct firmware object, which "data" is
passed into qcom_scm_pas_init_image(), which uses dma_alloc_coherent()
to allocate scratch memory to perform a call into secure world. So the
dma_alloc_coherent() here has nothing to do with firmware loading.

qcom_mdt_load() will then use request_firmware_into_buf() to load other
files into the passed void *mem_region, which either comes from a
memremap() or dma_alloc_coherent() call.

> If dma_alloc_coherent() isn't allocating a DMA buffer, then the
> function name is misleading/confusing.
> 

It does allocate memory.

> > 
> > The device driver should have access to the buffer pointer with write given
> > that with request_firmware_into_buf() the driver is giving full write access to
> > the memory pointer so that the firmware API can stuff the firmware it finds
> > there.
> > 
> > Firmware signature verification would be up to the device hardware to do upon
> > load *after* request_firmware_into_buf().
> 
> We're discussing the kernel's signature verification, not the device
> hardware's signature verification.  Can the device driver access the
> buffer, before IMA-appraisal has verified the firmware's signature?
> 

I would expect that it's possible to read the content of the buffer from
a secondary execution context before the request_firmware_into_buf() has
verified the content of the buffer, but I would be considered a
seriously broken driver.

Regards,
Bjorn
