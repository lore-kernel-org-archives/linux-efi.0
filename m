From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: Do Qualcomm drivers use DMA buffers for
 request_firmware_into_buf()?
Date: Thu, 7 Jun 2018 09:18:47 -0700
Message-ID: <20180607161847.GN510@tuxbook-pro>
References: <20180423211143.GZ14440@wotan.suse.de>
 <71e6a45a-398d-b7a4-dab0-8b9936683226@redhat.com>
 <1524586021.3364.20.camel@linux.vnet.ibm.com>
 <20180424234219.GX14440@wotan.suse.de>
 <1524632409.3371.48.camel@linux.vnet.ibm.com>
 <20180425175557.GY14440@wotan.suse.de>
 <CAB0TPYGnCu+anWHBGvkaigxD--8uHQaQJ2c62kegJ7mTqvkmnA@mail.gmail.com>
 <20180508153805.GC27853@wotan.suse.de>
 <20180601192346.GQ4511@wotan.suse.de>
 <20180606203257.GH4511@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180606203257.GH4511@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Hans de Goede <hdegoede@redhat.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>, Laura Abbott <labbott@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Martijn Coenen <maco@android.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Stephen Boyd <sboyd@kernel.org>, Vikram Mulukutla <markivx@codeaurora.org>, Arve Hj?nnev?g <arve@android.com>, Todd Kjos <tkjos@android.com>, linux-security-module@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>, Alan Cox <alan@linux.intel.com>, Kees Cook <keescook@chromium.org>, Darren Hart <dvhart@infradead.org>Andy
List-Id: linux-efi@vger.kernel.org

On Wed 06 Jun 13:32 PDT 2018, Luis R. Rodriguez wrote:

> On Fri, Jun 01, 2018 at 09:23:46PM +0200, Luis R. Rodriguez wrote:
> > On Tue, May 08, 2018 at 03:38:05PM +0000, Luis R. Rodriguez wrote:
> > > On Fri, May 04, 2018 at 12:44:37PM -0700, Martijn Coenen wrote:
> > > > 
> > > > I think the Qualcomm folks owning this (Andy, David, Bjorn, already
> > > > cc'd here) are better suited to answer that question.
> > > 
> > > Andy, David, Bjorn?
> > 
> > Andy, David, Bjorn?
> 
> A month now with no answer...
> 

The patch at the top of this thread doesn't interest me and you didn't
bother sending your question To me.

As a matter of fact I'm confused to what the actual question is.

> Perhaps someone who has this hardware can find out empirically for us, as
> follows (mm folks is this right?):
> 
> page = virt_to_page(address);
> if (!page)
>    fail closed...
> if (page_zone(page) == ZONE_DMA || page_zone(page) == ZONE_DMA32)
> 	this is a DMA buffer
> else
> 	not DMA!
> 

Where do you want to put this?

> Note that when request_firmware_into_buf() was being reviewed Mimi had asked back
> in 2016 [0] that if a DMA buffer was going to be used READING_FIRMWARE_DMA should be
> used otherwise READING_FIRMWARE_PREALLOC_BUFFER was fine.
> 
> If it is a DMA buffer *now*, why / how did this change?
> 

>From what I can see [0] says is to use READING_FIRMWARE_PREALLOC_BUFFER
regardless of where the memory comes from.

Regards,
Bjorn

> [0] https://patchwork.kernel.org/patch/9074611/
> 
>   Luis
