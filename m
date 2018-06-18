From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Do Qualcomm drivers use DMA buffers for
 request_firmware_into_buf()?
Date: Tue, 19 Jun 2018 01:49:43 +0200
Message-ID: <20180618234943.GV5527@wotan.suse.de>
References: <20180424234219.GX14440@wotan.suse.de>
 <1524632409.3371.48.camel@linux.vnet.ibm.com>
 <20180425175557.GY14440@wotan.suse.de>
 <CAB0TPYGnCu+anWHBGvkaigxD--8uHQaQJ2c62kegJ7mTqvkmnA@mail.gmail.com>
 <20180508153805.GC27853@wotan.suse.de>
 <20180601192346.GQ4511@wotan.suse.de>
 <20180606203257.GH4511@wotan.suse.de>
 <20180607161847.GN510@tuxbook-pro>
 <CAKv+Gu8+Fq7BD4XD-YCyXzZh0mg6Z2k-0styj0cw6_uZfaqy4Q@mail.gmail.com>
 <20180607180611.GQ510@tuxbook-pro>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20180607180611.GQ510@tuxbook-pro>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, Michal Hocko <mhocko@kernel.org>, David Howells <dhowells@redhat.com>, David Brown <david.brown@linaro.org>, Peter Jones <pjones@redhat.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>, Nicolas Broeking <nbroeking@me.com>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, Arve Hj?nnev?g <arve@android.com>, Ingo Molnar <mingo@redhat.com>, Kalle Valo <kvalo@codeaurora.org>, Andy Gross <andy.gross@linaro.org>, Darren Hart <dvhart@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Todd Kjos <tkjos@android.com>, Kees Cook <keescook@chromium.org>, linux-
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 07, 2018 at 11:06:11AM -0700, Bjorn Andersson wrote:
> On Thu 07 Jun 09:23 PDT 2018, Ard Biesheuvel wrote:
> 
> > On 7 June 2018 at 18:18, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> > > On Wed 06 Jun 13:32 PDT 2018, Luis R. Rodriguez wrote:
> > >
> > >> On Fri, Jun 01, 2018 at 09:23:46PM +0200, Luis R. Rodriguez wrote:
> > >> > On Tue, May 08, 2018 at 03:38:05PM +0000, Luis R. Rodriguez wrote:
> > >> > > On Fri, May 04, 2018 at 12:44:37PM -0700, Martijn Coenen wrote:
> > >> > > >
> > >> > > > I think the Qualcomm folks owning this (Andy, David, Bjorn, already
> > >> > > > cc'd here) are better suited to answer that question.
> > >> > >
> > >> > > Andy, David, Bjorn?
> > >> >
> > >> > Andy, David, Bjorn?
> > >>
> > >> A month now with no answer...
>
> So it's this memremap() region that we pass to
> request_firmware_into_buf() currently, the previously mentioned
> dma_alloc_coherent() region is used as we invoke the secure world
> operation to set up the firmware authentication.

memremap() is for IO memory, and in that sense it is also not much different
from DMA memory in terms of the concerns Mimi has for LSMs and what guarantees
LSMs can make to users.

Regardless of the device, once you write certain data to the IO memory we cannot
be sure the device will wait for all IO to be written, this will be device specific.

As such I would suggest READING_IOMEM for this case have request_firmware_into_buf()
use it.

With that said, since we have only one user of this caller, a future rename
to reflect its current actual use would be good. The rename can wait though.

  Luis
