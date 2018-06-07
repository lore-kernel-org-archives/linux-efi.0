From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Do Qualcomm drivers use DMA buffers for
 request_firmware_into_buf()?
Date: Thu, 7 Jun 2018 18:49:34 +0200
Message-ID: <20180607164934.GA20748@kroah.com>
References: <1524632409.3371.48.camel@linux.vnet.ibm.com>
 <20180425175557.GY14440@wotan.suse.de>
 <CAB0TPYGnCu+anWHBGvkaigxD--8uHQaQJ2c62kegJ7mTqvkmnA@mail.gmail.com>
 <20180508153805.GC27853@wotan.suse.de>
 <20180601192346.GQ4511@wotan.suse.de>
 <20180606203257.GH4511@wotan.suse.de>
 <20180607161847.GN510@tuxbook-pro>
 <CAKv+Gu8+Fq7BD4XD-YCyXzZh0mg6Z2k-0styj0cw6_uZfaqy4Q@mail.gmail.com>
 <20180607163308.GA18834@kroah.com>
 <CAKv+Gu_Ed_npMPG_LQnd+4qfptL_fQc+qC7SaK0qykhYh=9gjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_Ed_npMPG_LQnd+4qfptL_fQc+qC7SaK0qykhYh=9gjA@mail.gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, Michal Hocko <mhocko@kernel.org>, David Howells <dhowells@redhat.com>, David Brown <david.brown@linaro.org>, Peter Jones <pjones@redhat.com>, Arve Hj?nnev?g <arve@android.com>, "H . Peter Anvin" <hpa@zytor.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>, Nicolas Broeking <nbroeking@me.com>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Kalle Valo <kvalo@codeaurora.org>, Andy Gross <andy.gross@linaro.org>, Darren Hart <dvhart@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Todd Kjos <tkjos@android.com>, Kees Cook <keesco>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 07, 2018 at 06:43:05PM +0200, Ard Biesheuvel wrote:
> On 7 June 2018 at 18:33, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > On Thu, Jun 07, 2018 at 06:23:01PM +0200, Ard Biesheuvel wrote:
> >> On 7 June 2018 at 18:18, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> >> > On Wed 06 Jun 13:32 PDT 2018, Luis R. Rodriguez wrote:
> >> >
> >> >> On Fri, Jun 01, 2018 at 09:23:46PM +0200, Luis R. Rodriguez wrote:
> >> >> > On Tue, May 08, 2018 at 03:38:05PM +0000, Luis R. Rodriguez wrote:
> >> >> > > On Fri, May 04, 2018 at 12:44:37PM -0700, Martijn Coenen wrote:
> >> >> > > >
> >> >> > > > I think the Qualcomm folks owning this (Andy, David, Bjorn, already
> >> >> > > > cc'd here) are better suited to answer that question.
> >> >> > >
> >> >> > > Andy, David, Bjorn?
> >> >> >
> >> >> > Andy, David, Bjorn?
> >> >>
> >> >> A month now with no answer...
> >> >>
> >> >
> >> > The patch at the top of this thread doesn't interest me and you didn't
> >> > bother sending your question To me.
> >> >
> >> > As a matter of fact I'm confused to what the actual question is.
> >> >
> >>
> >> The actual question is whether it is really required that the firmware
> >> is loaded by the kernel into a buffer that is already mapped for DMA
> >> at that point, and thus accessible by the device.
> >>
> >> To me, it is not entirely clear what the nature is of the firmware
> >> that we are talking about, since it seems to be getting passed to the
> >> secure world as well?
> >>
> >> In any case, the preferred model in terms of validation/sig checking is
> >>
> >> 1) allocate a CPU accessible buffer
> >>
> >> 2) request the firmware into it (which may include a sig check under the hood)
> >>
> >> 3) map the buffer for DMA to the device so it can load the firmware.
> >>
> >> 4) kick off the DMA transfer.
> >>
> >> The use of dma_alloc_coherent() for this purpose seems unnecessary,
> >> given that the DMA transfer is not bidirectional. Would it be possible
> >> to replace it with something like the above sequence?
> >
> > Why not just use kmalloc, it will always return a DMAable buffer.
> >
> 
> On a PC maybe. But there are plenty of systems where bidirectional DMA
> mappings require uncached memory (i.e., if the device doesn't snoop
> the caches), in which case a kmalloc'ed buffer is useless.
> dma_alloc_coherent() hides the platform constraints from the driver,
> so it is a very useful abstraction for this use case.

kmalloc should always return a DMAble buffer.  If that is not true, we
have a _LOT_ of broken drivers.  What systems is this not true on, and
how are you running USB on them?  :)

thanks,

greg k-h
