From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: Do Qualcomm drivers use DMA buffers for
 request_firmware_into_buf()?
Date: Mon, 25 Jun 2018 17:08:08 -0700
Message-ID: <20180626000808.GE1860@tuxbook-pro>
References: <20180425175557.GY14440@wotan.suse.de>
 <CAB0TPYGnCu+anWHBGvkaigxD--8uHQaQJ2c62kegJ7mTqvkmnA@mail.gmail.com>
 <20180508153805.GC27853@wotan.suse.de>
 <20180601192346.GQ4511@wotan.suse.de>
 <20180606203257.GH4511@wotan.suse.de>
 <20180607161847.GN510@tuxbook-pro>
 <CAKv+Gu8+Fq7BD4XD-YCyXzZh0mg6Z2k-0styj0cw6_uZfaqy4Q@mail.gmail.com>
 <20180607163308.GA18834@kroah.com>
 <20180607182117.GR510@tuxbook-pro>
 <CAKv+Gu9yfa=dP-5Fzv8-E6O23zPJXJqquTAt6gCqYyt3OowkvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9yfa=dP-5Fzv8-E6O23zPJXJqquTAt6gCqYyt3OowkvA@mail.gmail.com>
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
Cc: linux-efi <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, Michal Hocko <mhocko@kernel.org>, David Howells <dhowells@redhat.com>, David Brown <david.brown@linaro.org>, Peter Jones <pjones@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>, linux-security-module <linux-security-module@vger.kernel.org>, Nicolas Broeking <nbroeking@me.com>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Ingo Molnar <mingo@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Andy Gross <andy.gross@linaro.org>, Darren Hart <dvhart@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Todd Kjos <tkjos@android.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@surr>
List-Id: linux-efi@vger.kernel.org

On Thu 07 Jun 11:42 PDT 2018, Ard Biesheuvel wrote:

> On 7 June 2018 at 20:21, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> > On Thu 07 Jun 09:33 PDT 2018, Greg Kroah-Hartman wrote:
[..]
> >>
> >> Why not just use kmalloc, it will always return a DMAable buffer.
> >>
> >
> > For the buffers being targeted by request_firmware_into_buf() the
> > problem is that some of them has requirements of physical placement and
> > they are all too big for kmalloc() (i.e. tens of mb).
> >
> >
> > For the dma_alloc_coherent() buffer that was mentioned earlier, which is
> > not related to the firmware loading, it's not used because the buffer is
> > passed to secure world, which temporarily locks Linux out from the
> > memory region. Traditionally this region was kmalloc'ed downstream, but
> > due to speculative access violations this code moved to use the DMA
> > streaming API, although there's no actual DMA going on.
> >
> 
> OK, so you are relying on the fact that dma_alloc_coherent() gives you
> a device mapping (because the qcom_scm device is described as non
> cache coherent), but this sounds risky to me. The linear alias of that
> memory will still be mapped cacheable, and could potentially still be
> accessed speculatively AFAIK.
> 

Yes and we are aware of the risk of having the linear alias present, but
have yet to find a suitable way to handle this.

The proposed mechanism was to use reserved-memory and memremap() the
region while it should be available in Linux, but while this would work
for some cases (e.g. memory regions for semi-static firmware executed by
co-processors) it doesn't handle the scenarios where the memory-need is
dynamic.

So suggestions are very welcome on how to better handle this.

Regards,
Bjorn
